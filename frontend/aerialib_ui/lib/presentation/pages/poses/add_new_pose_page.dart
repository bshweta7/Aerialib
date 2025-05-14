import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';


class AddNewPosePage extends StatefulWidget {
  const AddNewPosePage({super.key});

  @override
  State<AddNewPosePage> createState() => _AddNewPosePageState();
}

class _AddNewPosePageState extends State<AddNewPosePage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController teachingCuesController = TextEditingController();
  TextEditingController safetyCuesController = TextEditingController();
  TextEditingController progressionsController = TextEditingController();
  TextEditingController apparatusController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  void createNewPose() async {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      final level = double.tryParse(levelController.text.trim());

      if (level != null) {
        await context.read<PosesCubit>().createNewPose(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          teachingCues: teachingCuesController.text.trim(),
          safetyCues: safetyCuesController.text.trim(),
          progressions: progressionsController.text.trim(),
          apparatus: apparatusController.text.trim(),
          level: level,
          primaryMediaId: Constants.missingImageId,
          primaryMediaPath: Constants.missingImagePath,
          token: user.user.token,
          createdBy: user.user.id,
          // TODO add upload image portion on create new pose page
          // TODO OR allow image selection
          // TODO this should be default to exclamation point
        );
      }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        currentIndex: 2,
        appBar: AppBar(title: const Text("Add New Pose")),
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
              // TODO update this to go back to pose-specific page instead, and make sure that add new pose page was not added to the nav stack
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
                      const SizedBox(height: 10),
                      _dropdownField(
                        label: "Apparatus",
                        controller: apparatusController,
                        options: Constants.apparatusOptions,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: levelController,
                        decoration: const InputDecoration(labelText: 'Level'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Level can’t be empty';
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null) return 'Please enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _inputField("Description", descriptionController, maxLines: 2),
                      const SizedBox(height: 10),
                      _inputField("Teaching Cues", teachingCuesController, maxLines: 2),
                      const SizedBox(height: 10),
                      _inputField("Safety Cues", safetyCuesController, maxLines: 2),
                      const SizedBox(height: 10),
                      _inputField("Progressions", progressionsController, maxLines: 2),
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
          value: lowerValue, // lowercase value stored in controller
          child: Text(displayLabel),
        );
      }).toList(),
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select $label' : null,
    );
  }
}
