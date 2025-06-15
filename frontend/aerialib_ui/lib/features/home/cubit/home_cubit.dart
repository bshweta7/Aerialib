import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';

import '../../user/presentation/cubit/auth_cubit.dart';
import '../../media/presentation/cubit/media_cubit.dart';
import '../../pose/presentation/cubit/poses_cubit.dart';
import '../../transitions/presentation/cubit/transition_cubit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  bool hasSynced = false;

  HomeCubit() : super(HomeInitial());

  Future<void> initializeHome(BuildContext context, {bool force = false}) async {
    if (hasSynced && !force) return;

    emit(HomeLoading());

    try {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      final token = user.token;

      await Future.wait([
        context.read<MediaCubit>().syncMedia(token: token),
        context.read<PosesCubit>().syncPoses(token: token),
        context.read<TransitionCubit>().syncTransitions(token: token),
        context.read<FlowsCubit>().syncFlows(token: token),
      ]);

      hasSynced = true;
      emit(HomeLoaded());
    } catch (e) {
      emit(HomeError('Home sync failed: $e'));
    }
  }
}

// TODO Initialization service if later you need Background syncs, Multi-role logic (e.g., admin vs user startup logic), Headless tests for app boot