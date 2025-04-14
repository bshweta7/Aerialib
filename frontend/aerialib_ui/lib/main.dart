import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/features/home/pages/web_landing_page.dart';
import 'package:window_manager/window_manager.dart';

import 'package:frontend/cubit/poses_cubit.dart';

import 'cubit/media_cubit.dart';
import 'cubit/flow_cubit.dart';

Future<void> main() async {
  if (Platform.isLinux ) {
    // Set default window size for linux
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(300, 600), // Set your desired default width and height
      center: true, // Optional: Center the window on the screen
      title: 'Aerialib Linux', // Optional: Set the window title
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Run app
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => PosesCubit()),
      BlocProvider(create: (_) => MediaCubit()),
      BlocProvider(create: (_) => FlowsCubit()),
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
            } else {
              if (kIsWeb) {
                // running on the web!
                return const WebLandingPage();
              } else {
                // TODO Mobile landing page
                return const LoginPage();
                // NOT running on the web! You can check for additional platforms here.
              }
            }

          }
      ),
    );
  }
}
