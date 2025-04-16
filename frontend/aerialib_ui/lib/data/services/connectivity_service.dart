// core/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<int> isConnected() async {
    List<ConnectivityResult> resultList = await Connectivity().checkConnectivity();
    ConnectivityResult result = resultList.first;
    return _isConnected(result) ? 1 : 0;
  }

  static bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn ||
        result == ConnectivityResult.other; // Consider 'other' based on your needs
  }
}

