import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';

// TODO set up username and allow login from username OR email
// TODO allow tab to go from username textbox to password textbox
// TODO arrows don't work in textboxes?

// TODO weird error message if trying to login without connection to db

class LoginPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
      builder: (context) => const LoginPage()
  );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // formKey.currentState.validate()
    super.dispose();
  }

  void logInUser() {
    if (formKey.currentState!.validate()) {
      // store the user data and call nodeJS express
      context.read<AuthCubit>().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  void resetPage() {
    // reset to Auth initial
    context.read<AuthCubit>().reInitialize();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // content: Text("Could not login"),
                content: Text(state.error), //TODO update snackbar to show more specific error message
              ),
            );
            resetPage(); // TODO test this
          } else if (state is AuthLoggedIn) {
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
                  (_) => false,
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
            padding: const EdgeInsets.all(20.0),

            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Login",
                      style: TextStyle(
                        fontSize:50,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 30,),

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
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if(value == null ||
                          value.trim().isEmpty) {
                        return "Password field cannot be empty!";
                      }
                      if(value.trim().length <= 6) {
                        return "Password must be at least 7 characters!"; // TODO add special character
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                      onPressed: logInUser,
                      child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )
                      )
                  ),

                  const SizedBox(height: 15),


                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(SignupPage.route());
                    },
                    child: RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(text:'Sign Up',
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
