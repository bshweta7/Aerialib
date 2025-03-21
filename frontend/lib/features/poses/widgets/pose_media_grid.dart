// import 'package:flutter/material.dart';
// import 'package:frontend/core/utils/pose_media_grid.dart';
// import 'package:frontend/features/poses/pages/add_new_pose_page.dart';
//
// import '../../../models/pose_model.dart';
// import '../pages/pose_view_page.dart';
// // import 'package:your_app/pose_view_page.dart';
//
// class PoseMediaGrid extends StatelessWidget {
//   final List<PoseModel> poses;
//   final String jwt;
//   final String code;
//   final int gridSize;
//
//   PoseMediaGrid({
//     required this.poses,
//     required this.jwt,
//     required this.code,
//     required this.gridSize,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // List<String> titlesList = poses.map((pose) => pose.name).toList();
//     // List<String> mediaPathsList = poses.map((pose) => "http://localhost:8000/media/data"+pose.primaryImageUrl).toList(); // Assuming primaryImageUrl is the correct path
//
//     return MediaGrid(
//       items: poses,
//       getImageUrl: (pose) => (pose as PoseModel).primaryImageUrl,
//       jwt: jwt,
//       code: code,
//       createTappableIcon: _createTappableMediaIcon,
//     );
//   }
//
//   @override
//   Widget _createTappableMediaIcon(BuildContext context, dynamic item, String imageUrl) {
//     PoseModel pose = item as PoseModel; // Cast item to PoseModel
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context, PoseViewPage.route(pose));
//       },
//       child: MediaIcon(pose.name, imageUrl, jwt, code),
//     );
//   }
// }