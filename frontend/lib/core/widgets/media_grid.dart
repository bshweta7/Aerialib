import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../features/media/pages/media_view_page.dart';
import '../../models/media_model.dart';
import '../constants/constants.dart';

// TODO clean up media grid across all features
// TODO if the screen is too small, only show name if tapped on ?

// THIS IS THE GOOD ONE BTW USE IT ELSEWHERE :D
class MediaGrid extends StatelessWidget {

  const MediaGrid(
      this.mediaList,
      this.gridSize,
      this.jwt,
      this.code,
      {super.key}
      );

  final List mediaList;
  final int gridSize;
  final String jwt;
  final String code;


  static int calculateNewGridSize(
      int amount,
      int gridSize,
      Size windowSize,
      bool kDebugMode
      ) {
    /// Function to handle changing the size of the photo grid ///

    // Adjust this variable higher to allow less items on screen per a given width
    // Basically its doing (windowWidth / windowSizeFactor)
    int windowSizeFactor = 205;

    int gridSizeMax = (windowSize.width / windowSizeFactor).ceil();
    if (kDebugMode) {
      print("Window Size: $windowSize");
      print("Width: ${windowSize.width}");
      print("Grid Size Max: $gridSizeMax");
    }

    // Set the grid size to the maximum on first startup
    if (gridSize == 0) {
      gridSize = gridSizeMax;
    }

    // Make sure the grid size isn't currently invalid (too many columns)
    // such as due to a window size change
    else if (gridSize > gridSizeMax) {
      gridSize = gridSizeMax;
    }

    // Otherwise adjust by provided amount
    else if (gridSize > 0) {
      // Scale the amount increase on larger screens
      amount *= gridSizeMax > 10 ? 2 : 1;

      // If removing columns
      if (amount < 0) {
        // Make sure the grid size can't go below 1
        if (gridSize + amount <= 0) {
          gridSize = 1;
        } else {
          gridSize += amount;
        }

        // If adding columns
      } else if (amount > 0) {
        // Make sure the grid size can't go above the max size
        if (gridSize + amount > gridSizeMax) {
          gridSize = gridSizeMax;
        } else {
          gridSize += amount;
        }
      }
    }
    return gridSize;
  }

  Widget _createTappableMediaIcon(
      BuildContext context,
      MediaModel media,
      GestureTapCallback? onTapForGesture,
      ) {
    // Debug print out the url
    if (kDebugMode) {
      print(Constants.mediaUrlPrefix + media.mediaURL);
    }
    // Make a nice button that has the thumbnail inside it
    return GestureDetector(
      onTap: onTapForGesture,
      child: MediaIcon(media.name, media.mediaURL, jwt, code),
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
          mediaList[index],
          () {
            if (kDebugMode) {
              print("FUNCTIONALOOOONNEEYNNEYEYEEYYYYNNNNYETTTTTTTT");
            }
            Navigator.push(
              context,
              MediaViewPage.route(mediaList[index])
            );
          }
        );
      },
      itemCount: mediaList.length,
    );
  }
}

class MediaIcon extends StatelessWidget {
  const MediaIcon(
      this.title,
      this.mediaUrl,
      this.jwt,
      this.code,
      {super.key}
      );

  final String title;
  final String mediaUrl;
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
              title,
              style: const TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
              // TODO styling - dynamically change font size based on the grid size
              // TODO styling - separate text within the card
            ),

            // TODO thumbnail should always be the right size (square)

            // TODO if no connectivity, either show no image or missing image pic if it can't get the actual image
             Expanded(
               child:
                 CachedNetworkImage(
                   // TODO see below code for authenticated images (permissions):
                   // httpHeaders: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt },
                   // imageUrl: poses.thumbnailURL + (code.isEmpty ? "" : "?code=" + code),
                   // imageUrl: 'http://localhost:8000/media/data/testing/clock.jpg',
                     imageUrl: Constants.mediaUrlPrefix + mediaUrl,
                     progressIndicatorBuilder: (context, url, downloadProgress) =>
                         SizedBox(
                             width: 32,
                             height: 32,
                             child: CircularProgressIndicator(
                              value: downloadProgress.progress
                             )
                         ),
                     errorWidget: (context, url, error) => const Icon(Icons.error),
                     imageBuilder: (context, imageProvider) {
                       return Container(
                         decoration: BoxDecoration(
                           image: DecorationImage(
                             image: imageProvider,
                             fit: BoxFit.fitWidth,
                           ),
                         ),
                       );
                     }
                 ),
               ),

            const SizedBox(height: 10)
          ],
        ),
      ),
    );
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  }
}

// TODO reference media.dart in apeturama
// TODO: Enable swipe down to reload
// TODO will eventually need to call media with jwt auth to ensure permissions
