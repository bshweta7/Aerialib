import 'package:flutter/material.dart';
import 'package:frontend/core/utils/media_grid.dart';
import 'package:frontend/models/pose_model.dart';

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
        actions: const [
            // GestureDetector(
            //   onTap: () async {
            //     final _selectedDate = await showDatePicker(
            //         context: context,
            //         firstDate: DateTime.now(),
            //         lastDate: DateTime.now().add(
            //             const Duration(days:90)
            //         )
            //     );
            //     if(_selectedDate!=null) {
            //       setState(() {
            //         selectedDate = _selectedDate;
            //       });
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(DateFormat("MM-d-y").format(selectedDate)),
            //   ),
            // )
          ] // TODO ADD EDITING
      ),
      body: Expanded(
        child: Padding( // TODO Ask about ordering of items on page, ensure consistency across add, edit, and view pages
          padding: const EdgeInsets.all(20),
          child:
            Column(
              children: [
                Expanded(child: MediaIcon(widget.pose, "", "")),

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
