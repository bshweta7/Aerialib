import 'package:flutter/material.dart';
import 'package:frontend/features/flows/widgets/poses_in_flow_card.dart';

import '../../../core/constants/constants.dart';
import '../../../models/flow_model.dart';

class FlowCardList extends StatelessWidget {
  final List<FlowModel> flowsList;
  final List<List<String>> posesInFlowsList; // TODO Make this poseModel

  FlowCardList({
    required this.flowsList,
    required this.posesInFlowsList
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: flowsList.length,
      itemBuilder: (context, index) {
        final flow = flowsList[index];
        return Card(
          margin: EdgeInsets.all(8.0), // Add margin for spacing
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                // Image on the left
                Image.network(
                  "${Constants.mediaUrlPrefix}${flow.primaryImageUrl}",
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
                        flow.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Description: ${flow.description ?? 'None'}', // Handle null description
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ),
        );
      },
    );
  }
}

// Example usage:
// FlowCardList(flowsList: yourFlowsList);