import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/conversions.dart';
import 'package:frontend/shared/helpers/formatters.dart';

import 'package:frontend/shared/features/media_display/media_icon_entity.dart';

import 'package:frontend/features/media/presentation/cubit/media_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/features/media_display/widgets/media_list/media_list.dart';
import 'package:frontend/features/media/presentation/widgets/media_filter_sheet.dart';

import '../../../../shared/features/navigation/widgets/smart_back_button.dart';
import '../../../../shared/widgets/main_scaffold.dart';
import '../../domain/entities/media_entity.dart';


class MediaGalleryPage extends StatefulWidget {
  const MediaGalleryPage({super.key});

  @override
  State<MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<MediaGalleryPage> {
  final ScrollController _scrollController = ScrollController();

  // // Filtering
  // final bool _showFilters = false;
  // List<String> selectedApparatus = Constants.apparatusOptions;
  // List<int> selectedLevels = Constants.levelOptions;
  //
  // // Search Bar
  // String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<MediaCubit>().syncMedia(token: user.user.token);
    if (!mounted) return;
    // context.read<MediaCubit>().getAllMedia(token: user.user.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /* TODO: FILTERING:
  Core filters (show by default):
    DONE ✅ Media type (image / video)
    ✅ Shared with me / My media
    ✅ Apparatus / Class Type (e.g. hoop, hammock, silks)
    ✅ Class info (if tracked) — optional
Advanced filters (inside an expandable section or modal):
    📅 Date uploaded range slider
    📸 Date photo taken (if metadata available)
    🎭 Class session (e.g. Tuesday 6PM L2) — if tied to flow/session structure
   */

  // // Filtering
  // void _updateApparatusFilter(List<String> newApparatus) {
  //   setState(() {
  //     selectedApparatus = newApparatus;
  //   });
  // }
  //
  // void _updateMediaTypesFilter(List<String> newMediaTypes) {
  //   setState(() {
  //     selectedMediaTypes = newMediaTypes;
  //   });
  // }
  //
  // // Search Bar
  // void _updateSearchQuery(String newQuery) {
  //   setState(() {
  //     _searchQuery = newQuery;
  //   });
  // }

  void _navigateToMediaPage(MediaIconEntity mediaItem) {
    // TODO make media page
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Media Gallery"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){}, // TODO
            // onPressed: () => context.goNamed('add-new-media'),
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
            // Filtering
            List<MediaEntity> filteredMedia = state.mediaList.toList();
              //   .where(
              //       (elem) =>
              //       selectedApparatus.map((e) => e.toLowerCase()).contains(elem.apparatus.toLowerCase())
              // // selectedLevels.contains(elem.level.floor()),
            // ).toList();

            List<MediaIconEntity> filteredMediaIcons = mediaToMediaIcons(filteredMedia);

            // Search suggestion list
            final List<MediaEntity> sortedMedia = List<MediaEntity>.from(state.mediaList);
              // ..sort((a, b) => a.slug.toLowerCase().compareTo(b.slug.toLowerCase()));

            //
            // // final filteredMedia = state.mediaList;
            // final filteredMedia = state.mediaList.where((media) =>
            // selectedMediaTypes.contains(capitalizeFirstLetter(media.mediaType))
            // // selectedApparatus.contains(media.apparatus)
            //     // && selectedMediaTypes.contains(media.mediaType)
            // ).toList();

            // final mediaIcons = mediaToMediaIcons(filteredMedia);

            // TODO sort by date (or allow user to specify sort by)
            // final sortedMedia = List<MediaEntity>.from(state.media)
            //   ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: MediaSearchBarWidget(
                      //     hintText: 'Search Media',
                      //     onSearchChanged: _updateSearchQuery,
                      //     suggestionList: sortedMedia,
                      //   ),
                      // ),
                      SizedBox(width: 10),
                      // IconButton(
                      //   icon: const Icon(Icons.filter_alt_outlined),
                      //   tooltip: 'Show filters',
                      //   onPressed: () {
                      //     MediaFiltersSheet.showFilterSheet(
                      //       context: context,
                      //       selectedMediaTypes: selectedMediaTypes,
                      //       onMediaTypesChanged: _updateMediaTypesFilter,
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                // if (selectedApparatus.length < Constants.apparatusOptions.length ||
                //     selectedMediaTypes.length < Constants.mediaTypeOptions.length)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Tooltip(
                //           message: '${selectedApparatus.length} Apparatus, ${selectedMediaTypes.length} MediaTypes',
                //           child: Text(
                //             'Filters: ${selectedApparatus.length + selectedMediaTypes.length} Active',
                //             style: Theme.of(context).textTheme.bodyMedium,
                //           ),
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             setState(() {
                //               selectedApparatus = Constants.apparatusOptions;
                //               selectedMediaTypes = Constants.mediaTypeOptions;
                //             });
                //           },
                //           child: const Text('Clear All'),
                //         )
                //       ],
                //     ),
                //   ),
                Expanded(
                  child: Stack(
                    children: [
                      if (filteredMediaIcons.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                            child: Text(
                                "No media, try changing the filters",
                                style: Theme.of(context).textTheme.bodyMedium
                            ),
                          ),
                        )
                      else
                        MediaList(
                          mediaItems: filteredMediaIcons,
                          onMediaTap: _navigateToMediaPage,
                          scrollController: _scrollController,
                        ),

                      // Scroll to top floating button
                      ScrollToTopButton(scrollController: _scrollController), // Add the button

                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      )
    );
  }
}
