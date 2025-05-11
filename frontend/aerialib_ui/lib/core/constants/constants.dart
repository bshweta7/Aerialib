import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// TODO separate into separate constants.dart file

class Constants {

  // Determine backend URL based on environment and platform
  static final String backendUrl = _getBackendUrl();
  static final String mediaUrlPrefix = "$backendUrl/media/data";

  static String _getBackendUrl() {
    if (kReleaseMode) {
      return "https://aerialib.com/api";
    }

    if (kIsWeb) {
      return "http://localhost:8000";
    }

    // Use defaultTargetPlatform for non-web
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return "http://10.20.30.203:8000";
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return "http://localhost:8000";
    }
  }

  // static String backendUrl =
  //   kReleaseMode ? "https://aerialib.com/api"
  //     : (Platform.isAndroid || Platform.isIOS)
  //       ? "http://10.20.30.203:8000" : "http://localhost:8000";
  // static String mediaUrlPrefix = "$backendUrl/media/data";

  // Options
  // TODO make separate pages for warm up/cool down (dont include warm up/cooldown/ conditioning in poses, make it separate).
  static List<String> apparatusOptions = ["lyra", "hammock", "unspecified"]; //, "Conditioning", "Warm Up", "Cool Down"];
  static List<int> levelOptions = [0, 1, 2, 3, -1];
  static List<String> shareStatusOptions = ["default", "my images", "shared with me"];
  static List<String> mediaTypeOptions = ["image", "video"];

  // Images
  // OLD ONE:  static String missingImageId = "6a8e2421-5aa5-48a4-a0b2-73d6a28ef5d3";
  static String missingImageId = "32f9c19c-e936-41f4-8a29-ed663b9c6d45";
  static String missingImagePath = "default/missing_image.jpg";
  // TODO move missing image to assets?

  static const List<String> defaultFlowThumbnails = [
    'default/flow_placeholders/peach.png',
    'default/flow_placeholders/yellow.png',
    'default/flow_placeholders/mint.png',
    'default/flow_placeholders/lavender.png',
  ];

  static const double visibleScrollThreshold = 150.0;
}