import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/presentation/pages/poses/pose_library_page.dart';
import 'package:frontend/presentation/pages/auth/user_profile_page.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:frontend/presentation/pages/media/media_gallery_page.dart';

import 'feedback_form.dart';



class HomePage extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('[HomePage] Building HomePage UI');

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

      body: SingleChildScrollView(
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
            const SizedBox(height: 10,),

            // Media Library Navigation
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(context, MediaGalleryPage.route());
            //     },
            //     child: const Text(
            //         "Media Gallery",
            //         style: TextStyle(
            //           // fontWeight: FontWeight.bold,
            //           fontSize: 20,
            //         )
            //     )
            // ),
            // const SizedBox(height: 10,),

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
            const SizedBox(height: 10,),

            const SizedBox(height:30),

            const Text(
              "More Features Coming Soon... 🙂",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: Colors.black,
                fontSize: 24,
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

            const SizedBox(height: 10,),

            const Text(
              "Have an idea or found a bug? We'd love to hear from you!",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                // color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),

            // Feedback Form Navigation
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, SubmitFeedbackPage.route());
                },
                child: const Text(
                    "Submit Feedback",
                    style: TextStyle(
                      fontSize: 20,
                    )
                )
            ),
            const SizedBox(height: 10,),



            // FormattedCachedNetworkImage("${Constants.backendUrl}/media/data/default/under_construction_gpt.png",)

            // const SizedBox(height: 20),
            // const Text(
            //   "Upcoming Features:",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     // color: Colors.black,
            //     fontSize: 18,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            //
            // const Text("Transitions library: See how to transition from one pose to another"),
            // const Text("Conditioning/Stretching library: See all conditioning and warm-up/cool-downs"),
            // const Text("Upgraded flow creation page: Suggest next pose based on transition library"),
            // const Text("Upgraded flow creation page: Attach poses in a flow to lyrics in a song"),
            // const Text("Flow sharing: Share flows with students or instructors"),
            // const Text("Media gallery: Upload all of your aerial photos/videos and add tags to stay organized and make photos easy to find"),
            // const Text("Pose history: Shows your progression over time for any pose using your media gallery"),
            // const Text("Session Tracker: Keep track of which poses/flows you did each session"),
            // const Text("Goal Tracker: Set goals and monitor your progress towards them"),
            // const Text("Student Pages: Instructors can see student's level, recent attendance, and personal goals"),
            // const Text("Classes: Instructors select all students in a class and flows will automatically be added to their profile"),
            // const Text("Instructor flow creation page: Enter students in the class to see students' goals listed clearly and get suggested poses based on students goals"),
            // const Text("Media sharing: Share media with all the students in the class or with people who are tagged in it"),
          ],
        ),
      ),
    );
  }
}
