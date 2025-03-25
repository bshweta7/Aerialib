import 'package:flutter/material.dart';

import 'package:frontend/models/pose_model.dart';
import 'package:frontend/features/poses/pages/pose_view_page.dart';

import 'package:frontend/core/widgets/media_display/media_icon.dart';


// TODO if the screen is too small, only show name if tapped on ?

class PoseGrid extends StatelessWidget {

  const PoseGrid(
      this.poseList,
      this.gridSize,
      this.jwt,
      this.code,
      {super.key}
      );

  final List<PoseModel> poseList;
  final int gridSize;
  final String jwt;
  final String code;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      // This is needed for the shared media page
      // so that it doesn't scroll within the larger scrollable list
      physics: const ClampingScrollPhysics(),
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridSize),
      itemBuilder: (BuildContext context, int index) {
        return MediaIcon(
          poseList[index].name,
          poseList[index].primaryImageUrl,
          () {
            Navigator.push(
                context,
                PoseViewPage.route(poseList[index])
            );
          },
          "",
          "",
        );
      },
      itemCount: poseList.length,
    );
  }
}

