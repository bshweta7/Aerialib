import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/conversions.dart';

import 'package:frontend/domain/entities/flow_entity.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';

import 'package:frontend/presentation/pages/flows/flow_details_page.dart';

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

  // TODO - is grid view needed here?

  // TODO Filtering
  List<String> selectedApparatus = Constants.apparatusOptions;

  // Search Bar
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

  // TODO - Filtering
  // void _updateApparatusFilter(List<String> newApparatus) {
  //   setState(() {
  //     selectedApparatus = newApparatus;
  //   });
  // }
  //
  // void _updateLevelsFilter(List<int> newLevels) {
  //   setState(() {
  //     selectedLevels = newLevels;
  //   });
  // }

  // Search Bar
  void _updateSearchQuery(String newQuery) {
    print(newQuery);
    setState(() {
      _searchQuery = newQuery;
    });
  }

  // Navigation
  void _navigateToFlowPage(FlowEntity flow) {
    Navigator.push(context, FlowDetailsPage.route(flow));
  }

  // TODO - should I use this function instead? void _navigateToMediaPage(MediaIconEntity mediaItem) {
  //   Navigator.push(
  //     context,
  //     PoseDetailsPage.route(mediaItem.data),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flows"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO - make addNewFlowPage Navigator.push(context, AddNewPosePage.route());
              },
              tooltip: 'Add a new flow',
            ),
          ]
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
            final flows = state.flows;
            if (flows.isEmpty) {
              return const Center(child: Text("No flows available."));
            }

            // TODO add filtering
            // List<PoseEntity> filteredPoses = state.poses.where(
            //       (elem) =>
            //   selectedApparatus.contains(elem.apparatus) &&
            //       selectedLevels.contains(elem.level),
            // ).toList();
            //
            // List<MediaIconEntity> filteredMediaIcons = posesToMediaIcons(filteredPoses);

            final mediaItems = flowsToMediaIcons(state.flows);

            // Search suggestion list
            final List<FlowEntity> sortedFlows = List<FlowEntity>.from(state.flows)
              ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return Column(
              children: [

                // TODO filters section

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchBarWidget(
                    onSearchChanged: _updateSearchQuery,
                    suggestionList: sortedFlows,
                  ),
                ),

                const SizedBox(height: 15,),

                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            MediaList(
                              mediaItems: mediaItems,
                              onMediaTap: (mediaItem) {
                                _navigateToFlowPage(mediaItem.data as FlowEntity);
                              }, // TODO verify - this doesnt align exactly with the pose library page
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
