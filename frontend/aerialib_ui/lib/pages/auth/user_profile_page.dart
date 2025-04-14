// TODO
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/pages/auth/login_page.dart';



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
            if (state is AuthLoggedIn) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [

                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        // Optionally navigate to the login screen or perform other actions
                        Navigator.push(context, LoginPage.route());
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        )
                      )
                    )



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
