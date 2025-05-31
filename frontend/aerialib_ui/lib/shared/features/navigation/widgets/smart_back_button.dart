// lib/presentation/widgets/navigation/smart_back_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';

import 'package:frontend/shared/helpers/formatters.dart';

class SmartBackButton extends StatelessWidget {
  final String? fallbackRouteName;
  final IconData? icon;
  final Color? color;

  const SmartBackButton({
    super.key,
    this.fallbackRouteName = 'home',
    this.icon = Icons.arrow_back,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavHistoryCubit, List<String>>(
      builder: (context, history) {
        final canPop = history.isNotEmpty;
        final previewRoute = canPop ? history.last : fallbackRouteName;

        return IconButton(
            icon: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
            tooltip: previewRoute != null
                ? 'Back to ${formatNameFromPath(previewRoute)}'
                : 'No previous route',
            onPressed: canPop
                ? () {
              final routeName = context.read<NavHistoryCubit>().pop();
              if (routeName != null) {
                context.goNamed(routeName);
              }
            }
                : fallbackRouteName != null
                ? () => context.goNamed(fallbackRouteName!)
                : null,

        );
      },
    );
  }
}