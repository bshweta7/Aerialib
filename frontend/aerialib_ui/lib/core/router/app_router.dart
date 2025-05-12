import 'package:flutter/material.dart';
import 'package:frontend/core/router/home_router.dart';
import 'package:frontend/core/router/pose_router.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/home/landing_page.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

import 'auth_router.dart';
import 'flow_router.dart';

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
      ...authRoutes,
      ...homeRoutes,
      ...flowRoutes,
      ...poseRoutes,
    ],
    redirect: (context, state) {
      final authState = authCubit.state;
      final isLoggedIn = authState is AuthLoggedIn;
      final isLoggingIn = state.fullPath == '/login';

      // // If not logged in and not trying to log in, redirect to login
      // if (!isLoggedIn && !isLoggingIn) {
      //   return '/';
      // }
      //
      // // If not logged in and not trying to log in, redirect to login
      // if (!isLoggedIn && isLoggingIn) {
      //   return '/';
      // }
      //
      // // If logged in and trying to go to the root or login page, redirect to home
      // if (isLoggedIn && (state.fullPath == '/' || isLoggingIn)) {
      //   return '/home';
      // }
      return null; // Allow navigation to other routes
    },
    // TODO may need to add something here to ensure that after logout, user doesnt click back button to go back to "logged in" state.
  );
}