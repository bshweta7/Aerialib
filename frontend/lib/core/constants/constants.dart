class Constants {
  // Urls
  static String backendUri = "http://localhost:8000";
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
}