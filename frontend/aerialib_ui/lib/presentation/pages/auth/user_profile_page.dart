import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';


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

                  // Logout button
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FlowsCubit>().clearLocalFlows();
                      // TODO verify if there are any unsaved ones
                      context.read<AuthCubit>().logout();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.purple,
                      // foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),

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
