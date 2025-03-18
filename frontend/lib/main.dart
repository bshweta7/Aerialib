import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';

import 'package:frontend/features/poses/cubit/poses_cubit.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => PosesCubit()),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aerialib',
      theme: ThemeData(
        // TODO add dark mode. reference: https://api.flutter.dev/flutter/material/SearchBar-class.html
        appBarTheme: const AppBarTheme(
          // color: Colors.indigo,
          // titleTextStyle: TextStyle(
          //   color: Colors.white
          // )
          // TODO update text style for title and make icons white
        ),
        fontFamily: "Cera Pro",
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 3,
              )
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 3,
              )
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 3,
              )
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoggedIn) {
              return const HomePage();
            }

            return const SignupPage();
          }
      ),
    );
  }
}
