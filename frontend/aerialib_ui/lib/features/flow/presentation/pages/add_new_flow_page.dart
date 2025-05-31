import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/validators.dart';
import 'package:frontend/shared/helpers/formatters.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';


class AddNewFlowPage extends StatefulWidget {
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

  List<FlowEntity> userFlows = [];

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;
    final flowsState = context.read<FlowsCubit>().state;

    if (authState is AuthLoggedIn && flowsState is GetFlowsSuccess) {
      final userId = authState.user.id;
      userFlows = flowsState.flows
          .where((flow) => flow.createdBy == userId)
          .toList();
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

  Future<void> _onAddFlowPressed() async {
    if (!formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthLoggedIn) return;

    final token = authState.user.token;
    final userId = authState.user.id;
    final flowName = nameController.text.trim();
    final level = double.tryParse(levelController.text.trim());

    if (level == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid level")),
      );
      return;
    }

    /// Proceed to create new flow
    final state = await context.read<FlowsCubit>().createNewFlow(
      name: flowName,
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

      // Emit the EditFlowState before navigating
      context.read<FlowsCubit>().startEditingFlow(state.flow);

      context.goNamed(
        'flow-edit-poses',
        pathParameters: {'flowId': state.flow.id,},
        // queryParameters: {'from': 'add-new-flow'},
      );
    } else if (state is FlowError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${state.message}")), // TODO remove errors in snack bar
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      appBar: AppBar(
          leading: const SmartBackButton(),
          title: const Text("Create New Flow - Details")
      ),
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
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Flow Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field cannot be empty';
                        }

                        final flowName = value.trim().toLowerCase();
                        final nameTaken = userFlows.any((f) =>
                        f.name.trim().toLowerCase() == flowName);

                        if (nameTaken) {
                          return 'You already have a flow with this name';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
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
                    TextFormField(
                      controller: levelController,
                      decoration: const InputDecoration(labelText: 'Level'),
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                      decoration:
                      const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: teachingCuesController,
                      decoration:
                      const InputDecoration(labelText: 'Teaching Cues'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: safetyCuesController,
                      decoration:
                      const InputDecoration(labelText: 'Safety Cues'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: progressionsController,
                      decoration:
                      const InputDecoration(labelText: 'Progressions'),
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
