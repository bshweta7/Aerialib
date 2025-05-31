// import 'dart:convert';
// import 'dart:developer';
// import 'package:uuid/uuid.dart';
//
// import 'package:frontend/data/models/flow_tag_model.dart';
// import 'package:frontend/data/services/http_service.dart';
//
// class FlowTagRemoteDataSource {
//   final HttpService httpService;
//
//   FlowTagRemoteDataSource({required this.httpService});
//
//   /// Create a new flow tag association
//   Future<FlowTagModel> createFlowTag({
//     required String flowId,
//     required String tagId,
//     required String token,
//   }) async {
//     final body = {
//       'flow_id': flowId,
//       'tag_id': tagId,
//     };
//
//     try {
//       final response = await httpService.post(
//         path: "/tags/flow",
//         token: token,
//         body: body,
//       );
//
//       return FlowTagModel.fromJson(response.body);
//     } catch (e) {
//       return FlowTagModel(
//         id: const Uuid().v6(),
//         flowId: flowId,
//         tagId: tagId,
//         userId: '', // placeholder
//         isSynced: 0,
//       );
//     }
//   }
//
//   /// Fetch all flow tag associations
//   Future<List<FlowTagModel>> fetchRemoteFlowTags({
//     required String token,
//   }) async {
//     final response = await httpService.get(
//       path: "/tags/flow",
//       token: token,
//     );
//
//     final List<dynamic> jsonList = jsonDecode(response.body);
//     return jsonList.map((e) => FlowTagModel.fromMap(e)).toList();
//   }
//
//   /// Delete a flow tag association
//   Future<void> deleteFlowTag({
//     required String flowId,
//     required String tagId,
//     required String token,
//   }) async {
//     final body = {
//       'flowId': flowId,
//       'tagId': tagId,
//     };
//
//     final response = await httpService.delete(
//       path: "/tags/flow",
//       token: token,
//       body: body,
//     );
//
//     if (response.statusCode == 200) {
//       log("[FlowTagRemoteDataSource] Deleted flow tag for flow $flowId and tag $tagId");
//     } else {
//       throw Exception("Failed to delete flow tag");
//     }
//   }
//
//   /// Sync flow tags
//   Future<bool> syncFlowTags({
//     required String token,
//     required List<FlowTagModel> flowTags,
//   }) async {
//     final flowTagListInMap = flowTags.map((tag) {
//       final map = tag.toMap();
//       map.remove('is_synced');
//       return map;
//     }).toList();
//
//     final response = await httpService.post(
//       path: "/tags/flow/sync",
//       token: token,
//       body: flowTagListInMap,
//     );
//
//     return response.statusCode == 201;
//   }
// }
