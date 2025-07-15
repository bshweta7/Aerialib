import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_image.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Call HomeCubit initialization once when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().initializeHome(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('[HomePage] Building HomePage UI');

    final authState = context.watch<AuthCubit>().state;
    String currentUsername = "guest";
    String? userToken;
    String userId = "";

    final buttonConfigs = [
      (
        icon: Icons.accessibility_new,
        label: 'Pose Library',
        routeName: 'pose-library',
        description: 'Explore poses and learn more about them',
      ),
      (
        icon: Icons.loop,
        label: 'Flow Library',
        routeName: 'flow-library',
        description: 'Create or manage your flows',
      ),
      (
        icon: Icons.sync_alt,
        label: 'Transitions Library',
        routeName: 'transition-library',
        description: 'Find new transitions between poses',
      ),
      // (
      //   icon: Icons.music_note,
      //   label: 'Music Library',
      //   routeName: 'music-library',
      //   description: 'Store song ideas for your next performance',
      // ),
    ];

    final adminButtonConfigs = [
      (
        icon: Icons.people,
        label: 'Admin Users Dashboard',
        routeName: 'admin-users',
        description: 'See all user info',
      ),
      (
        icon: Icons.loop,
        label: 'Admin Flows Dashboard',
        routeName: 'admin-flows',
        description: 'See all flows',
      ),
    ];

    if (authState is AuthLoggedIn) {
      currentUsername = authState.user.username;
      userToken = authState.user.token;
      userId = authState.user.id;
    }

    return MainScaffold(
      currentIndex: 0,
      scrollController: _scrollController,
      isScrollable: true,
      isScrollbarVisible: false,
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
                // const SizedBox(height: 10),
                // const Text(
                //   "Select a library to get started.",
                //   style: TextStyle(fontSize: 18),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 20),


                // List of Buttons for Libraries
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: buttonConfigs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final button = buttonConfigs[index];
                    return _buildLibraryButton(
                      context,
                      icon: button.icon,
                      label: button.label,
                      routeName: button.routeName,
                      description: button.description,
                    );
                  },
                ),

                if (currentUsername == 'admin') ...[
                  const SizedBox(height: 10),
                  const Divider(),

                  const Text(
                    "🔐 Admin Dashboards",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: adminButtonConfigs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final button = adminButtonConfigs[index];
                      return _buildLibraryButton(
                        context,
                        icon: button.icon,
                        label: button.label,
                        routeName: button.routeName,
                        description: button.description,
                      );
                    },
                  ),

                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     context.go('/admin/users');
                  //   },
                  //   icon: const Icon(Icons.admin_panel_settings),
                  //   label: const Text('Admin Users Dashboard'),
                  // ),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     context.go('/admin/flows');
                  //   },
                  //   icon: const Icon(Icons.admin_panel_settings),
                  //   label: const Text('Admin Flows Dashboard'),
                  // ),
                ],

                const SizedBox(height: 10),
                const Divider(),

                // const Text(
                //   "⏱️ Quick Add",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 24,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                //
                // // TODO - maybe switch to modal for everything instead of having textboxes on the dashboard itself... might look cleaner?
                // QuickAddCategoryCard(
                //   onMusicSubmit: (name, description, isFavorite) async {
                //     if (authState is! AuthLoggedIn) return;
                //     final user = authState.user;
                //     await context.read<MusicCubit>().createNewMusic(
                //       name: name,
                //       performanceNotes: description,
                //       favorite: isFavorite,
                //       token: user.token,
                //       userId: user.id,
                //     );
                //   },
                // ),
                //
                //
                //
                // const SizedBox(height: 10),
                // const Divider(),
                const Text(
                  "Developed in collaboration with Uplift Aerial Arts.",
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: 250,
                    height: 150,
                    child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: const FormattedImage('default/uplift.jpg'))
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
      final bool showDescription = constraints.maxWidth > 300; // You can tweak this threshold

      return Tooltip(
        message: '$label\n$description',
        textAlign: TextAlign.center,
        waitDuration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade100,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => context.goNamed(routeName, queryParameters: {'from': 'home'}),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (showDescription)
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
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
