import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/poses/cubit/poses_cubit.dart';
import 'package:frontend/features/poses/pages/add_new_pose_page.dart';
import 'package:frontend/features/poses/widgets/media_grid.dart';
import 'package:frontend/features/poses/widgets/pose_card.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  int _gridSize = 3; // Start at 0 and set during the first build
  int _gridSizeMax = 10; // TODO set this dynamically when building
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    context.read<PosesCubit>().getAllPoses(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        print("Wifi Available");
        await context.read<PosesCubit>().syncPoses(user.user.token);

      } else {
        print("No wifi available");
      }
    });
  }

  // Function to handle changing the size of the photo grid
  void _changeGridSize(int amount) {
    // Make sure the grid size can't go below 1 or above the max size

    if (_gridSize > 10) {
      amount *= kIsWeb ? 2 : 1;
    }

    if (amount < 0) {
      if (_gridSize + amount <= 0) {
        _gridSize = 1;
      } else {
        _gridSize += amount;
      }
    } else if (amount > 0) {
      if (_gridSize + amount >= _gridSizeMax) {
        _gridSize = _gridSizeMax;
      } else {
        _gridSize += amount;
      }
    }
    setState(() {
      _gridSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("My Poses"),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, AddNewPosePage.route());
                  },
                  icon: const Icon(CupertinoIcons.add,
                  )
              )
            ]
        ),
        body: BlocBuilder<PosesCubit, PosesState>(
          builder: (context, state) {
            if (state is PoseLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }
            if (state is PoseError) {
              print("AAACK ERROR");
              return Center(child: Column(
                children: [
                  Text("AAACK We got an error :("),
                  Text(state.error),
                ],
              ),);
            }
            if (state is GetPosesSuccess) {
              final poses = state.poses.toList();

              // TODO FILTERING: final poses = state.poses.where(
              //                       (elem) =>
              //                   DateFormat('d').format(elem.dueAt) == DateFormat('d').format(selectedDate) &&
              //                       selectedDate.month == elem.dueAt.month &&
              //                       selectedDate.year == elem.dueAt.year
              //               ).toList();

              print("POSES FROM HOME PAGE");
              print(poses);

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _changeGridSize(1);
                            // Navigator.push(context, AddNewPosePage.route());
                          },
                          icon: const Icon(CupertinoIcons.minus,
                          )
                      ),

                      Text(
                        "Adjust Grid Size"
                      ),

                      IconButton(
                          onPressed: () {
                            _changeGridSize(-1);
                            // Navigator.push(context, AddNewPosePage.route());
                          },
                          icon: const Icon(CupertinoIcons.add,
                          )
                      )


                    ],

                  ),
                  Expanded(child: MediaGrid(poses, _gridSize, "", "")), // TODO remove ""s
                ],
              );
              // return Column(
              //     children: [
              //       Expanded(
              //         child: ListView.builder(
              //             itemCount: poses.length,
              //             itemBuilder: (context, index) {
              //               final pose = poses[index];
              //               return Row(
              //                 children: [
              //                   Expanded(
              //                     child: PoseCard(
              //                         color: pose.color,
              //                         headerText: pose.title,
              //                         descriptionText: pose.description
              //                     ),
              //                   ),
              //                   // Container(
              //                   //   height: 10,
              //                   //   width: 10,
              //                   //   decoration: BoxDecoration(
              //                   //     color: strengthenColor(
              //                   //       pose.color,
              //                   //       0.69,
              //                   //     ),
              //                   //     shape: BoxShape.circle,
              //                   //   ),
              //                   // ),
              //                   // Padding(
              //                   //   padding: const EdgeInsets.all(12.0),
              //                   //   child: Text(
              //                   //       DateFormat.jm().format(pose.dueAt),
              //                   //       style: const TextStyle(
              //                   //         fontSize: 17,
              //                   //       )
              //                   //   ),
              //                   // )
              //
              //                 ],
              //               );
              //             }
              //         ),
              //       )
              //     ]
              // );
            }
            return const SizedBox();
          },
        )
    );
  }
}