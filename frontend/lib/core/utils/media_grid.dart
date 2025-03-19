import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/features/poses/pages/pose_view.dart';
import 'package:frontend/models/pose_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


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


class MediaGrid extends StatelessWidget {

  const MediaGrid(
      this.media,
      this.gridSize,
      this.jwt,
      this.code,
      {super.key}
      );

  final List media;
  final int gridSize;
  final String jwt;
  final String code;

  Widget _createTappableMediaIcon(BuildContext context, PoseModel poses) { // FIXME why posemodel?
    // Make a nice button that has the thumbnail inside it
    return GestureDetector(
        onTap: () {
          Navigator.push(context, PoseViewPage.route());
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
      child: MediaIcon(poses, jwt, code),
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
        return _createTappableMediaIcon(context, media[index]);
      },
      itemCount: media.length,
    );
  }
}

class MediaIcon extends StatelessWidget {
  const MediaIcon(
      this.poses,
      this.jwt,
      this.code,
      {super.key}
      );

  final PoseModel poses;
  final String jwt;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              poses.name,
              style: const TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
              // TODO styling - dynamically change font size based on the grid size
              // TODO styling - separate text within the card
              // TODO should any filters be shown here?
            ),

            // TODO thumbnail should always be the right size?

            // TODO if no connectivity, either show no image or missing image pic if it can't get the actual image
             Expanded(
               child: Image.network(
                'http://localhost:8000/media/data/testing/clock.jpg',
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                 // TODO Round edges of image
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Text('Could not load image');
                },
                           ),
             ),

            const SizedBox(height: 10)


            // CachedNetworkImage( // TODO figure out CachedNetworkImage for offline first - seems to work if we remove column but need to update media icon to make text still appear
            //   // TODO see below code for authenticated images (permissions):
            //   // httpHeaders: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt },
            //   // imageUrl: poses.thumbnailURL + (code.isEmpty ? "" : "?code=" + code),
            //   // imageUrl: 'http://localhost:8000/media/data/testing/clock.jpg',
            //   imageUrl: 'https://hbh7.com/resume/resources/logo.png',
            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
            //     SizedBox(width: 32, height: 32, child: CircularProgressIndicator(value: downloadProgress.progress)),
            //   errorWidget: (context, url, error) => const Icon(Icons.error),
            //   imageBuilder: (context, imageProvider) {
            //     return Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: imageProvider,
            //           fit: BoxFit.fitWidth,
            //         ),
            //       ),
            //     );
            //   }
            // ),


          ],
        ),
      ),
    );
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  }
}