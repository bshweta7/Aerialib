import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/datasources/transitions/transition_local_data.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:window_manager/window_manager.dart';

import 'package:frontend/data/datasources/poses/pose_local_data.dart';
import 'package:frontend/data/datasources/poses/pose_remote_data.dart';
import 'package:frontend/data/datasources/user/user_local_data.dart';
import 'package:frontend/data/datasources/user/user_remote_data.dart';
import 'package:frontend/data/services/http_service.dart';

import 'package:frontend/domain/repositories/pose_repository.dart';
import 'package:frontend/domain/repositories/user_repository.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';



import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/to_sort/pages/home/web_landing_page.dart';
import 'data/datasources/flows/flow_local_data.dart';
import 'data/datasources/flow_poses/flow_pose_local_data.dart';
import 'data/datasources/flow_poses/flow_pose_remote_data.dart';
import 'data/datasources/flows/flow_remote_data.dart';
import 'data/datasources/media/media_local_data.dart';
import 'data/datasources/media/media_remote_data.dart';
import 'domain/repositories/flow_pose_repository.dart';
import 'domain/repositories/flow_repository.dart';
import 'domain/repositories/media_repository.dart';
import 'presentation/cubit/media/media_cubit.dart';



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

  // Set up Repos
  final poseRepo = PoseRepository(
    localDataSource: PoseLocalDataSource(),
    remoteDataSource: PoseRemoteDataSource(httpService: HttpService()),
    mediaLocalDataSource: MediaLocalDataSource(),
  );

  final userRepo = UserRepository(
    localDataSource: UserLocalDataSource(),
    remoteDataSource: UserRemoteDataSource(httpService: HttpService()),
  );

  final flowRepo = FlowRepository(
    localDataSource: FlowLocalDataSource(),
    remoteDataSource: FlowRemoteDataSource(httpService: HttpService()),
    mediaLocalDataSource: MediaLocalDataSource(),
  );

  final flowPoseRepo = FlowPoseRepository(
    localDataSource: FlowPoseLocalDataSource(),
    remoteDataSource: FlowPoseRemoteDataSource(httpService: HttpService()),
    poseLocalDataSource: PoseLocalDataSource(),
    transitionLocalDataSource: TransitionLocalDataSource(),
    mediaLocalDataSource: MediaLocalDataSource(),
  );

  final mediaRepo = MediaRepository(
    localDataSource: MediaLocalDataSource(),
    remoteDataSource: MediaRemoteDataSource(httpService: HttpService()),
  );

  // Run app
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit(userRepo)),
      BlocProvider(create: (_) => PosesCubit(poseRepo)),
      BlocProvider(create: (_) => MediaCubit(mediaRepo)),
      BlocProvider(create: (_) => FlowsCubit(flowRepo, flowPoseRepo)),
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
