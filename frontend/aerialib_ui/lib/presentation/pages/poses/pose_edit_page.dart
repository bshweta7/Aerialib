import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';


class PoseEditDetailsPage extends StatefulWidget {
  final PoseEntity pose;

  const PoseEditDetailsPage({super.key, required this.pose});

  @override
  State<PoseEditDetailsPage> createState() => _PoseEditDetailsPageState();
}


class _PoseEditDetailsPageState extends State<PoseEditDetailsPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController teachingCuesController;
  late TextEditingController safetyCuesController;
  late TextEditingController progressionsController;
  late String apparatus;
  late double level;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.pose.name);
    descriptionController =
        TextEditingController(text: widget.pose.description);
    teachingCuesController =
        TextEditingController(text: widget.pose.teachingCues);
    safetyCuesController = TextEditingController(text: widget.pose.safetyCues);
    progressionsController = TextEditingController(text: widget.pose.progressions);

    apparatus = widget.pose.apparatus;
    level = widget.pose.level;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    super.dispose();
  }


  Future<void> _handleUpdatePose() async {
    if (!formKey.currentState!.validate()) return;

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedPose = PoseEntity(
      id: widget.pose.id,
      name: nameController.text.trim(),
      primaryMediaId: widget.pose.primaryMediaId,
      primaryMediaPath: widget.pose.primaryMediaPath,
      description: descriptionController.text.trim(),
      teachingCues: teachingCuesController.text.trim(),
      safetyCues: safetyCuesController.text.trim(),
      progressions: progressionsController.text.trim(),
      apparatus: apparatus,
      level: level,
      createdBy: widget.pose.createdBy,
      createdAt: widget.pose.createdAt,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<PosesCubit>().updatePoseInfo(
      updatedPose: updatedPose,
      token: user.user.token,
    );

    await context.read<PosesCubit>().getAllPoses(token: user.user.token);

    // Save completed
    // TODO Verify and add back the context.pop stuff
    // Navigator.pop(context); // pop PoseEdit → returns to PoseDetails
    // Navigator.pop(context); // pop PoseDetails → back to PoseLibrary

    // Then push PoseDetails again (fresh)
    context.goNamed(
      'pose-view',
      pathParameters: {
        'poseId': updatedPose.id,
      },
      extra: updatedPose,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Pose'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _handleUpdatePose,
            tooltip: 'Save changes',
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: requiredFieldValidator,
                ),

                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: apparatus,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        apparatus = newValue;
                      });
                    }
                  },
                  items: Constants.apparatusOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Apparatus'),
                  validator: requiredFieldValidator,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Level'),
                  keyboardType: TextInputType.number,
                  initialValue: level.toString(),
                  onChanged: (value) {
                    setState(() {
                      level = double.tryParse(value) ?? level;
                    });
                  },
                  validator: requiredFieldValidator,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: teachingCuesController,
                  decoration: const InputDecoration(labelText: 'Teaching Cues'),
                  maxLines: 2,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: safetyCuesController,
                  decoration: const InputDecoration(labelText: 'Safety Cues'),
                  maxLines: 2,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: progressionsController,
                  decoration: const InputDecoration(labelText: 'Progressions'),
                  maxLines: 2,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleUpdatePose,
                  child: const Text('Update Pose'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
