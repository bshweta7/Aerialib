import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid/media_icon_grid_card.dart'; // TODO shouldn't use media icon here... use sliding image display
import 'package:frontend/data/models/media_model.dart';


// TODO MAKE THIS PAGE
class MediaViewPage extends StatefulWidget {
  final MediaModel media;

  const MediaViewPage({super.key, required this.media});

  static MaterialPageRoute route(MediaModel media) => MaterialPageRoute(
    builder: (context) => MediaViewPage(media: media,),
  );

  @override
  State<MediaViewPage> createState() => _MediaViewPageState();
}

class _MediaViewPageState extends State<MediaViewPage> {
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
            title: Text(widget.media.name),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.edit),
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         UpdateMediaPage.route(widget.media)
              //     );
              //   },
              //   tooltip: 'Edit this media',
              // ),
            ] // TODO ADD EDITING
        ),
        body: Expanded(
          child: Padding( // TODO Ask about ordering of items on page, ensure consistency across add, edit, and view pages
              padding: const EdgeInsets.all(20),
              child:
              Column(
                children: [
                  // Expanded(child: MediaIconCard(
                  //     widget.media.name,
                  //     widget.media.mediaURL,
                  //     () {},
                  //     "",
                  //     ""
                  // )),

                  // // TODO Alternative Names
                  // Row(
                  //   children: [
                  //     Text("Alternative Names: "),
                  //     Text(widget.media.alternativeNames)
                  //   ],

                  // Apparatus
                  Row(
                    children: [
                      const Text(
                          "Apparatus: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(widget.media.apparatus)
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
                      if (widget.media.description != null)
                        Text('${widget.media.description}')
                      else
                        const Text(
                          'None',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),

                  // TODO people should be able to comment on media like reddit
                ],
              )
            // TODO Make a media slider for this page
            // TODO media icon name should be more discrete - in dark translucent bar on bottom maybe?
            // TODO Rename media name to "original name by manual" if default, or "original name by _username_" if user uploaded
          ),
        )
    );
  }
}
