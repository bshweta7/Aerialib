import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_poses_page.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';

import '../../../core/utils/validators.dart';

class AddNewFlowPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
    builder: (context) => const AddNewFlowPage(),
  );
  const AddNewFlowPage({super.key});

  @override
  State<AddNewFlowPage> createState() => _AddNewFlowPageState();
}

class _AddNewFlowPageState extends State<AddNewFlowPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController teachingCuesController = TextEditingController();
  TextEditingController safetyCuesController = TextEditingController();
  TextEditingController progressionsController = TextEditingController();
  TextEditingController apparatusController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void createNewFlow() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      double? level = double.tryParse(levelController.text.trim());

      if (level != null) {
        await context.read<FlowsCubit>().createNewFlow(
          name: nameController.text.trim(),
          apparatus: apparatusController.text.trim(),
          description: descriptionController.text.trim(),
          teachingCues: teachingCuesController.text.trim(),
          safetyCues: safetyCuesController.text.trim(),
          progressions: progressionsController.text.trim(),
          level: level,
          token: user.user.token,
          createdBy: user.user.id,
          thumbnailImageId: Constants.missingImageId,
          thumbnailImagePath: Constants.missingImagePath,
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
    return Scaffold(
        appBar: AppBar(
            title: const Text("Create Flow Details"),
        ),
        body: BlocConsumer<FlowsCubit, FlowsState>(
          listener: (context, state) {
            if (state is FlowError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("There was an error adding the flow")
                )
                // SnackBar(content: Text(state.error))
              );
            } else if (state is AddNewFlowSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved flow information"))
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => FlowEditPage(flow: state.flow),
                    builder: (context) => FlowEditPosesPage(flow: state.flow),
                  ),
                  // FlowEditPage(flow: state.flow).route(),
                  //     (_) => false
                  // TODO should this go to flow specific FlowViewPage instead?
              );
            }
          },
          builder: (context, state) {
            if(state is FlowLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column( // TODO expanded widget here???
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
                        value: apparatusController.text.isNotEmpty ? apparatusController.text : null,
                        onChanged: (value) => setState(() => apparatusController.text = value ?? ''),
                        items: Constants.apparatusOptions
                            .map((value) => DropdownMenuItem(value: value, child: Text(value)))
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
                          final parsed = double.tryParse(value);
                          if (parsed == null) return 'Please enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Description
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),

                      // Teaching Cues
                      TextFormField(
                        controller: teachingCuesController,
                        decoration: const InputDecoration(labelText: 'Teaching Cues'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),

                      // Safety Cues
                      TextFormField(
                        controller: safetyCuesController,
                        decoration: const InputDecoration(labelText: 'Safety Cues'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),

                      // Progressions
                      TextFormField(
                        controller: progressionsController,
                        decoration: const InputDecoration(labelText: 'Progressions'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      ElevatedButton(
                        onPressed: createNewFlow,
                        child: const Text(
                        "Add Poses",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            );
          },
        )
    );
  }
}
