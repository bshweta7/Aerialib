import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/user/presentation/cubit/password_cubit.dart';
import 'package:frontend/shared/widgets/input_fields/password_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String token;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    final extractedToken = uri.queryParameters['token'] ?? '';
    token = extractedToken;

    debugPrint('[ResetPasswordPage] Extracted token: $token');
  }


  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      context.read<PasswordCubit>().resetPassword(
          token,
          passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFBAAEC8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<PasswordCubit, PasswordState>(
          listener: (context, state) {
            if (state is PasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is PasswordLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PasswordError) {
              const Center(child: Text("Invalid or missing reset token."));
            // TODO add a button to resend link
            }

            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text( // TODO make a template (like MainScaffold) for these kinds of pages...
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1e293b),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Enter a new password",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Password field
                      PasswordField(
                        controller: passwordController,
                        label: "Password",
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      PasswordField(
                        controller: confirmPasswordController,
                        label: "Confirm Password",
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: resetPassword,
                          child: const Text(
                            'RESET',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF334155),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('signup'),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1e293b),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // Back button
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF1e293b)),
                          label: const Text(
                            "Back to Landing Page",
                            style: TextStyle(color: Color(0xFF1e293b)),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFF1e293b), // for consistency on hover/tap
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}