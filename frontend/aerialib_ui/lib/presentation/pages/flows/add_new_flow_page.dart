import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/core/utils/formatters.dart';

import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_poses_page.dart';

class AddNewFlowPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
    builder: (context) => const AddNewFlowPage(),
  );
  const AddNewFlowPage({super.key});

  @override
  State<AddNewFlowPage> createState() => _AddNewFlowPageState();
}

class _AddNewFlowPageState extends State<AddNewFlowPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final teachingCuesController = TextEditingController();
  final safetyCuesController = TextEditingController();
  final progressionsController = TextEditingController();
  final apparatusController = TextEditingController();
  final levelController = TextEditingController();

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

  Future<void> _onAddFlowPressed() async {
    // if (!formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthLoggedIn) return;

    final token = authState.user.token;
    final userId = authState.user.id;
    final level = double.tryParse(levelController.text.trim());

    if (level == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid level")),
      );
      return;
    }

    final state = await context.read<FlowsCubit>().createNewFlow(
      name: nameController.text.trim(),
      apparatus: apparatusController.text.trim(),
      description: descriptionController.text.trim(),
      teachingCues: teachingCuesController.text.trim(),
      safetyCues: safetyCuesController.text.trim(),
      progressions: progressionsController.text.trim(),
      level: level,
      token: token,
      createdBy: userId,
      thumbnailImageId: Constants.missingImageId,
      thumbnailImagePath: Constants.missingImagePath,
    );

    if (state is AddNewFlowSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved flow information")),
      );
      Navigator.push(context, FlowEditPosesPage.route(state.flow));
    } else if (state is FlowError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${state.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Flow Details")),
      body: BlocBuilder<FlowsCubit, FlowsState>(
        builder: (context, state) {
          if (state is FlowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // Name
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Flow Name'),
                      validator: requiredFieldValidator,
                    ),
                    const SizedBox(height: 10),

                    // Apparatus
                    DropdownButtonFormField<String>(
                      value: apparatusController.text.isNotEmpty
                          ? apparatusController.text
                          : null,
                      onChanged: (value) =>
                          setState(() => apparatusController.text = value ?? ''),
                      items: Constants.apparatusOptions
                          .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(capitalizeFirstLetter(value))))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Apparatus'),
                      validator: requiredFieldValidator,
                    ),
                    const SizedBox(height: 10),

                    // Level
                    TextFormField(
                      controller: levelController,
                      decoration: const InputDecoration(labelText: 'Level'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field cannot be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
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
                      onPressed: _onAddFlowPressed,
                      child: const Text("Add Poses"),
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
