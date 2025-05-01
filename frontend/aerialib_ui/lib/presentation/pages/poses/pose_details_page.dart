import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/widgets/media_display/formatted_cached_network_image.dart';

class PoseDetailsPage extends StatefulWidget {
  final PoseEntity pose;

  const PoseDetailsPage({super.key, required this.pose});

  static MaterialPageRoute route(PoseEntity pose) => MaterialPageRoute(
    builder: (context) => PoseDetailsPage(pose: pose,),
  );

  @override
  State<PoseDetailsPage> createState() => _PoseDetailsPageState();
}

class _PoseDetailsPageState extends State<PoseDetailsPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final pose = widget.pose;

    return Scaffold(
      appBar: AppBar(
        title: Text(pose.name),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       // Navigator.push(
        //       //     context,
        //       //     UpdatePosePage.route(widget.pose)
        //       // );
        //     },
        //     tooltip: 'Edit this pose',
        //   ),
        //   ] // TODO ADD EDITING
      ),
        // TODO Ask about ordering of items on page, ensure consistency across add, edit, and details pages
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            Expanded(
              child: FormattedCachedNetworkImage(pose.primaryMediaPath),
            ),
            const SizedBox(height: 20),

            // Apparatus
            _infoRow("Apparatus:", pose.apparatus),

            // Level
            _infoRow("Level:", "Level ${pose.level}"),

            // Description
            _infoRow("Description:", pose.description),

            // Teaching Cues
            _infoRow("Teaching Cues:", pose.teachingCues),

            // Safety Cues
            _infoRow("Safety Cues:", pose.safetyCues),

            // Progressions
            _infoRow("Progressions:", pose.progressions),
          ],
        ),
      )
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : 'None',
              style: value?.isNotEmpty == true
                  ? null
                  : const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}