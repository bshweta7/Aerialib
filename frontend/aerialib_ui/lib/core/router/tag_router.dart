import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tags/presentation/pages/tag_manager_page.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';



List<GoRoute> tagRoutes = [
  /// Tag Manager Page
  GoRoute(
    path: '/tags',
    name: 'tag-manager',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );
      return const TagManagerPage();
    },
  ),
];
