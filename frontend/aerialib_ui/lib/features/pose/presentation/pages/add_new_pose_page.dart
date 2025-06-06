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
      baseNameController.text.isNotEmpty ? baseNameController.text : nameController.text,
      suffixController.text,
      handPositionController.text,
      legPositionController.text,
      positionInBarController.text,
    ];

    final slug = parts
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.trim().toLowerCase())
        .join('-');

    setState(() {
      generatedSlug = slug;
    });
  }

  void createNewPose() async {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      final level = int.tryParse(levelController.text.trim());
      final now = DateTime.now();

      final newPose = PoseEntity(
        id: const Uuid().v6(),
        slug: '',
        displayName: nameController.text.trim(),
        altName: altNameController.text.trim().isNotEmpty ? altNameController.text.trim() : null,
        baseName: baseNameController.text.trim().isNotEmpty
            ? baseNameController.text.trim().toLowerCase()
            : nameController.text.trim().toLowerCase(),
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
        primaryMediaId: Constants.missingImageId, // TODO this should be a nicer image than the broken one... it should be a placeholder image
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

                    /// Basic Info
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text(
                        "Basic Info",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      children: [
                        const SizedBox(height: 5),

                        // Name
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Pose Name",
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Pose Name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Apparatus
                        _dropdownField(
                          label: "Apparatus",
                          controller: apparatusController,
                          options: Constants.apparatusOptions,
                        ),
                        const SizedBox(height: 10),


                        // Level
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
                        const SizedBox(height:10),
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
                        const SizedBox(height: 5),

                        // const Text( // TODO replace these "subtitles" with info buttons that show info when hover for each entry field.
                        //   "Optional details",
                        //   style: TextStyle(fontSize: 14),
                        // ),

                        // Alternate Name
                        TextFormField(
                          controller: altNameController,
                          decoration: const InputDecoration(labelText: "Alternate Name"),
                        ),
                        const SizedBox(height: 10),

                        // Description
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: "Description"),
                        ),
                        const SizedBox(height: 10),

                        // Pose Type
                        _dropdownField(
                          label: "Pose Type",
                          controller: poseTypeController,
                          options: ["static", "dynamic"],
                        ),
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
                        const SizedBox(height: 5),

                        // Teaching Cues
                        TextFormField(
                          controller: teachingCuesController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: "Teaching Cues"),
                        ),
                        const SizedBox(height: 10),

                        // Safety Cues
                        TextFormField(
                          controller: safetyCuesController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: "Safety Cues"),
                        ),
                        const SizedBox(height: 10),

                        // Progressions
                        TextFormField(
                          controller: progressionsController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: "Progressions"),
                        ),
                        const SizedBox(height: 10),

                        // Modifications
                        TextFormField(
                          controller: modificationsController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: "Modifications"),
                        ),
                        const SizedBox(height: 10),

                        // Common Errors
                        TextFormField(
                          controller: commonErrorsController,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: "Common Errors"),
                        ),
                        const SizedBox(height: 10),
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

                        const SizedBox(height: 10),

                        // Base Name
                        TextFormField(
                          controller: baseNameController,
                          decoration: const InputDecoration(labelText: "Base Name"),
                        ),
                        const SizedBox(height: 10),

                        // Prefix
                        TextFormField(
                          controller: prefixController,
                          decoration: const InputDecoration(labelText: "Prefix"),
                        ),
                        const SizedBox(height: 10),

                        // Suffix
                        TextFormField(
                          controller: suffixController,
                          decoration: const InputDecoration(labelText: "Suffix"),
                        ),
                        const SizedBox(height: 10),

                        // Hand Position
                        TextFormField(
                          controller: handPositionController,
                          decoration: const InputDecoration(labelText: "Hand Position"),
                        ),
                        const SizedBox(height: 10),

                        // Leg Position
                        TextFormField(
                          controller: legPositionController,
                          decoration: const InputDecoration(labelText: "Leg Position"),
                        ),
                        const SizedBox(height: 10),

                        // Position in Bar
                        TextFormField(
                          controller: positionInBarController,
                          decoration: const InputDecoration(labelText: "Position in Bar"),
                        ),
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
  Widget _inputField(String label, TextEditingController controller,
      {int maxLines = 1, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: label),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
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
