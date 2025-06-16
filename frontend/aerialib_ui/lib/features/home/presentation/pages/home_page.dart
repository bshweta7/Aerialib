import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/music/presentation/cubit/music_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/features/home/presentation/widgets/quick_add/quick_add_category.dart';

import '../../cubit/home_cubit.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Call HomeCubit initialization once when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().initializeHome(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    log('[HomePage] Building HomePage UI');

    final authState = context.watch<AuthCubit>().state;
    String currentUsername = "guest";
    String? userToken;
    String userId = "";

    if (authState is AuthLoggedIn) {
      currentUsername = authState.user.username;
      userToken = authState.user.token;
      userId = authState.user.id;
    }

    return MainScaffold(
      currentIndex: 0,
      appBar: AppBar(
        title: Text("${capitalizeFirstLetter(currentUsername)}'s Dashboard"),  // TODO use first name if available or username
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed('user-profile');
            },
            tooltip: "Visit profile page",
            icon: const Icon(CupertinoIcons.profile_circled),
          )
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(child: Text('Sync error: ${state.message}'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  "📚 Welcome to Aerialib",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Your Personal Aerial Library",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Select a library to get started.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // 2x2 Grid for Libraries
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // use a softer color for better aesthetics
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.5,
                    children: [
                      _buildLibraryButton(
                        context,
                        icon: Icons.accessibility_new,
                        label: 'Pose Library',
                        routeName: 'pose-library',
                        description: 'Explore poses and learn more about them'
                      ),
                      _buildLibraryButton(
                          context,
                          icon: Icons.loop,
                          label: 'Flow Library',
                          routeName: 'flow-library',
                          description: 'Create or manage your flows'
                      ),
                      _buildLibraryButton(
                        context,
                        icon: Icons.sync_alt,
                        label: 'Transitions Library',
                        routeName: 'transition-library',
                        description: 'Find new transitions between poses'
                      ),
                      _buildLibraryButton(
                          context,
                          icon: Icons.music_note,
                          label: 'Music Library',
                          routeName: 'music-library',
                          description: 'Store song ideas for your next performance'
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ElevatedButton(
                //   onPressed: () => context.goNamed('music-library', queryParameters: {'from': 'home'}),
                //   child: const Text("Music Library", style: TextStyle(fontSize: 20)),
                // ),
                // const SizedBox(height: 30),
                // ElevatedButton(
                //   onPressed: () => context.goNamed('media-gallery', queryParameters: {'from': 'home'}),
                //   child: const Text("Media Library", style: TextStyle(fontSize: 20)),
                // ),
                // const SizedBox(height: 30),

                // TODO - maybe switch to modal for everything instead of having textboxes on the dashboard itself... might look cleaner?
                QuickAddCategoryCard(
                  onMusicSubmit: (name, description, isFavorite) async {
                    if (authState is! AuthLoggedIn) return;
                    final user = authState.user;
                    await context.read<MusicCubit>().createNewMusic(
                      name: name,
                      performanceNotes: description,
                      favorite: isFavorite,
                      token: user.token,
                      userId: user.id,
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Developed in collaboration with Uplift Aerial Arts.",
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(
                    width: 250,
                    height: 150,
                    child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: const FormattedCachedNetworkImage('default/uplift.jpg'))
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}



Widget _buildLibraryButton(
    BuildContext context, {
      required IconData icon,
      required String label,
      required String routeName,
      required String description,
    }) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Example threshold: Show full content if width > 160
      final bool showText = constraints.maxWidth > 200;

      return Tooltip(
        message: '$label\n$description',
        textAlign: TextAlign.center,
        waitDuration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade100,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => context.goNamed(routeName, queryParameters: {'from': 'home'}),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36),
              if (showText) ...[
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}




            // // Opinion Poll Navigation
            // ElevatedButton(
            //     onPressed: () {
            //       context.pushNamed('opinion-poll');
            //     },
            //     child: const Text(
            //         "Vote Now",
            //         style: TextStyle(
            //           fontSize: 20,
            //         )
            //     )
            // ),


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
