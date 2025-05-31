import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/conversions.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/shared/features/media_display/media_icon_entity.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import 'package:frontend/features/flow/presentation/widgets/flow_filter_sheet.dart';
import 'package:frontend/shared/widgets/scroll_to_top.dart';
import 'package:frontend/shared/features/media_display/widgets/media_list/media_list.dart';
import 'package:frontend/features/flow/presentation/widgets/flow_search_bar.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';


class FlowLibraryPage extends StatefulWidget {
  const FlowLibraryPage({super.key});

  @override
  State<FlowLibraryPage> createState() => _FlowLibraryPageState();
}

class _FlowLibraryPageState extends State<FlowLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  List<FlowEntity> _allFlows = [];

  // Filtering
  final bool _showFilters = false;
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
    context.read<FlowsCubit>().getAllFlows(token: user.user.token);
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

  void _updateShareStatusFilter(List<String> newShareStatuses) {
    setState(() {
      selectedShareStatus = newShareStatuses;
    });
  }
  
  void _updateSearchQuery(String newQuery) {
    setState(() {_searchQuery = newQuery;});
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

            // Filtering
            List<FlowEntity> filteredFlows = state.flows.where(
                  (elem) =>
              selectedApparatus.map((e) => e.toLowerCase()).contains(elem.apparatus.toLowerCase()) &&
                  selectedLevels.contains(elem.level.floor()) ||
                  (selectedLevels.contains(-1) && !Constants.levelOptions.contains(elem.level.floor())),
            ).toList();
            // TODO filter share status here too? might need to add a column in flows local db after creating the shareTable remotely (join remotely and then send).

            final List<MediaIconEntity> mediaIcons = flowsToMediaIcons(filteredFlows);

            // Search suggestion list
            final List<FlowEntity> sortedFlows = List.from(state.flows)
              ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
            // TODO - add sort by

            return Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [

                      // Search Bar
                      Expanded(
                        child: FlowSearchBarWidget(
                          hintText: 'Search Flows',
                          onSearchChanged: _updateSearchQuery,
                          suggestionList: sortedFlows,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Filter Icon Button
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        tooltip: 'Show filters',
                        onPressed: () {
                          FlowFiltersSheet.showFilterSheet(
                            context: context,
                            selectedApparatus: selectedApparatus,
                            selectedLevels: selectedLevels,
                            selectedShareStatus: selectedShareStatus,
                            onApparatusChanged: _updateApparatusFilter,
                            onLevelsChanged: _updateLevelsFilter,
                            onShareStatusChanged: _updateShareStatusFilter,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // TODO move this part to a separate widget or to the flowFilterSheet page
                // Show active filters if any filters selected
                if (selectedApparatus.length < Constants.apparatusOptions.length ||
                    selectedLevels.length < Constants.levelOptions.length)
                  // TODO add share status here
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
                              "No flows, try changing the filters!",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38),
                            ),
                          ),
                        )
                      else

                        MediaList(
                          mediaItems: mediaIcons,
                          onMediaTap: _navigateToFlowPage,
                          scrollController: _scrollController,
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
