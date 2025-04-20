import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/to_sort/pages/poses/add_new_pose_page.dart'; // TODO modify to take in the route so itll work for all.

class AddNewPoseButton extends StatelessWidget {
  const AddNewPoseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Add new pose',
      icon: const Icon(CupertinoIcons.add),
      onPressed: () {
        Navigator.push(context, AddNewPosePage.route());
      },
    );
  }
}