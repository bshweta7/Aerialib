import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/main/repository_providers.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:window_manager/window_manager.dart';
import 'core/constants/constants.dart';
import 'core/main/app_theme.dart';
import 'core/router/app_router.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
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
    print("[Main] InitState ran");
  }

  @override
  void dispose() {
    _connectivityService.stopLiveSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("[Main] Build ran");

    return MaterialApp(
      title: 'Aerialib',
      theme: getLightTheme(), // Use the getLightTheme() function
      darkTheme: getDarkTheme(), // Use the getDarkTheme() function
      themeMode: ThemeMode.system, // Keep your theme mode
      home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            print("[Main] Entered bloc builder");
            print("[Main] BackendUrl: ${Constants.backendUrl}");

            if (state is AuthLoggedIn) {
              print("[Main] State is logged in");
              _connectivityService.startLiveSync(
                posesCubit: context.read<PosesCubit>(),
                flowsCubit: context.read<FlowsCubit>(),
                token: state.token,
              );
              return const HomePage();
            } else if (state is AuthLoggedOut) {
              print("[Main] State is logged out");
              _connectivityService.stopLiveSync();
              return const LoginPage();
            } else if (state is AuthLoading) {
              print("[Main] State is loading");
              return const Center(child: CircularProgressIndicator());
            } else {
              print("[Main] State is $state");
              return kIsWeb ? const LoginPage() : const LoginPage();
            }
          },
      ),
    );
  }
}



// class MyApp extends StatelessWidget { // Back to StatelessWidget
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print("[Main] Build ran in MyApp");
//     final authCubit = context.read<AuthCubit>();
//     return MaterialApp.router(
//       routerConfig: createRouter(authCubit),
//       title: 'Aerialib',
//       theme: getLightTheme(),
//       darkTheme: getDarkTheme(),
//       themeMode: ThemeMode.system,
//     );
//     // TODO add darktheme/lgiht theme toggle
//   }
// }