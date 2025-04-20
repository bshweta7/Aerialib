import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../formatted_cached_network_image.dart';

class ListCard extends StatelessWidget {
  // Creates tappable list with image, name, subtitle
  const ListCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTapFunction,
    super.key,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final GestureTapCallback? onTapFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Card(
        margin: EdgeInsets.all(5.0), // To ensure it takes full width
        elevation: 2.0,
        clipBehavior: Clip.none,
        shape: RoundedRectangleBorder(
          // side: const BorderSide(color: Colors.grey, width: 1.0), // Customize color and width
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
        width: double.infinity, // Makes the SizedBox take full width
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: ClipRRect( // To round the image corners if you like
                  borderRadius: BorderRadius.circular(8.0),
                  child: FormattedCachedNetworkImage(imageUrl),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis, // Handle long text
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}

// Column(
//           mainAxisSize: MainAxisSize.min,
//           // TODO thumbnail should always be the right size (square)
//           // TODO if no connectivity, either show no image or missing image pic if it can't get the actual image
//
//           children: [
//             // TODO remove this and add aspect ratio back to make it take the whole space
//             // Expanded(
//             //   child: CustomizedCachedNetworkImage(mediaUrl),
//             // ),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//               // TODO styling - dynamically change font size based on the grid size
//               // TODO styling - separate text within the card
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // TODO reference media.dart in apeturama
// // TODO: Enable swipe down to reload
// // TODO will eventually need to call media with jwt auth to ensure permissions
