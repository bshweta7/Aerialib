import 'package:flutter/material.dart';

import '../formatted_cached_network_image.dart';

class ListCard extends StatelessWidget {
  // Creates tappable list with image, name, subtitle
  const ListCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTapFunction,
    this.trailing,
    this.isFavorite,
    this.onFavoriteToggle,
    super.key,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final Widget? trailing;
  final GestureTapCallback? onTapFunction;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 2.0,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: onTapFunction,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FormattedCachedNetworkImage(imageUrl),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isFavorite != null)
                IconButton(
                  icon: Icon(
                    isFavorite! ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite! ? Colors.red : Colors.grey,
                  ),
                  onPressed: onFavoriteToggle,
                )
              else if (trailing != null)
                trailing!,
            ],
          ),
        ),
      ),
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
// // TODO will eventually need to call media with jwt user to ensure permissions
