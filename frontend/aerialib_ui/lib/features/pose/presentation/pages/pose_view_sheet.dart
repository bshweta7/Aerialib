import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';

import '../../../../shared/widgets/info_display/info_row.dart';


class PoseViewSheet extends StatelessWidget {
  final PoseEntity pose;

  const PoseViewSheet({
    super.key,
    required this.pose,
  });

  /// Modal Bottom Sheet launcher
  static Future<void> show({
    required BuildContext context,
    required PoseEntity pose,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: PoseViewSheet(pose: pose),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    // Widget _infoRow(String label, String? value) {
    //   return Padding(
    //     padding: const EdgeInsets.only(bottom: 10),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "$label ",
    //           style: const TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         Expanded(
    //           child: Text(
    //             value?.isNotEmpty == true ? value! : 'None',
    //             style: TextStyle(
    //               fontStyle: value?.isNotEmpty == true
    //                   ? FontStyle.normal
    //                   : FontStyle.italic,
    //               color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Text(
          pose.slug,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Image in rounded card
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
            child: FormattedCachedNetworkImage("/${pose.primaryMediaPath}"),
          ),
        ),
        const SizedBox(height: 20),

        InfoRow("Apparatus:", capitalizeFirstLetter(pose.apparatus)),
        InfoRow("Level:", "Level ${pose.level}"),
        const Divider(),
        InfoRow("Description:", pose.description),
        InfoRow("Teaching Cues:", pose.teachingCues),
        InfoRow("Safety Cues:", pose.safetyCues),
        InfoRow("Progressions:", pose.progressions),
      ],
    );
  }
}
