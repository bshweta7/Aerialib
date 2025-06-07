import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import 'package:frontend/shared/widgets/input_fields/dropdown_field.dart';
import 'package:frontend/shared/widgets/input_fields/int_input_field.dart';
import 'package:frontend/shared/widgets/input_fields/text_input_field.dart';

import '../../../../shared/features/navigation/widgets/smart_back_button.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';

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
  late TextEditingController modificationsController;
  late TextEditingController commonErrorsController;

  late TextEditingController altNameController;
  late TextEditingController baseNameController;
  late TextEditingController prefixController;
  late TextEditingController suffixController;
  late TextEditingController handPositionController;
  late TextEditingController legPositionController;
  late TextEditingController positionInBarController;
  late TextEditingController poseTypeController;

  late TextEditingController levelController;
  late TextEditingController apparatusController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pose.displayName);
    descriptionController = TextEditingController(text: widget.pose.description);
    teachingCuesController = TextEditingController(text: widget.pose.teachingCues);
    safetyCuesController = TextEditingController(text: widget.pose.safetyCues);
    progressionsController = TextEditingController(text: widget.pose.progressions);
    modificationsController = TextEditingController(text: widget.pose.modifications);
    commonErrorsController = TextEditingController(text: widget.pose.commonErrors);

    altNameController = TextEditingController(text: widget.pose.altName);
    baseNameController = TextEditingController(text: widget.pose.baseName);
    prefixController = TextEditingController(text: widget.pose.prefix);
    suffixController = TextEditingController(text: widget.pose.suffix);
    handPositionController = TextEditingController(text: widget.pose.handPosition);
    legPositionController = TextEditingController(text: widget.pose.legPosition);
    positionInBarController = TextEditingController(text: widget.pose.positionInBar);
    poseTypeController = TextEditingController(text: widget.pose.poseType);

    levelController = TextEditingController(
        text: widget.pose.level != null ? widget.pose.level.toString() : '');
    apparatusController = TextEditingController(text: widget.pose.apparatus);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    modificationsController.dispose();
    commonErrorsController.dispose();

    altNameController.dispose();
    baseNameController.dispose();
    prefixController.dispose();
    suffixController.dispose();
    handPositionController.dispose();
    legPositionController.dispose();
    positionInBarController.dispose();
    poseTypeController.dispose();

    levelController.dispose();
    apparatusController.dispose();

    super.dispose();
  }

  Future<void> _handleUpdatePose() async {
    if (!formKey.currentState!.validate()) return;

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedPose = widget.pose.copyWith(
      displayName: nameController.text.trim(),
      altName: altNameController.text.trim().isNotEmpty ? altNameController.text.trim() : null,
      baseName: baseNameController.text.trim().isNotEmpty ? baseNameController.text.trim() : null,
      prefix: prefixController.text.trim().isNotEmpty ? prefixController.text.trim() : null,
      suffix: suffixController.text.trim().isNotEmpty ? suffixController.text.trim() : null,
      handPosition: handPositionController.text.trim().isNotEmpty ? handPositionController.text.trim() : null,
      legPosition: legPositionController.text.trim().isNotEmpty ? legPositionController.text.trim() : null,
      positionInBar: positionInBarController.text.trim().isNotEmpty ? positionInBarController.text.trim() : null,
      poseType: poseTypeController.text.trim().isNotEmpty ? poseTypeController.text.trim() : null,
      apparatus: apparatusController.text.trim(),
      level: int.tryParse(levelController.text.trim()),
      description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
      teachingCues: teachingCuesController.text.trim().isNotEmpty ? teachingCuesController.text.trim() : null,
      safetyCues: safetyCuesController.text.trim().isNotEmpty ? safetyCuesController.text.trim() : null,
      progressions: progressionsController.text.trim().isNotEmpty ? progressionsController.text.trim() : null,
      modifications: modificationsController.text.trim().isNotEmpty ? modificationsController.text.trim() : null,
      commonErrors: commonErrorsController.text.trim().isNotEmpty ? commonErrorsController.text.trim() : null,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<PosesCubit>().updatePoseInfo(
      updatedPose: updatedPose,
      token: user.user.token,
    );

    await context.read<PosesCubit>().getAllPoses(token: user.user.token);

    context.goNamed(
        'pose-view',
        pathParameters: {'poseId': updatedPose.id},
        queryParameters: {'from': 'pose-edit'}
    );
  }

  Future<void> _handleDeletePose() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: "Confirm Delete",
        content: "Are you sure you want to delete this pose? This action cannot be undone.",
        confirmText: "Delete",
        cancelText: "Cancel",
      ),
    );

    if (confirmed != true) return;

    final state = context.read<AuthCubit>().state;
    if (state is! AuthLoggedIn) return;

    try {
      await context.read<PosesCubit>().deletePose(
        poseId: widget.pose.id,
        token: state.user.token,
      );
      if (mounted) {
        context.goNamed('pose-library');
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete pose")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    bool isOwner = state is AuthLoggedIn && widget.pose.createdBy == state.user.id;

    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text('Edit Pose'),
        actions: isOwner
            ? [IconButton(icon: const Icon(Icons.save), onPressed: _handleUpdatePose)]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isOwner)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "You are viewing a shared pose. You cannot edit this version.",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),

                ExpandableCard(
                  title: "Basic Info",
                  initiallyExpanded: true,
                  children: [
                    TextInputField("Pose Name", nameController, required: true, enabled: isOwner),
                    DropdownField("Apparatus", apparatusController, Constants.apparatusOptions, enabled: isOwner),
                    IntInputField("Level", levelController, enabled: isOwner),
                  ],
                ),

                ExpandableCard(
                  title: "Additional Details",
                  initiallyExpanded: false,
                  children: [
                    TextInputField("Alternative Name", altNameController, enabled: isOwner),
                    TextInputField("Description", descriptionController, maxLines: 2, enabled: isOwner),
                    DropdownField("Pose Type", poseTypeController, Constants.poseTypeOptions, enabled: isOwner),
                  ],
                ),

                ExpandableCard(
                  title: "Instructor Notes",
                  initiallyExpanded: false,
                  children: [
                    TextInputField("Teaching Cues", teachingCuesController, maxLines: 2, enabled: isOwner),
                    TextInputField("Safety Cues", safetyCuesController, maxLines: 2, enabled: isOwner),
                    TextInputField("Progressions", progressionsController, maxLines: 2, enabled: isOwner),
                    TextInputField("Modifications", modificationsController, maxLines: 2, enabled: isOwner),
                    TextInputField("Common Errors", commonErrorsController, maxLines: 2, enabled: isOwner),
                  ],
                ),

                ExpandableCard(
                  title: "Advanced Tagging",
                  initiallyExpanded: false,
                  children: [
                    TextInputField("Base Name", baseNameController, enabled: isOwner),
                    TextInputField("Prefix", prefixController, enabled: isOwner),
                    TextInputField("Suffix", suffixController, enabled: isOwner),
                    TextInputField("Hand Position", handPositionController, enabled: isOwner),
                    TextInputField("Leg Position", legPositionController, enabled: isOwner),
                    TextInputField("Position in Bar", positionInBarController, enabled: isOwner),
                  ],
                ),

                const SizedBox(height: 24),

                if (isOwner)
                  ElevatedButton(
                    onPressed: _handleUpdatePose,
                    child: const Text("Save Changes", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _handleDeletePose,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red.shade200),
                    ),
                    child: const Text(
                      "Delete Pose",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
