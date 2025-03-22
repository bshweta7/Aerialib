import 'package:frontend/features/poses/pages/pose_view_page.dart';
import 'package:frontend/models/pose_model.dart';
import 'package:flutter/material.dart';

import 'media_icon.dart';

// TODO combine with media_grid

// TODO: Enable swipe down to reload

// TODO will eventually need to call media with jwt auth to ensure permissions
// See if code below is helpful ----

  //   // Send a request to the backend
  //   String serverAddress = await User.getServerAddress();
  //   jwt = await User.getJWT();
  //   http.Response resp;
  //   try {
  //     resp = await http.get(Uri.parse(serverAddress + '/api/v1/media'),
  //         headers: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt });
  //
  //     if(resp.statusCode != 200) {
  //       log("Media listing failed: Code " + resp.statusCode.toString());
  //       return media;
  //     }
  //
  //     final responseJson = jsonDecode(resp.body);
  //
  //     // For each media item we got
  //     for (int i = 0; i < responseJson.length; i++) {
  //       media.add(Media(
  //         responseJson[i]["media_id"].toString(), MediaType.photo,
  //         serverAddress + "/api/v1/media/" + responseJson[i]["media_id"].toString() + '/thumbnail',
  //         serverAddress + "/api/v1/media/" + responseJson[i]["media_id"].toString() + '/media',
  //       ));
  //       media[i].filename = responseJson[i]["filename"];
  //       media[i].takenTimestamp = (responseJson[i]["date_taken"] != null) ? DateTime.parse(responseJson[i]["date_taken"]) : DateTime.now();
  //     }
  //
  //   } on SocketException {
  //     log("Media listing failed: Socket exception");
  //     return media;
  //   }
  //
  //   // TODO: Save and load from disk if network is unavailable
  //
  //   return media;
  // }
// }


class PoseMediaGrid extends StatelessWidget {

  const PoseMediaGrid(
      this.poses,
      this.gridSize,
      this.jwt,
      this.code,
      {super.key}
      );

  final List poses;
  final int gridSize;
  final String jwt;
  final String code;

  Widget _createTappableMediaIcon(
      BuildContext context,
      PoseModel pose
      ) {
    // Make a nice button that has the thumbnail inside it
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PoseViewPage.route(pose)
          );
        },
        // onTap: () => {
        //   Navigator.pushNamed(
        //   context,
        //   '/media_viewer',
        //   arguments: <String, dynamic>{
        //     'media': poses,
        //     'jwt': jwt,
        //     'code': "",
        //   },
        // )},
      child: MediaIcon(pose.name, pose.primaryImageUrl, jwt, code),
    );
  }

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
        return _createTappableMediaIcon(
          context,
          poses[index]
        );
      },
      itemCount: poses.length,
    );
  }
}

