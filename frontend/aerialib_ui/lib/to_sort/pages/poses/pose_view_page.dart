import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid.dart';
import 'package:frontend/to_sort/pages/poses/edit_pose_page.dart';
import 'package:frontend/data/models/pose_model.dart';

import '../../../presentation/widgets/media_display/media_icon_grid_card.dart';

class PoseViewPage extends StatefulWidget {
  final PoseModel pose;

  const PoseViewPage({super.key, required this.pose});

  static MaterialPageRoute route(PoseModel pose) => MaterialPageRoute(
    builder: (context) => PoseViewPage(pose: pose,),
  );

  @override
  State<PoseViewPage> createState() => _PoseViewPageState();
}

class _PoseViewPageState extends State<PoseViewPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cuesController = TextEditingController();
  TextEditingController apparatusController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  // TextEditingController thumbnailURLController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pose.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  UpdatePosePage.route(widget.pose)
              );
            },
            tooltip: 'Edit this pose',
          ),
          ] // TODO ADD EDITING
      ),
      body: Expanded(
        child: Padding( // TODO Ask about ordering of items on page, ensure consistency across add, edit, and view pages
          padding: const EdgeInsets.all(20),
          child:
            Column(
              children: [
                // Expanded(
                //   child: MediaIconCard(
                //     widget.pose.name,
                //     widget.pose.primaryImageUrl,
                //     () {},
                //     "",
                //     "",
                //   )
                // ),

                // // TODO Alternative Names
                // Row(
                //   children: [
                //     Text("Alternative Names: "),
                //     Text(widget.pose.alternativeNames)
                //   ],

                // Level
                Row(
                  children: [
                    const Text(
                      "Level: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    Text('Level ${widget.pose.level}')
                  ],
                ),

                // Apparatus
                Row(
                  children: [
                    const Text(
                      "Apparatus: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    Text(widget.pose.apparatus)
                  ],
                ),

                // Description
                Row(
                  children: [
                    const Text(
                      "Description: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    if (widget.pose.description != null)
                      Text('${widget.pose.description}')
                    else
                      const Text(
                        'None',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),

                // Cues
                Row(
                  children: [
                    const Text(
                        "Cues: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    if (widget.pose.cues != null)
                      Text('${widget.pose.cues}')
                    else
                      const Text(
                        'None',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ],
            )
            // TODO Make a media slider for this page
            // TODO media icon name should be more discrete - in dark translucent bar on bottom maybe?
            // TODO Rename pose name to "original name by manual" if default, or "original name by _username_" if user uploaded
        ),
      )
    );
  }
}
