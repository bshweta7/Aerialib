import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/music/domain/entities/music_entity.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

import 'package:frontend/features/music/presentation/cubit/music_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import 'package:frontend/shared/helpers/conversions.dart';

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  List<MusicEntity> _allMusic = [];

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<MusicCubit>().syncMusic(token: user.user.token);
    if (!mounted) return;
    context.read<MusicCubit>().getAllMusic(token: user.user.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToMusicPage(MediaIconEntity mediaItem) {
    context.goNamed(
      'music-view',
      pathParameters: {'musicId': mediaItem.data.id},
      queryParameters: {'from': 'music-library'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AuthCubit>().state;
    final userToken = (userState is AuthLoggedIn) ? userState.user.token : null;

    return MainScaffold(
      currentIndex: 0, // TODO move this to a "media" tab instead of home
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("My Music Ideas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.goNamed(
                'add-new-music',
                queryParameters: {'from': 'music-library'},
              );
            },
            tooltip: 'Add new song',
          ),
        ],
      ),
      body: BlocBuilder<MusicCubit, MusicState>(
        builder: (context, state) {
          if (state is MusicLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MusicError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is GetMusicSuccess) {
            _allMusic = state.musicList;
            final mediaIcons = musicToMediaIcons(_allMusic);

            return Stack(
              children: [
                if (mediaIcons.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No songs yet, try adding one!",
                        style: TextStyle(fontSize: 16, color: Colors.black38),
                      ),
                    ),
                  )
                else
                  MediaList(
                    mediaItems: mediaIcons,
                    onMediaTap: _navigateToMusicPage,
                    scrollController: _scrollController,
                    onFavoriteToggle: (mediaItem) async {
                      if (mediaItem.type == MediaType.music &&
                          mediaItem.data is MusicEntity &&
                          userToken != null) {
                        final music = mediaItem.data as MusicEntity;

                        await context.read<MusicCubit>().toggleFavorite(
                          music: music,
                          token: userToken,
                        );

                        // Re-fetch updated list to reflect favorite state
                        await context.read<MusicCubit>().getAllMusic(token: userToken);
                      }
                    },
                  ),
                ScrollToTopButton(scrollController: _scrollController),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
