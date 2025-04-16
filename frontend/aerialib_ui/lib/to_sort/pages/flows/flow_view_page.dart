// TODO this page will show each pose in the flow

import 'package:flutter/material.dart';
// import 'package:frontend/core/widgets/media_display/flow_grid.dart';
import 'package:frontend/to_sort/pages/flows/edit_flow_page.dart';
import 'package:frontend/to_sort/models/flow_model.dart';

import '../widgets/media_display/media_icon.dart';

class FlowViewPage extends StatefulWidget {
  final FlowModel flow;

  const FlowViewPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowModel flow) => MaterialPageRoute(
    builder: (context) => FlowViewPage(flow: flow,),
  );

  @override
  State<FlowViewPage> createState() => _FlowViewPageState();
}

class _FlowViewPageState extends State<FlowViewPage> {
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
        title: Text(widget.flow.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     UpdateFlowPage.route(widget.flow)
              // );
            },
            tooltip: 'Edit this flow',
          ),
          ] // TODO ADD EDITING
      ),
      body: Expanded(
        child: Padding( // TODO Ask about ordering of items on page, ensure consistency across add, edit, and view pages
          padding: const EdgeInsets.all(20),
          child:
            Column(
              children: [
                // Expanded(child: MediaIcon(widget.flow.name, "", "")),

                // // TODO Alternative Names
                // Row(
                //   children: [
                //     Text("Alternative Names: "),
                //     Text(widget.flow.alternativeNames)
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
                    // Text('Level ${widget.flow.level}')
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
                    // Text(widget.flow.apparatus)
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
                    if (widget.flow.description != null)
                      Text('${widget.flow.description}')
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
                    // if (widget.flow.cues != null)
                    //   Text('${widget.flow.cues}')
                    // else
                    //   const Text(
                    //     'None',
                    //     style: TextStyle(fontStyle: FontStyle.italic),
                    //   ),
                  ],
                ),
              ],
            )
            // TODO Make a media slider for this page
            // TODO media icon name should be more discrete - in dark translucent bar on bottom maybe?
            // TODO Rename flow name to "original name by manual" if default, or "original name by _username_" if user uploaded
        ),
      )
    );
  }
}
