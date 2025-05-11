import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:window_manager/window_manager.dart';

import 'package:frontend/data/services/connectivity_service.dart';
import 'package:frontend/data/services/http_service.dart';

import 'package:frontend/data/datasources/poses/pose_local_data.dart';
import 'package:frontend/data/datasources/poses/pose_remote_data.dart';
import 'package:frontend/data/datasources/user/user_local_data.dart';
import 'package:frontend/data/datasources/user/user_remote_data.dart';
import 'package:frontend/data/datasources/transitions/transition_local_data.dart';
import 'package:frontend/data/datasources/flows/flow_local_data.dart';
import 'package:frontend/data/datasources/flow_poses/flow_pose_local_data.dart';
import 'package:frontend/data/datasources/flow_poses/flow_pose_remote_data.dart';
import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
import 'package:frontend/data/datasources/media/media_local_data.dart';
import 'package:frontend/data/datasources/media/media_remote_data.dart';

import 'package:frontend/domain/repositories/pose_repository.dart';
import 'package:frontend/domain/repositories/user_repository.dart';
import 'package:frontend/domain/repositories/flow_pose_repository.dart';
import 'package:frontend/domain/repositories/flow_repository.dart';
import 'package:frontend/domain/repositories/media_repository.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/cubit/media/media_cubit.dart';

import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';

import 'package:frontend/to_sort/pages/home/web_landing_page.dart';


Future<void> main() async {
  if (Platform.isLinux ) {
    // Set default window size for linux
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(300, 600),
      center: true,
      title: 'Aerialib Linux',
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
  );

  final userRepo = UserRepository(
    localDataSource: UserLocalDataSource(),
    remoteDataSource: UserRemoteDataSource(httpService: HttpService()),
  );

  final flowRepo = FlowRepository(
    localDataSource: FlowLocalDataSource(),
    remoteDataSource: FlowRemoteDataSource(httpService: HttpService()),
  );

  final flowPoseRepo = FlowPoseRepository(
    localDataSource: FlowPoseLocalDataSource(),
    remoteDataSource: FlowPoseRemoteDataSource(httpService: HttpService()),
    poseLocalDataSource: PoseLocalDataSource(),
    transitionLocalDataSource: TransitionLocalDataSource(),
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
  late final ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
  }

  @override
  void dispose() {
    _connectivityService.stopLiveSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aerialib',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB39DDB), // Lavender
          background: const Color(0xFFFFFDF8), // Soft off-white background
        ).copyWith(
          primary: const Color(0xFFB39DDB), // Lavender
          secondary: const Color(0xFF80CBC4), // Muted Teal
        ),
        scaffoldBackgroundColor: const Color(0xFFE4E2ED),
        fontFamily: "Cera Pro",
        appBarTheme: const AppBarTheme(
          backgroundColor: const Color(0xFF3A2E58), // plum text
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE3DFF5), // softer lavender backgroundColor: const Color(0xFFB39DDB), // lavender
            foregroundColor: const Color(0xFF3A2E58), // plum text
            shadowColor: Colors.black12,
            elevation: 1,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: const Color(0xFF3A2E58), // plum text color: Color(0xFF80CBC4), // muted teal border
                width: 2,
              ),

            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              color: Color(0xFF3A2E58),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(20),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFB39DDB),
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFF5F3FB)), // light lavender
          // surfaceTintColor: Colors.transparent, // removes default Material3 overlay tint
          // shadowColor: Colors.transparent,
          hintStyle: MaterialStateProperty.all(
            TextStyle(color: Colors.grey[600]),
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Color(0xFF3A2E58)), // deep plum text
          ),
          // shape: MaterialStateProperty.all(
          //   RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(30),
          //     side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
          //   ),
          // ),
        ),

      ),
      // TODO add dark mode. reference: https://api.flutter.dev/flutter/material/SearchBar-class.html

      home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {

            if (state is AuthLoggedIn) {
              // Start sync listener
              _connectivityService.startLiveSync(
                posesCubit: context.read<PosesCubit>(),
                flowsCubit: context.read<FlowsCubit>(),
                token: state.token,
              );
              return const HomePage();

            } else if (state is AuthLoggedOut) {
              _connectivityService.stopLiveSync(); // Stop listening on logout
              // Optionally clear any other state, go to login screen, etc.
              // TODO return other cubits to initial state as well
              return const LoginPage();

            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());

            } else {
              // Default fallback for unauthenticated
              return kIsWeb ? const LoginPage() : const LoginPage();
            }

            // } else if (kIsWeb) {
            //     // running on the web!
            //     return const WebLandingPage();
            //
            // } else {
            //   // TODO Mobile landing page
            //   return const LoginPage();
            //   // NOT running on the web! You can check for additional platforms here.
            // }
          }
      ),
    );
  }
}
