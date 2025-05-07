import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';

import 'package:frontend/presentation/pages/poses/pose_library_page.dart';
import 'package:frontend/presentation/pages/auth/user_profile_page.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:frontend/presentation/pages/media/media_gallery_page.dart';

import 'package:frontend/presentation/widgets/media_display/formatted_cached_network_image.dart';

import '../../../core/constants/constants.dart';


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

    // Fetch local poses
    context.read<PosesCubit>().getAllPoses(token: user.user.token);
    // TODO add other imports here

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
              print("[HomePage] Error: State is Pose Error");
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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [

                    // ElevatedButton(
                    //     onPressed: _syncPoses,
                    //     child: const Text("Sync Poses")
                    // ),

                    // Pose Library Navigation
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, PoseLibraryPage.route());
                        },
                        child: const Text(
                          "Pose Library",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                        )
                    ),
                    SizedBox(height: 10,),

                    // Media Library Navigation
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MediaGalleryPage.route());
                        },
                        child: const Text(
                            "Media Gallery",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
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
                              fontSize: 20,
                            )
                        )
                    ),
                    SizedBox(height: 10,),

                    const SizedBox(height:30),

                    const Text(
                      "More Features \nComing Soon... \n🙂",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // color: Colors.black,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: "${Constants.backendUrl}/media/data/default/under_construction_gpt.png",
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error, size: 50, color: Colors.red),
                      ),
                    ),
                    
                    // FormattedCachedNetworkImage("${Constants.backendUrl}/media/data/default/under_construction_gpt.png",)


                    // const FormattedCachedNetworkImage(
                    //   "/default/under_construction_gpt.png",
                    // ),

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
