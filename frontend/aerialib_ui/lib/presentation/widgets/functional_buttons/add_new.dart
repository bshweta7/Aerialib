import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/presentation/pages/poses/add_new_pose_page.dart';
import 'package:go_router/go_router.dart'; // TODO modify to take in the route so itll work for all.

// TODO See how flow handles this - why does this need to exist?

class AddNewPoseButton extends StatelessWidget {
  const AddNewPoseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Add new pose',
      icon: const Icon(CupertinoIcons.add),
      onPressed: () => context.goNamed('add-new-pose'),

    );
  }
}