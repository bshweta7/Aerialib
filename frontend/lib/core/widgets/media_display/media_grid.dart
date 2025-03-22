import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:frontend/models/media_model.dart';
import 'package:frontend/features/media/pages/media_view_page.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/widgets/media_display/media_icon.dart';

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
              print("Tappable Icon");
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

