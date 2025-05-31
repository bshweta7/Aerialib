// import 'dart:convert';
// import 'dart:developer';
// import 'package:uuid/uuid.dart';
//
// import 'package:frontend/data/models/pose_tag_model.dart';
// import 'package:frontend/data/services/http_service.dart';
//
// class PoseTagRemoteDataSource {
//   final HttpService httpService;
//
//   PoseTagRemoteDataSource({required this.httpService});
//
//   /// Create a new pose tag association
//   Future<PoseTagModel> createPoseTag({
//     required String poseId,
//     required String tagId,
//     required String token,
//   }) async {
//     final body = {
//       'pose_id': poseId,
//       'tag_id': tagId,
//     };
//
//     try {
//       final response = await httpService.post(
//         path: "/tags/pose",
//         token: token,
//         body: body,
//       );
//
//       return PoseTagModel.fromJson(response.body);
//     } catch (e) {
//       return PoseTagModel(
//         id: const Uuid().v6(),
//         poseId: poseId,
//         tagId: tagId,
//         userId: '', // Placeholder if needed
//         isSynced: 0,
//       );
//     }
//   }
//
//   /// Fetch all pose tag associations
//   Future<List<PoseTagModel>> fetchRemotePoseTags({
//     required String token,
//   }) async {
//     final response = await httpService.get(
//       path: "/tags/pose",
//       token: token,
//     );
//
//     final List<dynamic> jsonList = jsonDecode(response.body);
//     return jsonList.map((e) => PoseTagModel.fromMap(e)).toList();
//   }
//
//   /// Delete a pose tag association
//   Future<void> deletePoseTag({
//     required String poseId,
//     required String tagId,
//     required String token,
//   }) async {
//     final body = {
//       'poseId': poseId,
//       'tagId': tagId,
//     };
//
//     final response = await httpService.delete(
//       path: "/tags/pose",
//       token: token,
//       body: body,
//     );
//
//     if (response.statusCode == 200) {
//       log("[PoseTagRemoteDataSource] Deleted pose tag for pose $poseId and tag $tagId");
//     } else {
//       throw Exception("Failed to delete pose tag");
//     }
//   }
//
//   /// Sync pose tags
//   Future<bool> syncPoseTags({
//     required String token,
//     required List<PoseTagModel> poseTags,
//   }) async {
//     final poseTagListInMap = poseTags.map((tag) {
//       final map = tag.toMap();
//       map.remove('is_synced');
//       return map;
//     }).toList();
//
//     final response = await httpService.post(
//       path: "/tags/pose/sync",
//       token: token,
//       body: poseTagListInMap,
//     );
//
//     return response.statusCode == 201;
//   }
// }
