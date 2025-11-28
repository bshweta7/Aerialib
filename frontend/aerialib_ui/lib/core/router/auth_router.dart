import 'package:frontend/features/user/legacy/forgot_password_page.dart';
import 'package:frontend/features/user/legacy/reset_password_page.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/user/presentation/pages/login_page.dart';
import 'package:frontend/features/user/presentation/pages/signup_page.dart';
import 'package:frontend/features/user/presentation/pages/user_profile_page.dart';

List<GoRoute> authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login', // TODO convert everything to goNamed if it makes sense to do so... (consistency)
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/signup',
    name: 'signup',
    builder: (context, state) => const SignupPage(),
  ),
  GoRoute(
    path: '/profile', // TODO add username in profile ----> Updated path with username parameter
    name: 'user-profile',
    builder: (context, state) => const UserProfilePage(),
  ),

  GoRoute(
    path: '/forgot', // TODO add username in profile ----> Updated path with username parameter
    name: 'forgot',
    builder: (context, state) => const ForgotPasswordPage(),
  ),

  GoRoute(
    path: '/reset/reset-password', // TODO add username in profile ----> Updated path with username parameter
    name: 'reset-password',
    builder: (context, state) => const ResetPasswordPage(),
  ),


];