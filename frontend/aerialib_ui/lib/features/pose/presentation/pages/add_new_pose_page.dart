import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/pose_entity.dart';

class AddNewPosePage extends StatefulWidget {
  const AddNewPosePage({super.key});

  @override
  State<AddNewPosePage> createState() => _AddNewPosePageState();
}

class _AddNewPosePageState extends State<AddNewPosePage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final teachingCuesController = TextEditingController();
  final safetyCuesController = TextEditingController();
  final progressionsController = TextEditingController();
  final apparatusController = TextEditingController();
  final levelController = TextEditingController();
  final altNameController = TextEditingController();
  final baseNameController = TextEditingController();
  final prefixController = TextEditingController();
  final suffixController = TextEditingController();
  final handPositionController = TextEditingController();
  final legPositionController = TextEditingController();
  final positionInBarController = TextEditingController();
  final poseTypeController = TextEditingController();
  final modificationsController = TextEditingController();
  final commonErrorsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apparatusController.text = 'lyra';
  }

  void createNewPose() async {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      final level = int.tryParse(levelController.text.trim());

      final now = DateTime.now();

      final newPose = PoseEntity(
        id: const Uuid().v6(),
        slug: '', // TODO auto generate slug here
        displayName: nameController.text.trim(),
        altName: altNameController.text.trim().isNotEmpty ? altNameController.text.trim() : null,
        baseName: baseNameController.text.trim().isNotEmpty
            ? baseNameController.text.trim().toLowerCase()
            : nameController.text.trim().toLowerCase(), // TODO maybe replace spaces with - here?
        prefix: prefixController.text.trim().isNotEmpty ? prefixController.text.trim() : null,
        suffix: suffixController.text.trim().isNotEmpty ? suffixController.text.trim() : null,
        handPosition: handPositionController.text.trim().isNotEmpty ? handPositionController.text.trim() : null,
        legPosition: legPositionController.text.trim().isNotEmpty ? legPositionController.text.trim() : null,
        positionInBar: positionInBarController.text.trim().isNotEmpty ? positionInBarController.text.trim() : null,
        apparatus: apparatusController.text.trim(),
        level: level,
        poseType: poseTypeController.text.trim().isNotEmpty ? poseTypeController.text.trim() : null,
        description: descriptionController.text.trim(),
        teachingCues: teachingCuesController.text.trim(),
        safetyCues: safetyCuesController.text.trim(),
        progressions: progressionsController.text.trim(),
        modifications: modificationsController.text.trim().isNotEmpty ? modificationsController.text.trim() : null,
        commonErrors: commonErrorsController.text.trim().isNotEmpty ? commonErrorsController.text.trim() : null,
        primaryMediaId: Constants.missingImageId,
        primaryMediaPath: Constants.missingImagePath,
        thumbnailMediaId: Constants.missingImageId,
        thumbnailMediaPath: Constants.missingImagePath,
        createdBy: user.user.id,
        updatedBy: user.user.id,
        createdAt: now,
        updatedAt: now,
        isSynced: 0,
      );

      await context.read<PosesCubit>().createNewPose(
        pose: newPose,
        token: user.user.token,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    apparatusController.dispose();
    levelController.dispose();
    altNameController.dispose();
    baseNameController.dispose();
    prefixController.dispose();
    suffixController.dispose();
    handPositionController.dispose();
    legPositionController.dispose();
    positionInBarController.dispose();
    poseTypeController.dispose();
    modificationsController.dispose();
    commonErrorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Add New Pose"),
      ),
      body: BlocConsumer<PosesCubit, PosesState>(
        listener: (context, state) {
          if (state is PoseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("There was an error adding the pose")),
            );
          } else if (state is AddNewPoseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pose added successfully")),
            );
            context.goNamed('pose-library');
          }
        },
        builder: (context, state) {
          if (state is PoseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _inputField("Pose Name", nameController, required: true),
                    _inputField("Alternative Name", altNameController),
                    _inputField("Base Name", baseNameController),
                    // TODO add a text line that autogenerates the slug on the fly and shows it
                    // TODO make a drop down for advanced settings
                    _inputField("Prefix", prefixController),
                    _inputField("Suffix", suffixController),
                    _inputField("Hand Position", handPositionController),
                    _inputField("Leg Position", legPositionController),
                    _inputField("Position in Bar", positionInBarController),
                    _dropdownField(
                      label: "Apparatus",
                      controller: apparatusController,
                      options: Constants.apparatusOptions,
                    ),
                    _inputField("Pose Type", poseTypeController),
                    TextFormField(
                      controller: levelController,
                      decoration: const InputDecoration(labelText: 'Level'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final parsed = int.tryParse(value);
                          if (parsed == null) return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    _inputField("Description", descriptionController, maxLines: 2),
                    _inputField("Teaching Cues", teachingCuesController, maxLines: 2),
                    _inputField("Safety Cues", safetyCuesController, maxLines: 2),
                    _inputField("Progressions", progressionsController, maxLines: 2),
                    _inputField("Modifications", modificationsController, maxLines: 2),
                    _inputField("Common Errors", commonErrorsController, maxLines: 2),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: createNewPose,
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {int maxLines = 1, bool required = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(hintText: label),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }

  Widget _dropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isNotEmpty ? controller.text : null,
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.text = newValue;
        }
      },
      items: options.map((lowerValue) {
        final displayLabel = lowerValue[0].toUpperCase() + lowerValue.substring(1);
        return DropdownMenuItem(
          value: lowerValue,
          child: Text(displayLabel),
        );
      }).toList(),
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select $label' : null,
    );
  }
}
