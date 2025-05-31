import 'package:frontend/features/home/presentation/pages/feedback_form.dart';
import 'package:frontend/features/home/presentation/pages/home_page.dart';
import 'package:frontend/features/home/presentation/pages/landing_page.dart';
import 'package:frontend/features/home/presentation/pages/opinion_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/install_page.dart';


List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/',
    name: 'landing',
    builder: (context, state) => const LandingPage(),
  ),
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/feedback',
    name: 'feedback',
    builder: (context, state) => const SubmitFeedbackPage(),
  ),
  GoRoute(
    path: '/poll',
    name: 'opinion-poll',
    builder: (context, state) => const LogoPollPage(),
  ),
  GoRoute(
    path: '/install',
    name: 'install',
    builder: (context, state) => const InstallPage(),
  ),

];