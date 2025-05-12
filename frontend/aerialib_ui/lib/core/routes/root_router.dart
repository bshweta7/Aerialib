import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/home/landing_page.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/data/services/connectivity_service.dart';

class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void dispose() {
    _connectivityService.stopLiveSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        print("[RootRouter] BackendUrl: ${Constants.backendUrl}");

        if (state is AuthLoggedIn) {
          print("[RootRouter] Logged in");
          _connectivityService.startLiveSync(
            posesCubit: context.read<PosesCubit>(),
            flowsCubit: context.read<FlowsCubit>(),
            token: state.token,
          );
          return const HomePage();
        } else if (state is AuthLoggedOut) {
          print("[RootRouter] Logged out");
          _connectivityService.stopLiveSync();
          return kIsWeb ? const LandingPage() : const LoginPage();
        } else if (state is AuthLoading) {
          print("[RootRouter] Loading");
          return const Center(child: CircularProgressIndicator());
        } else {
          print("[RootRouter] Unknown state: $state");
          return kIsWeb ? const LandingPage() : const LoginPage();
        }
      },
    );
  }
}
