import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/conversions.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/widgets/filter_sheet.dart';
import '../../../../shared/widgets/search_bar.dart';


class FlowLibraryPage extends StatefulWidget {
  const FlowLibraryPage({super.key});

  @override
  State<FlowLibraryPage> createState() => _FlowLibraryPageState();
}

class _FlowLibraryPageState extends State<FlowLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  List<FlowEntity> _allFlows = [];

  // Filtering
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  List<String> selectedShareStatus = Constants.shareStatusOptions;

  // Search Bar
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<PosesCubit>().syncPoses(token: user.user.token);
    if (!mounted) return;
    await context.read<FlowsCubit>().syncFlows(token: user.user.token);
    if (!mounted) return;
    context.read<FlowsCubit>().getAllFlows(token: user.user.token); // TODO remove this if sync can return the flows
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToFlowPage(MediaIconEntity mediaItem) {
    context.goNamed(
      'flow-view',
      pathParameters: {'flowId': mediaItem.data.id},
      queryParameters: {'from': 'flow-library'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isScrollable: false,
      currentIndex: 1,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Flows"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.goNamed(
                'add-new-flow',
                queryParameters: {'from': 'flow-library'},
              );
            },
            tooltip: 'Add a new flow',
          ),
        ],
      ),
      body: BlocBuilder<FlowsCubit, FlowsState>(
        builder: (context, state) {
          if (state is FlowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FlowError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is GetFlowsSuccess) {
            _allFlows = state.flows;

            /// Filter Entities
            List<FlowEntity> filteredFlows = state.flows.where((elem) {
              final matchesApparatus = selectedApparatus.map((e) => e.toLowerCase()).contains(elem.apparatus.toLowerCase());
              final matchesQuery = elem.name.toLowerCase().contains(_searchQuery.toLowerCase());
              final matchesLevel = selectedLevels.contains(elem.level?.floor() ?? -1);
              return matchesApparatus && matchesQuery && matchesLevel;
            }).toList();

            // TODO filter share status here too? might need to add a column in flows local db after creating the shareTable remotely (join remotely and then send).

            final List<MediaIconEntity> mediaIcons = flowsToMediaIcons(filteredFlows);

            // TODO - add sort by

            return Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [

                      /// Search Bar
                      Expanded(
                        child: LibrarySearchBar<FlowEntity>(
                          hintText: 'Search Flows',
                          suggestions: filteredFlows,
                          getDisplayText: (flow) => flow.name,
                          onSearchChanged: (query) => setState(() => _searchQuery = query),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// Filter Icon Button
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        tooltip: 'Show filters',
                        onPressed: () {
                          FiltersSheet.show<String>(
                            context: context,
                            filterOptions: {
                              'Level': Constants.levelOptions.map((e) => e.toString()).toList(),
                              'Apparatus': Constants.apparatusOptions,
                            },
                            selectedFilters: {
                              'Level': selectedLevels.map((e) => e.toString()).toList(),
                              'Apparatus': selectedApparatus,
                            },
                            onFilterChanged: (category, values) {
                              setState(() {
                                if (category == 'Apparatus') {
                                  selectedApparatus = values;
                                } else if (category == 'Level') {
                                  selectedLevels = values.map(int.parse).toList();
                                }
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),


                if (selectedApparatus.length < Constants.apparatusOptions.length ||
                    selectedLevels.length < Constants.levelOptions.length)
                  // TODO room for optimization here
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
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: Stack(
                    children: [
                      if (mediaIcons.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text( // TODO move this to Media List?
                              "No flows match your filters",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38),
                            ),
                          ),
                        )
                      else

                        Padding(
                          padding: const EdgeInsets.only(right: 1), // optional: gives scrollbar space
                          child: MediaList(
                            mediaItems: mediaIcons,
                            onMediaTap: _navigateToFlowPage,
                            scrollController: _scrollController,
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
