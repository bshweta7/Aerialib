import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import 'package:frontend/shared/widgets/media_display/multi_card_view/horizontal_scroll_gallery.dart';
import 'package:frontend/features/transitions/presentation/cubit/transition_cubit.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/pose/domain/entities/pose_entity.dart';
import '../../../helpers/conversions.dart';

class TransitionGalleryCard extends StatelessWidget {
  final String poseId;
  final String title;
  final bool isIncoming;
  final double height;
  final void Function(TransitionEntity transition)? onTap;
  final void Function(PoseEntity pose)? onSuggestedPoseSelected;

  const TransitionGalleryCard({
    super.key,
    required this.poseId,
    required this.title,
    required this.isIncoming,
    required this.height,
    this.onTap,
    this.onSuggestedPoseSelected,
  });

  @override
  Widget build(BuildContext context) {
    final transitionsCubit = context.read<TransitionCubit>();
    final posesCubit = context.read<PosesCubit>();

    return FutureBuilder<List<TransitionEntity>>(
      future: isIncoming
          ? transitionsCubit.getIncomingTransitionsForPose(poseId)
          : transitionsCubit.getOutgoingTransitionsForPose(poseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading transitions: ${snapshot.error}');
        } else {
          final transitions = snapshot.data ?? [];

          final mediaIcons = transitionPosesToMediaIcons(
              transitions: transitions,
              poseMap: { for (final p in posesCubit.poses) p.id: p},
              onTap: (transition) {
                context.goNamed(
                  'transition-view',
                  pathParameters: {'transitionId': transition.id},
                  queryParameters: {'from': 'pose-view'},
                ); // TODO when you click back from transition, it goes to pose library
              },

              isIncoming: isIncoming,
          );

          if (mediaIcons.isEmpty) return const SizedBox();

          return ExpandableCard(
            title: title,
            initiallyExpanded: true,
            children: [
              HorizontalScrollGallery(
                mediaList: mediaIcons,
                height: height,
              ),
            ],
          );
        }
      }
    );
  }
}
