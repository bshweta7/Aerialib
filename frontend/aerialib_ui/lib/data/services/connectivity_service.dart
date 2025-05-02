// core/services/connectivity_service.dart
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../presentation/cubit/flows/flows_cubit.dart';
import '../../presentation/cubit/poses/poses_cubit.dart';

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
    // required FlowsCubit flowsCubit,
    required String token,
  }) {
    print("Starting Live Sync");
    _subscription = Connectivity().onConnectivityChanged.listen((resultList) async {
      if (_isConnected(resultList)) {
        print('[ConnectivityService] Connected, triggering sync...');
        await posesCubit.syncPoses(token);
        // TODO add other syncs
        //  await flowsCubit.syncFlows(token);
      } else {
        print('[ConnectivityService] Offline');
      }
    });
  }

  void stopLiveSync() {
    print("Stopping Live Sync");
    _subscription?.cancel();
  }
}
