import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/conversions.dart';
import 'package:frontend/core/utils/formatters.dart';

import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/domain/entities/media_entity.dart';

import 'package:frontend/presentation/cubit/media/media_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/media/upload_new_media_page.dart';

// import 'package:frontend/presentation/pages/media/media_details_page.dart';
// import 'package:frontend/presentation/pages/media/add_new_media_page.dart';

// import 'package:frontend/presentation/widgets/filters/media_filter_sheet.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/filters/media_filter_sheet.dart';
// import 'package:frontend/presentation/widgets/search_bars/media_search_bar.dart';

class MediaGalleryPage extends StatefulWidget {
  const MediaGalleryPage({super.key});

  @override
  State<MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<MediaGalleryPage> {
  final ScrollController _scrollController = ScrollController();

  List<String> selectedApparatus = Constants.apparatusOptions;
  List<String> selectedMediaTypes = Constants.mediaTypeOptions;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<MediaCubit>().syncMedia(token: user.user.token);
    if (!mounted) return;
    context.read<MediaCubit>().getAllMedia(token: user.user.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /* TODO Search Bar:
    Search field: name (fallback to partial match).
    Optional: also include description, if populated often.
    Why: Users will likely remember keywords like “split” or “back bend” more than exact dates or file names.
   */

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

  void _updateApparatusFilter(List<String> newApparatus) {
    setState(() {
      selectedApparatus = newApparatus;
    });
  }

  void _updateMediaTypesFilter(List<String> newMediaTypes) {
    setState(() {
      selectedMediaTypes = newMediaTypes;
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
            onPressed: () => context.goNamed('add-new-media'),
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
            // final filteredMedia = state.mediaList;
            final filteredMedia = state.mediaList.where((media) =>
            selectedMediaTypes.contains(capitalizeFirstLetter(media.type))
            // selectedApparatus.contains(media.apparatus)
                // && selectedMediaTypes.contains(media.mediaType)
            ).toList();

            final mediaIcons = mediaToMediaIcons(filteredMedia);

            // TODO sort by date (or allow user to specify sort by)
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
                          MediaFiltersSheet.showFilterSheet(
                            context: context,
                            selectedMediaTypes: selectedMediaTypes,
                            onMediaTypesChanged: _updateMediaTypesFilter,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (selectedApparatus.length < Constants.apparatusOptions.length ||
                    selectedMediaTypes.length < Constants.mediaTypeOptions.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Tooltip(
                          message: '${selectedApparatus.length} Apparatus, ${selectedMediaTypes.length} MediaTypes',
                          child: Text(
                            'Filters: ${selectedApparatus.length + selectedMediaTypes.length} Active',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedApparatus = Constants.apparatusOptions;
                              selectedMediaTypes = Constants.mediaTypeOptions;
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
