// TODO
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/home/pages/test_page.dart';
import 'package:frontend/features/poses/cubit/poses_cubit.dart';
// import 'package:frontend/features/poses/pages/add_new_pose_page.dart';
import 'package:frontend/features/poses/pages/pose_library_page.dart';
import 'package:frontend/features/poses/widgets/pose_media_grid.dart';
import 'package:frontend/features/poses/widgets/pose_card.dart';
import 'package:intl/intl.dart';

import '../../flows/pages/flow_library_page.dart';
import '../../media/pages/media_library_page.dart';


class UserProfilePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const UserProfilePage(),
      );
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().state as AuthLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(context, AddNewPosePage.route());
                  // TODO this should go to edit profile page
                },
                icon: const Icon(CupertinoIcons.pencil,
                )
            )
          ]
        ),

        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {

            // if (state is PoseLoading) {
            //   return const Center(child: CircularProgressIndicator(),);
            // }
            //
            // if (state is PoseError) {
            //   print("Error: State is Pose Error");
            //   return Center(
            //     child: Column(
            //       children: [
            //         const Text("State pose error"),
            //         Text(state.error),
            //       ],
            //     ),
            //   );
            // }

            if (state is AuthLoggedIn) {
              // final poses = state.poses.toList();

              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [

                    // Pose Library Navigation
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            AuthInitial;
                          });
                          Navigator.push(context, LoginPage.route());
                        },
                        child: Text(
                            "Log Out",
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
