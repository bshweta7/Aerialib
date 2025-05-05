import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';

import '../../../core/constants/constants.dart';
import 'flow_poses_page.dart';

class FlowEditDetailsPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowEditDetailsPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) => MaterialPageRoute(
    builder: (context) => FlowEditDetailsPage(flow: flow),
  );

  @override
  State<FlowEditDetailsPage> createState() => _FlowEditDetailsPageState();
}

class _FlowEditDetailsPageState extends State<FlowEditDetailsPage> {
  final formKey = GlobalKey<FormState>();
  late String? selectedApparatus;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController teachingCuesController;
  late TextEditingController safetyCuesController;
  late TextEditingController progressionsController;
  late double level;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.flow.name);
    descriptionController = TextEditingController(text: widget.flow.description);
    teachingCuesController = TextEditingController(text: widget.flow.teachingCues);
    safetyCuesController = TextEditingController(text: widget.flow.safetyCues);
    progressionsController = TextEditingController(text: widget.flow.progressions);
    level = widget.flow.level ?? 0;
    selectedApparatus = widget.flow.apparatus.isNotEmpty ? widget.flow.apparatus : null;

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

  Future<void> _handleUpdateFlow() async {
    if (!formKey.currentState!.validate()) return;

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedFlow = widget.flow.copyWith(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      teachingCues: teachingCuesController.text.trim(),
      safetyCues: safetyCuesController.text.trim(),
      progressions: progressionsController.text.trim(),
      apparatus: selectedApparatus ?? '',
      level: level,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<FlowsCubit>().updateFlowInfo(
      updatedFlow: updatedFlow,
      token: user.user.token,
    );

    await context.read<FlowsCubit>().getAllFlows(token: user.user.token);

    Navigator.pop(context); // Pop Edit
    Navigator.pop(context); // Pop Details
    Navigator.push(context, FlowPosesPage.route(updatedFlow)); // Push fresh
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Flow')),
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
                  decoration: const InputDecoration(labelText: 'Flow Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: selectedApparatus,
                  decoration: const InputDecoration(labelText: 'Apparatus'),
                  items: Constants.apparatusOptions
                      .map((apparatus) => DropdownMenuItem(
                    value: apparatus,
                    child: Text(apparatus),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedApparatus = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                TextFormField(
                  initialValue: level.toString(),
                  decoration: const InputDecoration(labelText: 'Level'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      level = double.tryParse(value) ?? level;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
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
                  onPressed: _handleUpdateFlow,
                  child: const Text('Update Flow'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}