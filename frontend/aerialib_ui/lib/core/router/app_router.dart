import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/home/landing_page.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

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
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
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
    ],
    redirect: (context, state) {
      final authState = authCubit.state; // Use the passed AuthCubit
      final isLoggedIn = authState is AuthLoggedIn;
      // final isLoggingIn = state.fullPath == '/login';

      // If not logged in and not trying to log in, stay on the landing page
      if (!isLoggedIn && state.fullPath == '/') {
        return '/';
      }

      // // If not logged in and trying to access any other page, redirect to login
      // if (!isLoggedIn && !isLoggingIn) {
      //   return '/login';
      // }
      //
      // // If not logged in AND not currently trying to log in, redirect to login
      // if (!isLoggedIn && !isLoggingIn) {
      //   return '/login';
      // }

      // If logged in AND trying to go to the login page, redirect to home
      if (isLoggedIn) return '/home'; // TODO may need to verify this (see && state.fullPath='/' above).

      return null;
    },
  );
}