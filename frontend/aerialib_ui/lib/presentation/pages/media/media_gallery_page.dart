import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/conversions.dart';

import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/domain/entities/media_entity.dart';

import 'package:frontend/presentation/cubit/media/media_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

// import 'package:frontend/presentation/pages/media/media_details_page.dart';
// import 'package:frontend/presentation/pages/media/add_new_media_page.dart';

// import 'package:frontend/presentation/widgets/filters/media_filter_screen.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
// import 'package:frontend/presentation/widgets/search_bars/media_search_bar.dart';

class MediaGalleryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const MediaGalleryPage());
  const MediaGalleryPage({super.key});

  @override
  State<MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<MediaGalleryPage> {
  final ScrollController _scrollController = ScrollController();

  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<MediaCubit>().getAllMedia(token: user.user.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateApparatusFilter(List<String> newApparatus) {
    setState(() {
      selectedApparatus = newApparatus;
    });
  }

  void _updateLevelsFilter(List<int> newLevels) {
    setState(() {
      selectedLevels = newLevels;
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _navigateToMediaPage(MediaIconEntity mediaItem) {
    // Navigator.push(
    //   context,
    //   MediaDetailsPage.route(mediaItem.data),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Gallery"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigator.push(context, AddNewMediaPage.route());
            },
            tooltip: 'Add new media',
          ),
        ],
      ),
      body: BlocBuilder<MediaCubit, MediaState>(
        builder: (context, state) {
          if (state is MediaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MediaError) {
            return Center(child: Text("Error: ${state.error}"));
          }

          if (state is GetMediaSuccess) {
            final filteredMedia = state.mediaList.where((media) =>
            selectedApparatus.contains(media.apparatus)
                // && selectedLevels.contains(media.level)
            ).toList();

            final mediaIcons = mediaToMediaIcons(filteredMedia);

            // final sortedMedia = List<MediaEntity>.from(state.media)
            //   ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: MediaSearchBarWidget(
                      //     hintText: 'Search Media',
                      //     onSearchChanged: _updateSearchQuery,
                      //     suggestionList: sortedMedia,
                      //   ),
                      // ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        tooltip: 'Show filters',
                        onPressed: () {
                          // MediaFilters.showFilterSheet(
                          //   context: context,
                          //   selectedApparatus: selectedApparatus,
                          //   selectedLevels: selectedLevels,
                          //   onApparatusChanged: _updateApparatusFilter,
                          //   onLevelsChanged: _updateLevelsFilter,
                          // );
                        },
                      ),
                    ],
                  ),
                ),
                if (selectedApparatus.length < Constants.apparatusOptions.length ||
                    selectedLevels.length < Constants.levelOptions.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Tooltip(
                          message: '${selectedApparatus.length} Apparatus, ${selectedLevels.length} Levels',
                          child: Text(
                            'Filters: ${selectedApparatus.length + selectedLevels.length} Active',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedApparatus = Constants.apparatusOptions;
                              selectedLevels = Constants.levelOptions;
                            });
                          },
                          child: const Text('Clear All'),
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            MediaList(
                              mediaItems: mediaIcons,
                              onMediaTap: _navigateToMediaPage,
                            ),
                          ],
                        ),
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
