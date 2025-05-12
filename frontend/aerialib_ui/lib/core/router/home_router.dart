import 'package:frontend/presentation/pages/home/feedback_form.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/home/landing_page.dart';
import 'package:go_router/go_router.dart';


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
];