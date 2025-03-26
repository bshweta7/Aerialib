import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class Constants {
  // Urls
  /*static String backendUri = "http://10.20.29.99:8000";*/
  static String backendUri = "https://aerialib.com/api";
  /*static String backendUri =
    kReleaseMode ? "https://aerialib.com/api"
      : (Platform.isAndroid || Platform.isIOS)
        ? "http://10.20.30.203:8000" : "http://localhost:8000";*/
  // TODO rename to Url
  static String mediaUrlPrefix = "$backendUri/media/data";

  // Options
  static List<String> apparatusOptions = ["Lyra", "Hammock", "Conditioning"];
  static List<int> levelOptions = [0, 1, 2, 3, 4];
  static List<String> shareOptions = ["Default", "My Images", "Shared with Me"];

  // Images
  static String missingImageId = "6a8e2421-5aa5-48a4-a0b2-73d6a28ef5d3";
  static String missingImageUrl = "/missing_image.jpg";
  // TODO move missing image to assets?

  // Colors
  // https://coolors.co/visualizer/7d2787-c181c7-f0efff-c0e4ec-79d2d5
  static Color darkPurple = const Color (0xFF7D2787);
  static Color midPurple = const Color (0xFFc181c7);
  static Color backgroundBlue = const Color (0xFFf0efff);
  static Color lightTeal = const Color (0xFFc0e4ec);
  static Color midTeal = const Color (0xFF79d2d5);



}