import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';

import '../../cubit/flows/flows_cubit.dart';

class UserProfilePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const UserProfilePage());

  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.pencil),
            onPressed: () {
              // TODO: Navigate to EditProfilePage
              // Navigator.push(context, EditProfilePage.route());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            final user = state.user; // Assuming `user` has name, email, etc.

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 20),

                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple.shade100,
                    child: Text(
                      user.username.isNotEmpty ? user.username[0].toUpperCase() : "?",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.purple.shade900,
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
                      context.read<AuthCubit>().logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        LoginPage.route(),
                            (route) => false,
                      );
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

                  const SizedBox(height: 30),
                  // TODO move this to an advanced settings section
                  ElevatedButton.icon(
                    onPressed: () {
                      final user = context.read<AuthCubit>().state as AuthLoggedIn;
                      context.read<FlowsCubit>().syncFlows(user.user.token);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Flow sync triggered.")),
                      );
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text("Sync Flows Now"),
                  ),

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
