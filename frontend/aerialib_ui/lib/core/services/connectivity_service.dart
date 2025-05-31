// core/services/connectivity_service.dart
import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';

class ConnectivityService {
  static Future<int> isConnected() async {
    List<ConnectivityResult> resultList = await Connectivity().checkConnectivity();
    return _isConnected(resultList) ? 1 : 0;
  }

  static bool _isConnected(List<ConnectivityResult> resultList) {
    ConnectivityResult result = resultList.first;
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn ||
        result == ConnectivityResult.other; // Consider 'other' based on your needs
  }

  // Live Listener Support
  StreamSubscription? _subscription;

  void startLiveSync({
    required PosesCubit posesCubit,
    required FlowsCubit flowsCubit,
    required String token,
  }) {
    _subscription = Connectivity().onConnectivityChanged.listen((resultList) async {
      if (_isConnected(resultList)) {
        log('[ConnectivityService] Connected, triggering sync...');
        await posesCubit.syncPoses(token: token);
        await flowsCubit.syncFlows(token: token);
        // TODO add other syncs
      } else {
        log('[ConnectivityService] Offline');
      }
    });
  }

  void stopLiveSync() {
    log("[ConnectivityService] Stopping Live Sync");
    _subscription?.cancel();
  }
}
