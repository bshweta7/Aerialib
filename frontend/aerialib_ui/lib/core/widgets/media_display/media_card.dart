import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'cached_network_image.dart';

class MediaCard extends StatelessWidget {
  // Creates tappable media card with detailed info
  const MediaCard(
      this.title,
      this.text,
      this.mediaUrl,
      this.onTapFunction,
      this.jwt,
      this.code,
      {super.key}
      );

  final String title;
  final String? text;
  final String mediaUrl;
  final GestureTapCallback? onTapFunction;
  final String jwt;
  final String code;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Card(
        margin: EdgeInsets.all(8.0),
        // clipBehavior: Clip.antiAlias, // TODO Check if this is the issue
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Expanded(
              //   child: CustomizedCachedNetworkImage(mediaUrl),
              // ),
              Image.network(
                "${Constants.mediaUrlPrefix}${mediaUrl}",
                width: 100.0, // Set the desired image width
                height: 100.0, // Set the desired image height
                fit: BoxFit.cover, // Adjust image fit
              ),

              SizedBox(width: 16.0), // Add spacing between image and text

              // Text information on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Description: ${text ?? 'None'}', // Handle null description
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  }
}

// TODO reference media.dart in apeturama
// TODO: Enable swipe down to reload
// TODO will eventually need to call media with jwt auth to ensure permissions
