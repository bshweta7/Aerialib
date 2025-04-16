// TODO Implement this library.import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/data/services/connectivity_service.dart';
import 'package:frontend/pages/home/test_page.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/pages/poses/pose_library_page.dart';
import 'package:frontend/pages/auth/user_profile_page.dart';
import 'package:frontend/pages/flows/flow_library_page.dart';
import 'package:frontend/pages/media/media_library_page.dart';


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

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    // Fetch local poses and sync remote ones if needed
    context.read<PosesCubit>().getAllPoses(token: user.user.token);
    // TODO add other imports here

    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi) || data.contains(ConnectivityResult.ethernet)) { // TODO add other options, possibly move to connectivity_service.dart
        print("Wifi Available");
        await context.read<PosesCubit>().syncPoses(user.user.token);

      } else {
        print("No wifi available");
      }
    });

    // TODO - Consider caching the last sync time in shared prefs (via sp_service.dart maybe?)
    // TODO - move this "import data" logic to a StartupManager or AppInitializer class for even cleaner structure

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("My Dashboard"),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, UserProfilePage.route());
                  },
                  tooltip: "Visit profile page",
                  icon: const Icon(CupertinoIcons.profile_circled,
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
              print("Error: State is Pose Error");
              return Center(
                child: Column(
                  children: [
                    const Text("State pose error"),
                    Text(state.message.toString()),
                  ],
                ),
              );
            }

            if (state is GetPosesSuccess) {
              // final poses = state.poses.toList();

              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [

                    // Pose Library Navigation
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, PoseLibraryPage.route());
                        },
                        child: const Text(
                          "Pose Library",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          )
                        )
                    ),
                    SizedBox(height: 10,),

                    // Media Library Navigation
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MediaLibraryPage.route());
                        },
                        child: const Text(
                            "Media Library",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            )
                        )
                    ),
                    SizedBox(height: 10,),

                    // Flow Library Navigation
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, FlowLibraryPage.route());
                        },
                        child: const Text(
                            "Flow Library",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            )
                        )
                    ),
                    SizedBox(height: 10,),

                    const SizedBox(height:30),

                    const Text(
                      "Dashboard is under development",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // TEST PAGE Navigation
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, TestPage.route());
                        },
                        child: const Text(
                            "TEST PAGE",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            )
                        )
                    ),
                    SizedBox(height: 10,),

                    // TODO add these to github tickets
                    //  Expanded(
                    //   child: Text(
                    //     "Upcoming Features\n"
                    //         "Flow Library (stores your flows)\n"
                    //         "Share flows with other instructors\n"
                    //         "Journal to keep a record of what flow you teach on which day (session) to which students\n"
                    //         "Student profile pages (with level and past attendance and *personal goals*)\n"
                    //         "Conditioning library\n"
                    //         "Customized flow creation page - enter students and their goals pop up (potentially with suggested poses and conditioning to help)\n"
                    //         "Upload your own images/videos and tag them by pose\n"
                    //         "Share images/videos you upload with people who are tagged in it"
                    //     ,
                    //     style: TextStyle(
                    //       // fontWeight: FontWeight.bold,
                    //       color: Colors.purple.shade900,
                    //       fontSize: 20,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),


                    // TODO implement Media Library with Uploads
                    // TODO filter media by default (uploadedBy admin account) vs user's own uploads vs. shared with user but uploaded by someone else.
                    // TODO filter by type (img vs video)
                    // Media Library Navigation
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(context, MediaLibraryPage.route());
                    //     },
                    //     child: Text("GO TO MEDIA LIBRARY")
                    // ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        )
    );
  }
}
