import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/shared/widgets/input_fields/password_field.dart';

import '../../../../shared/widgets/scaffolds/general_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final approvedUsernames = ['admin', 'test', '3Josie3', 'shweta', 'clee', 'morganf24', 'hoopster'];
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // void logInUser() {
  //   if (formKey.currentState!.validate()) {
  //     context.read<AuthCubit>().login(
  //       username: usernameController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //   }
  // }

  // TODO temporarily disabled for unapproved users
  void logInUser() {
    final username = usernameController.text.trim();

    if (!approvedUsernames.contains(username)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Access Restricted"),
          content: const Text("Aerialib is temporarily suspended.\nPlease contact Shweta for access."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        username: username,
        password: passwordController.text.trim(),
      );
    }
  }



  void resetPage() {
    context.read<AuthCubit>().reInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              resetPage();
            } else if (state is AuthLoggedIn) {
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 40,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1e293b),
                            ),
                          ),
                          // const SizedBox(height: 8),
                          // const Text(
                          //   "Log in to continue",
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     color: Color(0xFF334155),
                          //   ),
                          // ),
                          const SizedBox(height: 24),

                          // Username field
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
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          PasswordField(
                            controller: passwordController,
                            label: "Password",
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: logInUser,
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // TODO More prominent Sign Up prompt
                          Wrap(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.goNamed('signup'),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1e293b),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // TODO
                          //  const SizedBox(height: 20),
                          //
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const Text(
                          //       "Forgot your username/password? ",
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         color: Color(0xFF334155),
                          //       ),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () => context.goNamed('forgot'),
                          //       child: const Text(
                          //         "Click Here",
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.bold,
                          //           color: Color(0xFF1e293b),
                          //           decoration: TextDecoration.underline,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),


                          // GestureDetector(
                          //   onTap: () => context.goNamed('reset-password'),
                          //   child: const Text(
                          //     "RESET PASSWORD",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       color: Color(0xFF1e293b),
                          //       decoration: TextDecoration.underline,
                          //     ),
                          //   ),
                          // ),

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
                ),
              ),
            );
          },
        ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
// import 'package:frontend/shared/widgets/input_fields/password_field.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   void logInUser() {
//     if (formKey.currentState!.validate()) {
//       context.read<AuthCubit>().login(
//         username: usernameController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//     }
//   }
//
//   void resetPage() {
//     context.read<AuthCubit>().reInitialize();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF9084AF),
//               Color(0xFFBDB4D7),
//               Color(0xFFDAD2EE),
//               // Color(0xFF9084AF),
//
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: BlocConsumer<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.error)),
//               );
//               resetPage();
//             } else if (state is AuthLoggedIn) {
//               context.goNamed('home');
//             }
//           },
//           builder: (context, state) {
//             if (state is AuthLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return Center(
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: formKey,
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         right: 20,
//                         left: 20,
//                         top: 40,
//                         bottom: 20,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text(
//                             "Welcome Back",
//                             style: TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1e293b),
//                             ),
//                           ),
//                           // const SizedBox(height: 8),
//                           // const Text(
//                           //   "Log in to continue",
//                           //   style: TextStyle(
//                           //     fontSize: 18,
//                           //     color: Color(0xFF334155),
//                           //   ),
//                           // ),
//                           const SizedBox(height: 24),
//
//                           // Username field
//                           TextFormField(
//                             controller: usernameController,
//                             decoration: const InputDecoration(
//                               hintText: 'Username',
//                               border: OutlineInputBorder(),
//                               fillColor: Colors.white,
//                               filled: true,
//                             ),
//                             validator: (value) {
//                               if (value == null || value.trim().isEmpty) {
//                                 return "Username field cannot be empty!";
//                               }
//                               return null;
//                             },
//                           ),
//
//                           const SizedBox(height: 16),
//
//                           // Password field
//                           PasswordField(
//                             controller: passwordController,
//                             label: "Password",
//                           ),
//                           const SizedBox(height: 24),
//                           SizedBox(
//                             width: double.infinity,
//                             height: 48,
//                             child: ElevatedButton(
//                               onPressed: logInUser,
//                               child: const Text(
//                                 'LOGIN',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//
//                           // TODO More prominent Sign Up prompt
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Don't have an account? ",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Color(0xFF334155),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () => context.goNamed('signup'),
//                                 child: const Text(
//                                   "Sign Up",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1e293b),
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           // TODO
//                           //  const SizedBox(height: 20),
//                           //
//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.center,
//                           //   children: [
//                           //     const Text(
//                           //       "Forgot your username/password? ",
//                           //       style: TextStyle(
//                           //         fontSize: 16,
//                           //         color: Color(0xFF334155),
//                           //       ),
//                           //     ),
//                           //     GestureDetector(
//                           //       onTap: () => context.goNamed('forgot'),
//                           //       child: const Text(
//                           //         "Click Here",
//                           //         style: TextStyle(
//                           //           fontSize: 16,
//                           //           fontWeight: FontWeight.bold,
//                           //           color: Color(0xFF1e293b),
//                           //           decoration: TextDecoration.underline,
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//
//
//                           // GestureDetector(
//                           //   onTap: () => context.goNamed('reset-password'),
//                           //   child: const Text(
//                           //     "RESET PASSWORD",
//                           //     style: TextStyle(
//                           //       fontSize: 16,
//                           //       fontWeight: FontWeight.bold,
//                           //       color: Color(0xFF1e293b),
//                           //       decoration: TextDecoration.underline,
//                           //     ),
//                           //   ),
//                           // ),
//
//                           const SizedBox(height: 50),
//
//                           // Back button
//                           Align(
//                             alignment: Alignment.center,
//                             child: TextButton.icon(
//                               onPressed: () => context.go('/'),
//                               icon: const Icon(Icons.arrow_back, color: Color(0xFF1e293b)),
//                               label: const Text(
//                                 "Back to Landing Page",
//                                 style: TextStyle(color: Color(0xFF1e293b)),
//                               ),
//                               style: TextButton.styleFrom(
//                                 foregroundColor: Color(0xFF1e293b), // for consistency on hover/tap
//                               ),
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
