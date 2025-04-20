import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid_utils.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/widgets/media_list/list_card.dart';

import 'package:frontend/to_sort/cubit/auth_cubit.dart';
import 'package:frontend/to_sort/pages/widgets/multi_selector.dart';
import 'package:frontend/to_sort/pages/widgets/search_bar.dart';
import 'package:frontend/to_sort/pages/poses/add_new_pose_page.dart';
import 'package:frontend/domain/repositories/pose_repository_impl.dart';
import '../../../core/utils/conversions.dart';
import '../../../domain/entities/media_icon_entity.dart';
import '../../widgets/floating_buttons/scroll_to_top.dart';
import '../../widgets/media_display/media_grid.dart';
import '../../widgets/media_list/media_list.dart';

// import 'package:frontend/'


class PoseLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const PoseLibraryPage(),
      );
  const PoseLibraryPage({super.key});

  @override
  State<PoseLibraryPage> createState() => _PoseLibraryPageState();
}

class _PoseLibraryPageState extends State<PoseLibraryPage> {

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  int _gridSize = 3; // Start at 0 and set during the first build
  int _gridSizeMax = 10; // TODO set this dynamically when building
  String _searchQuery = ''; // To store the current search query
  final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  bool _isContainerVisible = false; // Initially hidden
  bool _areOptionsVisible = false; // Track visibility

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<PosesCubit>().getAllPoses(token: user.user.token);
  }

  void changeGridSize(int amount) {
    // Detect current width and calculate a maximum grid size (column count)
    Size windowSize = MediaQuery.of(context).size;
    _gridSize = calculateNewGridSize(amount, _gridSize, windowSize, kDebugMode);
    setState(() {
      _gridSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Pose Library"),
          centerTitle: true,
        ),

        body: BlocBuilder<PosesCubit, PosesState>(
          builder: (context, state) {

            if (state is PoseLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is PoseError) {
              print("ERROR: State is Pose Error");
              print(state.message);
              return const Center(
                child: Column(
                  children: [
                    Text("State pose error"),
                  ],
                ),
              );
            }

            if (state is GetPosesSuccess) {

              // TODO move filtereing to cubit?
              List<PoseEntity> filteredPoses = state.poses.where(
                    (elem) =>
                selectedApparatus.contains(elem.apparatus) &&
                    selectedLevels.contains(elem.level),
              ).toList();

              print(filteredPoses);

              List<MediaIconEntity> filteredMediaIcons = posesToMediaIcons(filteredPoses);

              print(filteredMediaIcons);

              return Stack(
                children: [
                  // List poses
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: MediaList(mediaItems: filteredMediaIcons)
                  ),

                  // Scroll to top floating button
                  ScrollToTopButton(scrollController: _scrollController), // Add the button
                ],
              );
            }
            return const SizedBox();
          },
        )
    );
  }
}