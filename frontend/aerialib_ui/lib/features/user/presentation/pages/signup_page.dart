import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/presentation/widgets/password_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isUsernameTaken = false;
  bool isEmailTaken = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    // Clear previous "taken" flags before re-checking
    setState(() {
      isUsernameTaken = false;
      isEmailTaken = false;
    });

    final isFormValid = formKey.currentState!.validate();

    if (!isFormValid) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Step 1: Check availability from backend
    try {
      final checkResult = await context.read<AuthCubit>().checkIfTaken(
        username: username,
        email: email,
      );

      final usernameTaken = checkResult['username'] ?? false;
      final emailTaken = checkResult['email'] ?? false;

      setState(() {
        isUsernameTaken = usernameTaken;
        isEmailTaken = emailTaken;
      });

      if (usernameTaken || emailTaken) {
        // Re-run validation to trigger red error messages
        formKey.currentState!.validate();
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to check availability: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Step 2: Proceed with signup
    context.read<AuthCubit>().signUp(
      username: username,
      email: email,
      password: password,
    );
  }


  void resetPage() {
    context.read<AuthCubit>().reInitialize();
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
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              resetPage();
            } else if (state is AuthLoggedIn) { // TODO eventually, emit a different state authSignedUp so that it will go to the tutorial on how to use it.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account created! Welcome!"),
                ),
              );
              context.goNamed('home');
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1e293b),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign up to get started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 32),

                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Username field cannot be empty!";
                          }
                          if (isUsernameTaken) {
                            return "Username is already taken!";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email field cannot be empty!";
                          }
                          if (!value.contains('@')) {
                            return "Email is invalid!";
                          }
                          if (isEmailTaken) {
                            return "Email is already taken!";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      PasswordField(
                        controller: passwordController,
                        label: "Password",
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: signUpUser,
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF334155),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('login'),
                            child: const Text(
                              "Log In",
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
                            foregroundColor: Color(0xFF1e293b),
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
