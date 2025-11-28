import 'package:frontend/features/instructor_view/pages/instructor_home.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> instructorRoutes = [
  GoRoute(
    path: '/instructor',
    name: 'instructor-home',
    builder: (context, state) => const InstructorHomePage(),
  ),
];