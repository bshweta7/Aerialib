import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/validators.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/input_fields/dropdown_field.dart';
import '../../../../shared/widgets/input_fields/int_input_field.dart';
import '../../../../shared/widgets/input_fields/text_input_field.dart';

class FlowEditDetailsPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowEditDetailsPage({super.key, required this.flow});

  @override
  State<FlowEditDetailsPage> createState() => _FlowEditDetailsPageState();
}

class _FlowEditDetailsPageState extends State<FlowEditDetailsPage> {
  final formKey = GlobalKey<FormState>();
  
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController teachingCuesController;
  late TextEditingController safetyCuesController;
  late TextEditingController progressionsController;
  late TextEditingController modificationsController;
  late TextEditingController commonErrorsController;

  late TextEditingController levelController;
  late TextEditingController apparatusController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.flow.name);
    descriptionController = TextEditingController(text: widget.flow.description);
    teachingCuesController = TextEditingController(text: widget.flow.teachingCues);
    safetyCuesController = TextEditingController(text: widget.flow.safetyCues);
    progressionsController = TextEditingController(text: widget.flow.progressions);
    modificationsController = TextEditingController(text: widget.flow.modifications);
    commonErrorsController = TextEditingController(text: widget.flow.commonErrors);

    levelController = TextEditingController(
        text: widget.flow.level != null ? widget.flow.level.toString() : '');
    apparatusController = TextEditingController(text: widget.flow.apparatus);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    modificationsController.dispose();
    commonErrorsController.dispose();

    levelController.dispose();
    apparatusController.dispose();
    super.dispose();
  }

  Future<void> _handleFlowUpdate() async {
    if (!formKey.currentState!.validate()) return;

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedFlow = widget.flow.copyWith(
      name: nameController.text.trim(),
      apparatus: apparatusController.text.trim(),
      level: int.tryParse(levelController.text.trim()),
      description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
      teachingCues: teachingCuesController.text.trim().isNotEmpty ? teachingCuesController.text.trim() : null,
      safetyCues: safetyCuesController.text.trim().isNotEmpty ? safetyCuesController.text.trim() : null,
      progressions: progressionsController.text.trim().isNotEmpty ? progressionsController.text.trim() : null,
      modifications: modificationsController.text.trim().isNotEmpty ? modificationsController.text.trim() : null,
      commonErrors: commonErrorsController.text.trim().isNotEmpty ? commonErrorsController.text.trim() : null,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<FlowsCubit>().saveFlowDetails(
      updatedFlow: updatedFlow,
      token: user.user.token,
    );

    await context.read<FlowsCubit>().getAllFlows(token: user.user.token);

    context.replaceNamed(
      'flow-view',
      pathParameters: {'flowId': updatedFlow.id},
      // queryParameters: {'from': 'flow-edit-details'},
    );
  }

  Future<void> _handleDeleteFlow() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: "Confirm Delete",
        content: "Are you sure you want to delete this flow? This action cannot be undone.",
        confirmText: "Delete",
        cancelText: "Cancel",
      ),
    );

    if (confirmed != true) return;

    final state = context.read<AuthCubit>().state;
    if (state is! AuthLoggedIn) return;

    try {
      await context.read<FlowsCubit>().deleteFlow(
        flowId: widget.flow.id,
        token: state.user.token,
      );
      if (mounted) {
        context.goNamed('flow-library');
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete flow")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    bool isOwner = state is AuthLoggedIn && widget.flow.createdBy == state.user.id;

    return MainScaffold(
      currentIndex: 1,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text('Edit Flow'),
        actions: isOwner
            ? [IconButton(icon: const Icon(Icons.save), onPressed: _handleFlowUpdate)]
            : null,
        // actions: [
        //   PopupMenuButton<String>(
        //     onSelected: (value) {
        //       if (value == 'delete') _confirmDeleteFlow();
        //     },
        //     itemBuilder: (context) => [
        //       const PopupMenuItem(
        //         value: 'delete',
        //         child: Text('Delete Flow'),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isOwner)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "You are viewing a shared flow. You cannot edit this version.",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),

                // TODO edit image

                ExpandableCard(
                  title: "Basic Info",
                  initiallyExpanded: true,
                  children: [
                    TextInputField("Flow Name", nameController, required: true, enabled: isOwner),
                    DropdownField("Apparatus", apparatusController, Constants.apparatusOptions, enabled: isOwner),
                    IntInputField("Level", levelController, enabled: isOwner),
                    TextInputField("Description", descriptionController, maxLines: 2, enabled: isOwner),
                  ],
                ),

                ExpandableCard(
                  title: "Instructor Notes",
                  initiallyExpanded: false,
                  children: [
                    TextInputField("Teaching Cues", teachingCuesController, maxLines: 2, enabled: isOwner),
                    TextInputField("Safety Cues", safetyCuesController, maxLines: 2, enabled: isOwner),
                    TextInputField("Progressions", progressionsController, maxLines: 2, enabled: isOwner),
                    TextInputField("Modifications", modificationsController, maxLines: 2, enabled: isOwner),
                    TextInputField("Common Errors", commonErrorsController, maxLines: 2, enabled: isOwner),
                  ],
                ),

                const SizedBox(height: 24),

                if (isOwner)
                  ElevatedButton(
                      onPressed: _handleFlowUpdate,
                      child: Text(
                          "Save Changes",
                          style: Theme.of(context).textTheme.labelMedium
                      )
                  ),
                const SizedBox(height: 10),
                if (isOwner)
                  ElevatedButton(
                    onPressed: _handleDeleteFlow,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red.shade300),
                      foregroundColor: MaterialStateProperty.all(Colors.red.shade900),
                    ),
                    child: Text(
                        "Delete Flow",
                        style: Theme.of(context).textTheme.labelMedium
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


