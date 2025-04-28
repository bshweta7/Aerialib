import 'dart:ui';

// TODO separate into separate constants.dart file

class Constants {
  // Urls
  // static String backendUrl = "http://10.20.29.99:8000";
  static String backendUrl = "https://aerialib.com/api";
  /*static String backendUrl =
    kReleaseMode ? "https://aerialib.com/api"
      : (Platform.isAndroid || Platform.isIOS)
        ? "http://10.20.30.203:8000" : "http://localhost:8000";*/
  static String mediaUrlPrefix = "$backendUrl/media/data";

  // Options
  static List<String> apparatusOptions = ["Lyra", "Hammock", "Conditioning", "Warm Up", "Cool Down"];
  static List<int> levelOptions = [0, 1, 2, 3];
  static List<String> shareOptions = ["Default", "My Images", "Shared with Me"];

  // Images
  static String missingImageId = "6a8e2421-5aa5-48a4-a0b2-73d6a28ef5d3";
  static String missingImageUrl = "/missing_image.jpg";
  // TODO move missing image to assets?

}