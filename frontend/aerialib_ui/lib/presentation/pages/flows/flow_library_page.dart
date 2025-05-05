import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';

import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

import 'package:frontend/presentation/pages/flows/flow_poses_page.dart';
import 'package:frontend/presentation/pages/flows/add_new_flow_page.dart';
import 'package:frontend/presentation/widgets/filters/flow_filter_screen.dart';

import 'package:frontend/presentation/widgets/filters/pose_filter_screen.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/presentation/widgets/search_bars/flow_search_bar.dart';


class FlowLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const FlowLibraryPage());

  const FlowLibraryPage({super.key});

  @override
  State<FlowLibraryPage> createState() => _FlowLibraryPageState();
}

class _FlowLibraryPageState extends State<FlowLibraryPage> {
  final ScrollController _scrollController = ScrollController();

  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
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

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _navigateToFlowPage(MediaIconEntity mediaItem) {
    Navigator.push(
      context,
      FlowPosesPage.route(mediaItem.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flows"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, AddNewFlowPage.route());
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
            final List<FlowEntity> filteredFlows = state.flows.where((flow) {
              return selectedApparatus.contains(flow.apparatus) &&
                  selectedLevels.contains(flow.level);
            }).toList();

            final List<MediaIconEntity> mediaIcons = filteredFlows.map((flow) => MediaIconEntity(
              imageUrl: flow.thumbnailImagePath,
              title: flow.name,
              subtitle: "Level ${flow.level} | ${flow.apparatus}",
              type: MediaType.flow,
              data: flow,
            )).toList();

            final List<FlowEntity> sortedFlows = List.from(state.flows)
              ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlowSearchBarWidget(
                          hintText: 'Search Flows',
                          onSearchChanged: _updateSearchQuery,
                          suggestionList: sortedFlows,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        tooltip: 'Show filters',
                        onPressed: () {
                          FlowFilters.showFilterSheet(
                            context: context,
                            selectedApparatus: selectedApparatus,
                            selectedLevels: selectedLevels,
                            onApparatusChanged: _updateApparatusFilter,
                            onLevelsChanged: _updateLevelsFilter,
                          );
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
                            child: Text(
                              "No flows, try changing the filters or adding one!",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38),
                            ),
                          ),
                        )
                      else
                        SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              MediaList(
                                mediaItems: mediaIcons,
                                onMediaTap: _navigateToFlowPage,
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
