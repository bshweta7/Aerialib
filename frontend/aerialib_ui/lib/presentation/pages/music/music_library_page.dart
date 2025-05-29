import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/presentation/widgets/main_scaffold.dart'; // TODO main scaffold should be moved to core (not presentation)
import 'package:frontend/presentation/widgets/navigation/smart_back_button.dart';
// import 'package:frontend/presentation/widgets/search_bars/generic_search_bar.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';

import 'package:frontend/domain/entities/music_entity.dart';
import 'package:frontend/presentation/cubit/music/music_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<MusicCubit>().syncMusic(token: user.user.token);
    if (!mounted) return;
    await context.read<MusicCubit>().getAllMusic(token: user.user.token);
  }

  void _updateSearchQuery(String newQuery) {
    log("[MusicLibraryPage] search: $newQuery");
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _navigateToMusicDetail(MusicEntity music) {
    context.goNamed(
      'music-view',
      pathParameters: {'musicId': music.id},
      queryParameters: {'from': 'music-library'},
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0, // adjust as needed for nav
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Music Library"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.goNamed('add-new-music');
            },
            tooltip: 'Add a new song',
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
            final List<MusicEntity> filteredMusic = state.musicList.where((song) {
              final q = _searchQuery.toLowerCase();
              return _searchQuery.isEmpty ||
                  song.name.toLowerCase().contains(q) ||
                  (song.artist?.toLowerCase().contains(q) ?? false) ||
                  (song.mood?.toLowerCase().contains(q) ?? false);
            }).toList();

            return Column(
              children: [
                // TODO
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                //   child: GenericSearchBar(
                //     hintText: 'Search Music',
                //     onSearchChanged: _updateSearchQuery,
                //     suggestionList: state.musicList.map((e) => e.name).toList(),
                //   ),
                // ),
                Expanded(
                  child: Stack(
                    children: [
                      if (filteredMusic.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "No music found. Try adding or changing your search.",
                              style: TextStyle(fontSize: 16, color: Colors.black38),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          controller: _scrollController,
                          itemCount: filteredMusic.length,
                          itemBuilder: (context, index) {
                            final song = filteredMusic[index];
                            return ListTile(
                              title: Text(song.name),
                              subtitle: Text(song.artist ?? 'Unknown Artist'),
                              trailing: song.favorite ? const Icon(Icons.favorite, color: Colors.red) : null,
                              onTap: () => _navigateToMusicDetail(song),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(height: 1),
                        ),

                      ScrollToTopButton(scrollController: _scrollController),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
