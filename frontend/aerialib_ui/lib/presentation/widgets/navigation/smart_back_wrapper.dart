// lib/presentation/widgets/navigation/smart_back_wrapper.dart

import 'dart:developer';
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
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        log("[SmartBackWrapper] Pop invoked: didPop=$didPop");

        if (didPop) return;

        final navHistory = context.read<NavHistoryCubit>();
        final last = navHistory.pop();

        if (last != null) {
          log("[SmartBackWrapper] Popped to $last");
          context.goNamed(last);
        } else {
          context.goNamed(fallbackRoute);
        }
      },
      child: child,
    );
  }
}