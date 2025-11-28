import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/widgets/info_display/info_row.dart';
import '../../../../shared/widgets/input_fields/dropdown_field.dart';
import '../../../../shared/widgets/input_fields/int_input_field.dart';
import '../../../../shared/widgets/input_fields/text_input_field.dart';
import '../../domain/entities/pose_entity.dart';

class AddNewPosePage extends StatefulWidget {
  const AddNewPosePage({super.key});

  @override
  State<AddNewPosePage> createState() => _AddNewPosePageState();
}

class _AddNewPosePageState extends State<AddNewPosePage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final apparatusController = TextEditingController();
  final levelController = TextEditingController();

  final descriptionController = TextEditingController();
  final teachingCuesController = TextEditingController();
  final safetyCuesController = TextEditingController();
  final progressionsController = TextEditingController();
  final modificationsController = TextEditingController();
  final commonErrorsController = TextEditingController();

  final altNameController = TextEditingController();
  final baseNameController = TextEditingController();
  final prefixController = TextEditingController();
  final suffixController = TextEditingController();

  final handPositionController = TextEditingController();
  final legPositionController = TextEditingController();
  final positionInBarController = TextEditingController();
  final poseTypeController = TextEditingController();

  String generatedSlug = '';
  bool _baseNameManuallyEdited = false;

  @override
  void initState() {
    super.initState();
    apparatusController.text = 'lyra';

    // Watch for name changes to update base name
    nameController.addListener(() {
      if (!_baseNameManuallyEdited) {
        final nameText = nameController.text.trim();
        baseNameController.value = TextEditingValue(
          text: nameText,
          selection: TextSelection.collapsed(offset: nameText.length),
        );
      }
      generateSlug();
    });

    // TODO eventually, split the name by - to make prefix and suffix and use some word detection (like no hands) and remove that and add to hand position
    // Detect manual edits to base name
    baseNameController.addListener(() {
      _baseNameManuallyEdited = baseNameController.text.trim() != nameController.text.trim();
      generateSlug();
    });

    [
      prefixController,
      baseNameController,
      nameController,
      suffixController,
      handPositionController,
      legPositionController,
      positionInBarController,
    ].forEach((controller) => controller.addListener(generateSlug));

    generateSlug(); // initial value
  }

  void generateSlug() {
    final parts = [
      prefixController.text,
      baseNameController.text.isNotEmpty
          ? baseNameController.text
          : nameController.text,
      suffixController.text,
      handPositionController.text,
      legPositionController.text,
      positionInBarController.text,
    ];

    final slug = parts
        .where((part) =>
    part
        .trim()
        .isNotEmpty)
        .map((part) => part.trim().toLowerCase())
        .join('-');

    setState(() {
      generatedSlug = slug;
    });
  }

  void createNewPose() async {
    if (formKey.currentState!.validate()) {
      final user = context
          .read<AuthCubit>()
          .state as AuthLoggedIn;
      final level = int.tryParse(levelController.text.trim());
      final now = DateTime.now();

      final newPose = PoseEntity(
        id: const Uuid().v4(),
        slug: generatedSlug,
        displayName: nameController.text.trim(),
        altName: altNameController.text
            .trim()
            .isNotEmpty ? altNameController.text.trim() : null,
        baseName: baseNameController.text
            .trim()
            .isNotEmpty
            ? baseNameController.text.trim().toLowerCase()
            : nameController.text.trim().toLowerCase(),
        prefix: prefixController.text
            .trim()
            .isNotEmpty ? prefixController.text.trim() : null,
        suffix: suffixController.text
            .trim()
            .isNotEmpty ? suffixController.text.trim() : null,
        handPosition: handPositionController.text
            .trim()
            .isNotEmpty ? handPositionController.text.trim() : null,
        legPosition: legPositionController.text
            .trim()
            .isNotEmpty ? legPositionController.text.trim() : null,
        positionInBar: positionInBarController.text
            .trim()
            .isNotEmpty ? positionInBarController.text.trim() : null,
        apparatus: apparatusController.text.trim(),
        level: level,
        poseType: poseTypeController.text.trim().isNotEmpty ?
            poseTypeController.text.trim() : null,
        description: descriptionController.text.trim().isNotEmpty ?
            descriptionController.text.trim() : null,
        teachingCues: teachingCuesController.text.trim().isNotEmpty ?
            teachingCuesController.text.trim() : null,
        safetyCues: safetyCuesController.text.trim().isNotEmpty ?
            safetyCuesController.text.trim() : null,
        progressions: progressionsController.text
            .trim()
            .isNotEmpty ? progressionsController.text.trim() : null,
        modifications: modificationsController.text
            .trim()
            .isNotEmpty ? modificationsController.text.trim() : null,
        commonErrors: commonErrorsController.text
            .trim()
            .isNotEmpty ? commonErrorsController.text.trim() : null,
        primaryMediaId: Constants.missingImageId,
        // TODO this should be a nicer image than the broken one... it should be a placeholder image
        primaryMediaPath: Constants.missingImagePath,
        createdBy: user.user.uid,
        updatedBy: user.user.uid,
        createdAt: now,
        updatedAt: now,
        isSynced: 0,
      );

      await context.read<PosesCubit>().createNewPose(
        pose: newPose,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    apparatusController.dispose();
    levelController.dispose();

    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    modificationsController.dispose();
    commonErrorsController.dispose();

    baseNameController.dispose();
    prefixController.dispose();
    suffixController.dispose();
    handPositionController.dispose();
    legPositionController.dispose();
    positionInBarController.dispose();

    altNameController.dispose();
    descriptionController.dispose();
    poseTypeController.dispose();

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
              const SnackBar(
                  content: Text("There was an error adding the pose")),
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

                    /// Basic Info
                    ExpandableCard(
                      title: "Basic Info",
                      initiallyExpanded: true,
                      children: [
                        TextInputField("Pose Name", nameController, required: true),
                        DropdownField("Apparatus", apparatusController, Constants.apparatusOptions),
                        IntInputField("Level", levelController,),
                        const SizedBox(height: 10),
                      ],
                    ),

                    /// Additional Details
                    ExpandableCard(
                      title: "Additional Details",
                      initiallyExpanded: false,
                      children: [
                        TextInputField("Alternative Name", altNameController),
                        TextInputField("Description", descriptionController, maxLines: 2),
                        DropdownField("Pose Type", poseTypeController, Constants.poseTypeOptions),
                      ],
                    ),

                    /// Instructor Notes
                    ExpandableCard(
                      title: "Instructor Notes",
                      initiallyExpanded: false,
                      children: [
                        TextInputField("Teaching Cues", teachingCuesController, maxLines: 2),
                        TextInputField("Safety Cues", safetyCuesController, maxLines: 2),
                        TextInputField("Progressions", progressionsController, maxLines: 2),
                        TextInputField("Modifications", modificationsController, maxLines: 2),
                        TextInputField("Common Errors", commonErrorsController, maxLines: 2),
                      ],
                    ),

                    /// Advanced Tagging
                    // TODO Button for advanced features that opens a new screen that shows this card and lets you add transitions
                    ExpandableCard(
                      title: "Advanced Tagging",
                      initiallyExpanded: false,
                      children: [
                        InfoRow("Generated Slug: ", generatedSlug, valueColor: Colors.grey,),

                        TextInputField("Base Name", baseNameController),
                        TextInputField("Prefix", prefixController),
                        TextInputField("Suffix", suffixController),
                        TextInputField("Hand Position", handPositionController),
                        TextInputField("Leg Position", legPositionController),
                        TextInputField("Position in Bar", positionInBarController),
                      ],
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: createNewPose,
                      child: Text(
                        "Submit",
                        style: Theme.of(context).textTheme.labelMedium,
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
}
