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

import '../../../../shared/widgets/forms/dropdown_field.dart';
import '../../../../shared/widgets/forms/int_input_field.dart';
import '../../../../shared/widgets/forms/text_input_field.dart';
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

  String generatedSlug = '';

  @override
  void initState() {
    super.initState();
    apparatusController.text = 'lyra';


    // Add listeners to update slug
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
        id: const Uuid().v6(),
        slug: '',
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
        poseType: poseTypeController.text
            .trim()
            .isNotEmpty ? poseTypeController.text.trim() : null,
        description: descriptionController.text.trim(),
        teachingCues: teachingCuesController.text.trim(),
        safetyCues: safetyCuesController.text.trim(),
        progressions: progressionsController.text.trim(),
        modifications: modificationsController.text
            .trim()
            .isNotEmpty ? modificationsController.text.trim() : null,
        commonErrors: commonErrorsController.text
            .trim()
            .isNotEmpty ? commonErrorsController.text.trim() : null,
        primaryMediaId: Constants.missingImageId,
        // TODO this should be a nicer image than the broken one... it should be a placeholder image
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
                    ExpansionTile( // TODO make a custom expansion tile widget so the text style is consistent.
                      initiallyExpanded: true,
                      title: const Text(
                          "Basic Info",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      children: [
                        TextInputField("Pose Name", nameController, required: true),
                        DropdownField("Apparatus", apparatusController, Constants.apparatusOptions),
                        IntInputField("Level", levelController,),
                        const SizedBox(height: 10),
                      ],
                    ),

                    /// Additional Details
                    ExpansionTile(
                      title: const Text(
                          "Additional Details",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      initiallyExpanded: false,
                      children: [
                        // const Text( // TODO replace these "subtitles" with info buttons that show info when hover for each entry field.
                        //   "Optional details",
                        //   style: TextStyle(fontSize: 14),
                        // ),

                        TextInputField("Alternative Name", altNameController),
                        TextInputField("Description", descriptionController, maxLines: 2),
                        DropdownField("Pose Type", poseTypeController, Constants.poseTypeOptions),
                        const SizedBox(height: 10),
                      ],
                    ),

                    /// Instructor Notes
                    ExpansionTile(
                      title: const Text(
                          "Instructor Notes",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          )
                      ),
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
                    ExpansionTile(
                      title: const Text(
                          "Advanced Tagging",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      initiallyExpanded: false,
                      children: [
                        const SizedBox(height: 5),

// TODO make a widget for this or use the "info row" and wrap it in a center, and have a optional color manual override.
                        // Generated Slug
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Generated Slug: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: generatedSlug,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        TextInputField("Base Name", baseNameController),
                        TextInputField("Prefix", prefixController),
                        TextInputField("Suffix", suffixController),
                        TextInputField("Hand Position", handPositionController),
                        TextInputField("Leg Position", legPositionController),
                        TextInputField("Position in Bar", positionInBarController),
                        TextInputField("Pose Type", poseTypeController),
                        const SizedBox(height: 10),

                      ],
                    ),
                    ElevatedButton(
                      onPressed: createNewPose,
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 24),
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


  // TODO should have used this instead of the TextFormField - move this to a shared widget.

}
