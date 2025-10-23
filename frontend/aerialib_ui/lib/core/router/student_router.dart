import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';

import '../../features/students/presentation/pages/student_roster_page.dart';

List<GoRoute> studentRoutes = [
  /// Student Library Page
  GoRoute(
    path: '/student',
    name: 'student-library',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
        state.uri.queryParameters['from'],
      );
      return const StudentLibraryPage();
    },
  ),

];
