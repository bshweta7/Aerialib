import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/pages/auth/signup_page.dart';
import 'package:frontend/presentation/pages/auth/user_profile_page.dart';

List<GoRoute> authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/signup',
    name: 'signup',
    builder: (context, state) => const SignupPage(),
  ),
  GoRoute(
    path: '/user-profile',
    name: 'user_profile',
    builder: (context, state) => const UserProfilePage(),
  ),
];