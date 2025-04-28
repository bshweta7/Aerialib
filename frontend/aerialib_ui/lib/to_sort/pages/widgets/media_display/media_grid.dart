import 'package:flutter/material.dart';
import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/to_sort/pages/media/media_view_page.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid/media_icon_grid_card.dart';

// TODO if the screen is too small, only show name if tapped on ?

class MediaGrid extends StatelessWidget {

  const MediaGrid(
      this.mediaList,
      this.gridSize,
      this.jwt,
      this.code,
      {super.key}
      );

  final List<MediaModel> mediaList;
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
        // return MediaIconCard(
        //   mediaList[index].name,
        //   mediaList[index].mediaURL,
        //   () {
        //     Navigator.push(
        //       context,
        //       MediaViewPage.route(mediaList[index])
        //     );
        //   },
        //   "",
        //   "",
        // );
      },
      itemCount: mediaList.length,
    );
  }
}

