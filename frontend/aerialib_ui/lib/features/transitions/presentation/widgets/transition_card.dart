import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/info_display/info_chip.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/helpers/formatters.dart';
import '../../../pose/domain/entities/pose_entity.dart';
import '../../domain/transition_entity.dart';

class TransitionCard extends StatelessWidget {
  final TransitionEntity transition;
  final PoseEntity fromPose; // TODO wont need this after trans entity stores pose entity
  final PoseEntity toPose;
  final VoidCallback? onTap;

  const TransitionCard({
    super.key,
    required this.transition,
    required this.fromPose, 
    required this.toPose,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final transitionName = transition.name ?? '${fromPose.displayName} → ${toPose.displayName}';
    final transitionType = transition.transitionType == null ? '' : "| Type: ${capitalizeFirstLetter(transition.transitionType!)}";
    final transitionLevel = transition.level == null ? '' : formatLevel(transition.level!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  transitionName,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.end,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: [
                    // TODO can add other qualifiers here (like apparatus, level) in row with pill indicators
                    Text(
                      '$transitionLevel $transitionType',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      // textAlign: TextAlign.end,
                    ),
                    // Text(
                    //   transitionLevel,
                    //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                    //   // textAlign: TextAlign.end,
                    // ),
                  ],
                ),
              ),
              Row(
                children: [
                  _PosePreview(pose: fromPose, label: "From"),
                  const Icon(Icons.arrow_forward, size: 28),
                  _PosePreview(pose: toPose, label: "To"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosePreview extends StatelessWidget {
  final PoseEntity pose;
  final String label;

  const _PosePreview({required this.pose, required this.label});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sectionWidth = (screenWidth - 100) / 2; // TODO change 2 to 3 if adding something else on side

    return SizedBox(
      width: sectionWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FormattedCachedNetworkImage(pose.primaryMediaPath),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pose.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            softWrap: true,
          ),
          Text(
            formatLevel(pose.level!),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

