import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/widgets/media_display/formatted_cached_network_image.dart';

import '../../cubit/poses/poses_cubit.dart';
import 'pose_edit_page.dart';

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
    // final state = context.read<PosesCubit>().state;
    // late final PoseEntity updatedPose;
    //
    // if (state is GetPosesSuccess) {
    //   updatedPose = state.poses.firstWhere((p) => p.id == widget.pose.id);
    // } else {
    //   // fallback to old pose if needed
    //   updatedPose = widget.pose;
    // }
    //
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(pose.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  PoseEditDetailsPage.route(widget.pose)
              );
            },
            tooltip: 'Edit this pose',
          ),
          ] // TODO ADD EDITING
      ),
        // TODO Ask about ordering of items on page, ensure consistency across add, edit, and details pages
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated: image in a rounded Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.4,
                  minHeight: 20,
                ),
                width: double.infinity,
                child: FormattedCachedNetworkImage(pose.primaryMediaPath),
              ),
            ),
            const SizedBox(height: 20),

            _infoRow("Apparatus:", pose.apparatus),
            _infoRow("Level:", "Level ${pose.level}"),
            const Divider(),
            _infoRow("Description:", pose.description),
            _infoRow("Teaching Cues:", pose.teachingCues),
            _infoRow("Safety Cues:", pose.safetyCues),
            _infoRow("Progressions:", pose.progressions),
          ],
        ),
      ),
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
              style: TextStyle(
                fontStyle: value?.isNotEmpty == true
                    ? FontStyle.normal
                    : FontStyle.italic,
                color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
