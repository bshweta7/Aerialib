class Constants {
  static String backendUri = "http://localhost:8000";
  static List<String> apparatusOptions = ["Lyra", "Hammock", "Conditioning"];
  static List<int> levelOptions = [0, 1, 2, 3, 4];
  static List<String> shareOptions = ["Default", "My Images", "Shared with Me"];
  static String missingImageId = "6a8e2421-5aa5-48a4-a0b2-73d6a28ef5d3";
  static String missingImageUrl = "/missing_image.jpg";
  static String mediaUrlPrefix = "$backendUri/media/data";
}