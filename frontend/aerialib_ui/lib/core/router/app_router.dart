import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/core/router/auth_router.dart'; // Import auth routes
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/home/landing_page.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
// Assuming PoseViewPage and PoseEntity are in these paths
import 'package:frontend/domain/entities/pose_entity.dart';

import '../../presentation/pages/poses/pose_view_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthChangeNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final authNotifier = AuthChangeNotifier();

GoRouter createRouter(AuthCubit authCubit) {
  // Listen to changes in AuthCubit to trigger GoRouter refresh
  authCubit.stream.listen((_) => authNotifier.notify());

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    refreshListenable: authNotifier,
    routes: [
      GoRoute(
        path: '/',
        name: 'landing', // Add a name for easier navigation
        builder: (context, state) => const LandingPage(),
      ),
      ...authRoutes, // Include the authentication routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/flow/view',
        name: 'flow_view',
        builder: (context, state) {
          final flow = state.extra as FlowEntity;
          return FlowViewPage(flow: flow);
        },
      ),
      GoRoute(
        path: '/pose/view/:poseId', // Define a path parameter for poseId
        name: 'pose_view',
        builder: (context, state) {
          final poseId = state.pathParameters['poseId']!;
          final pose = state.extra as PoseEntity;
          return PoseViewPage(pose: pose);
        },
      ),
    ],
    redirect: (context, state) {
      final authState = BlocProvider.of<AuthCubit>(context).state;
      final isLoggedIn = authState is AuthLoggedIn;
      final isLoggingIn = state.fullPath == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';
      return null;
    },
  );
}