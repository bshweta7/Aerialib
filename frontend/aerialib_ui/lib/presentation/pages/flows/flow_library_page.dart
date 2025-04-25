import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/conversions.dart';

import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';

import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/pages/poses/pose_view_page.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid/media_grid_utils.dart';
import 'package:frontend/presentation/widgets/functional_buttons/filters/pose_filter.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid/media_grid.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/presentation/widgets/functional_buttons/search_bar.dart';


import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

import '../../../domain/entities/flow_entity.dart';
import '../../cubit/flows/flows_cubit.dart';
import 'flow_details_page.dart';

class FlowLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const FlowLibraryPage());

  const FlowLibraryPage({super.key});

  @override
  State<FlowLibraryPage> createState() => _FlowLibraryPageState();
}

class _FlowLibraryPageState extends State<FlowLibraryPage> {
  final ScrollController _scrollController = ScrollController();

  // TODO ADD THESE
  // Filtering
  // List<String> selectedApparatus = Constants.apparatusOptions;
  // List<int> selectedLevels = Constants.levelOptions;
  //
  // // Search Bar
  // String _searchQuery = '';

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

  // Navigation
  void _navigateToFlowDetail(FlowEntity flow) {
    Navigator.push(context, FlowDetailPage.route(flow));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flows"),
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

            final mediaItems = flowsToMediaIcons(state.flows);

            return Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      MediaList(
                        mediaItems: mediaItems,
                        onMediaTap: (mediaItem) {
                          _navigateToFlowDetail(mediaItem.data as FlowEntity);
                        },
                      ),
                    ],
                  ),
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
