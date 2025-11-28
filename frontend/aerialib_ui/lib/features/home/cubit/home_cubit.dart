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
        _safeSync(() => context.read<MediaCubit>().syncMedia(token: token), 'Media'),
        // _safeSync(() => context.read<PosesCubit>().syncPoses(token: token), 'Poses'),
        _safeSync(() => context.read<TransitionCubit>().syncTransitions(token: token), 'Transitions'),
        _safeSync(() => context.read<FlowsCubit>().syncFlows(token: token), 'Flows'),
      ]);

      hasSynced = true;
      emit(HomeLoaded());
    } catch (e) {
      emit(HomeError('Home sync failed: $e'));
    }
  }

  Future<void> _safeSync(Future<void> Function() fn, String label) async {
    try {
      await fn();
    } catch (e, st) {
      debugPrint('❌ $label sync failed: $e\n$st');
      rethrow;
    }
  }

}

// TODO Initialization service if later you need Background syncs, Multi-role logic (e.g., admin vs user startup logic), Headless tests for app boot