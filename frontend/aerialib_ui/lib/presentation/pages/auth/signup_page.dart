import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/widgets/password_field.dart';
import 'package:go_router/go_router.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // formKey.currentState.validate()
    super.dispose();
  }

  void signUpUser() {
    if (formKey.currentState!.validate()) {
      // store the user data and call nodeJS express
      context.read<AuthCubit>().signUp(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          } else if (state is AuthSignUp) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account created! Login Now!"),
              ),
            );
          }
        },
        builder: (context, state) {
          if(state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),

            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Sign Up.",
                      style: TextStyle(
                        fontSize:50,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                    validator: (value) {
                      if(value == null || value.trim().isEmpty) {
                        return "Username field cannot be empty!";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if(value == null ||
                          value.trim().isEmpty) {
                        return "Email field cannot be empty!";
                      }
                      if(!value.trim().contains("@")) {
                        return "Email is invalid!"; //TODO use real regex
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15,),
                  PasswordField(
                    controller: passwordController,
                    label: "Password",
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                      onPressed: signUpUser,
                      child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 16,
                          )
                      )
                  ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: RichText(
                        text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(text:'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ]
                        )
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
