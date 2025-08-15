import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/info_display/info_row.dart';
import '../../../home/cubit/home_cubit.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Profile"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       // TODO: Navigate to EditProfilePage
        //       // Navigator.push(context, EditProfilePage.route());
        //     },
        //   ),
        // ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            final user = state.user; // Assuming `user` has name, email, etc.

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 20),

                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF73649D),
                    child: Text(
                      user.username.isNotEmpty ? user.username[0].toUpperCase() : "?",
                      style: const TextStyle(
                        fontSize: 30,
                        color: Color(0xFFE3DFF5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // User info
                  Text(
                    user.username,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 30),

                  InfoRow("First Name", user.firstName),
                  InfoRow("Last Name", user.lastName),
                  InfoRow("Bio", user.bio),

                  // Logout button
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD68686),
                      // foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 20,),
                  const Divider(),

                  // Privacy Policy button
                  ElevatedButton.icon(
                    onPressed: () {
                      context.goNamed('privacy');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD68686),
                      // foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 20,),
                  const Divider(),
                  // // Tag Management Navigation
                  // ElevatedButton(
                  //     onPressed: () {
                  //       context.pushNamed('tag-manager');
                  //     },
                  //     child: const Text(
                  //         "Manage Tags",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //         )
                  //     )
                  // ),
                  // const SizedBox(height: 10,),





                  // const SizedBox(height: 10,),
                  // const Text(
                  //   "Have an idea or found a bug?",
                  //   style: TextStyle(
                  //     // fontWeight: FontWeight.bold,
                  //     // color: Colors.black,
                  //     fontSize: 18,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 10,),
                  //
                  // // Feedback Form Navigation
                  // ElevatedButton(
                  //     onPressed: () {
                  //       context.pushNamed('feedback');
                  //     },
                  //     child: const Text(
                  //         "Submit Feedback",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //         )
                  //     )
                  // ),
                  // const SizedBox(height: 20,),

                  const Divider(),
                  const SizedBox(height: 10,),
                  const Text(
                    "Advanced Settings",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      // color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10,),

                  // Sync Data Button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.sync),
                    label: const Text("Sync Data", style: TextStyle(
                      fontSize: 20,
                    )),
                    onPressed: () {
                      context.read<HomeCubit>().initializeHome(context, force: true);
                    },
                  ),
                  const SizedBox(height: 20,),

                  // TODO make this a swipe down gesture, and add the manual button in profile advanced settings



                  // // TODO move this to an advanced settings section
                  // const SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     final user = context.read<AuthCubit>().state as AuthLoggedIn;
                  //     context.read<PosesCubit>().syncPoses(token: user.user.token);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text("Poses sync triggered.")),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.sync),
                  //   label: const Text("Sync Poses Now"),
                  // ),
                  // // TODO - Consider caching the last sync time in shared prefs (via sp_service.dart maybe?)
                  //
                  // const SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     final user = context.read<AuthCubit>().state as AuthLoggedIn;
                  //     context.read<MediaCubit>().syncMedia(token: user.user.token);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text("Media sync triggered.")),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.sync),
                  //   label: const Text("Sync Media Now"),
                  // ),
                  //
                  // const SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     final user = context.read<AuthCubit>().state as AuthLoggedIn;
                  //     context.read<FlowsCubit>().syncFlowPoses(token: user.user.token);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text("Flow Poses sync triggered.")),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.sync),
                  //   label: const Text("Sync Flow Poses Now"),
                  // ),
                  //
                  // const SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     final user = context.read<AuthCubit>().state as AuthLoggedIn;
                  //     context.read<FlowsCubit>().syncFlowDetails(token: user.user.token);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text("Flow sync triggered.")),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.sync),
                  //   label: const Text("Sync Flows Now"),
                  // ),
                  
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
