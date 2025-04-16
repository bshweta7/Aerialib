import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../models/flow_model.dart';

class PosesInFlowCard extends StatelessWidget {
  final List<List<String>> posesInFlowsList; // TODO Make this poseModel

  PosesInFlowCard({
    required this.posesInFlowsList
  });

  @override
  Widget build(BuildContext context) {
    // TODO make this a slider (horizontal scroll)
    // TODO upgrade this with the media icon code
    return
      Card(
      child: SizedBox(
        height:120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Make it a horizontal scroll
          itemCount: posesInFlowsList.length,
          itemBuilder: (context, index) {
            final poseURL = posesInFlowsList[index]; // TODO change this to pose
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Image on the left
                  Image.network(
                    "${Constants.mediaUrlPrefix}${poseURL}", // TODO change to pose.media_url
                    width: 100.0, // Set the desired image width
                    height: 100.0, // Set the desired image height
                    fit: BoxFit.cover, // Adjust image fit
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(child: Icon(Icons.error)),
                      );
                    },
                  ),
                  SizedBox(width: 16.0), // Add spacing between image and text
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Example usage:
// FlowCardList(flowsList: yourFlowsList);