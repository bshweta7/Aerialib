import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/validators.dart';
import 'flow_view_page.dart';

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
  late TextEditingController apparatusController;
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
    apparatusController = TextEditingController(text: widget.flow.apparatus.toLowerCase());
    level = widget.flow.level;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    apparatusController.dispose(); // ✅ added
    super.dispose();
  }

  Future<void> _saveFlow() async {
    if (!formKey.currentState!.validate()) return;

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedFlow = widget.flow.copyWith(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      teachingCues: teachingCuesController.text.trim(),
      safetyCues: safetyCuesController.text.trim(),
      progressions: progressionsController.text.trim(),
      apparatus: apparatusController.text.trim(),
      level: level,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<FlowsCubit>().saveFlowDetails(
      updatedFlow: updatedFlow,
      token: user.user.token,
    );

    await context.read<FlowsCubit>().getAllFlows(token: user.user.token);

    // Navigator.pop(context); // Pop Edit
    // Navigator.pop(context); // Pop Details
    context.goNamed(
      'flow-view',
      pathParameters: {
        'flowId': updatedFlow.id,
      },
      extra: updatedFlow,
    );
    // Navigator.push(context, FlowViewPage.route(updatedFlow)); // Push fresh
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Flow'),
        actions: [
          BlocBuilder<FlowsCubit, FlowsState>(
            builder: (context, state) {
              if (state is EditFlowState && state.isSaving) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                );
              }
              // print(state);
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveFlow,
              );
            },
          ),
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
                  decoration: const InputDecoration(labelText: 'Flow Name'),
                  validator: requiredFieldValidator,
                ),
                const SizedBox(height: 10),

                _dropdownField(
                  label: "Apparatus",
                  controller: apparatusController,
                  options: Constants.apparatusOptions,
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
                  validator: requiredFieldValidator,
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
                  onPressed: _saveFlow,
                  child: const Text('Update Flow'),
                ),
              ],
            ),
          ),
        ),
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