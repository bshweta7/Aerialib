// lib/presentation/widgets/navigation/smart_back_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/cubit/navigation/nav_history_cubit.dart';

class SmartBackWrapper extends StatelessWidget {
  final Widget child;
  final String fallbackRoute;

  const SmartBackWrapper({
    super.key,
    required this.child,
    this.fallbackRoute = 'home',
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;

        final navHistory = context.read<NavHistoryCubit>();
        final last = navHistory.pop();

        if (last != null) {
          context.goNamed(last);
        } else {
          context.goNamed(fallbackRoute);
        }
      },
      child: child,
    );
  }
}