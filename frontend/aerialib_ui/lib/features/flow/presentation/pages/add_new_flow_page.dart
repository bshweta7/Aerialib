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
import 'package:uuid/uuid.dart';

import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/input_fields/dropdown_field.dart';
import '../../../../shared/widgets/input_fields/int_input_field.dart';
import '../../../../shared/widgets/input_fields/text_input_field.dart';


class AddNewFlowPage extends StatefulWidget {
  const AddNewFlowPage({super.key});

  @override
  State<AddNewFlowPage> createState() => _AddNewFlowPageState();
}

class _AddNewFlowPageState extends State<AddNewFlowPage> {
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

  List<FlowEntity> userFlows = [];

  @override
  void initState() {
    super.initState();
    apparatusController.text = 'lyra';

    // final authState = context.read<AuthCubit>().state;
    // final flowsState = context.read<FlowsCubit>().state;
    //
    // if (authState is AuthLoggedIn && flowsState is GetFlowsSuccess) {
    //   final userId = authState.user.id;
    //   userFlows = flowsState.flows
    //       .where((flow) => flow.createdBy == userId)
    //       .toList();
    // }
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
    super.dispose();
  }

  Future<void> createNewFlow() async {
    if (formKey.currentState!.validate()) {
      final user = context
          .read<AuthCubit>()
          .state as AuthLoggedIn;
      final now = DateTime.now();

      final levelText = levelController.text.trim();
      final level = int.tryParse(levelText) ?? -1;

      final newFlow = FlowEntity(
        id: const Uuid().v4(),
        name: nameController.text.trim(),
        apparatus: apparatusController.text.trim(),
        level: level,
        flowPoses: [],

        description: descriptionController.text
            .trim()
            .isNotEmpty ?
        descriptionController.text.trim() : null,
        teachingCues: teachingCuesController.text
            .trim()
            .isNotEmpty ?
        teachingCuesController.text.trim() : null,
        safetyCues: safetyCuesController.text
            .trim()
            .isNotEmpty ?
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
        primaryMediaPath: Constants.missingImagePath,

        createdBy: user.user.uid,
        updatedBy: user.user.uid,
        createdAt: now,
        updatedAt: now,
        isSynced: 0,
      );

      await context.read<FlowsCubit>().createNewFlow(
        flow: newFlow,
        token: user.user.token,
      );

      context.goNamed(
        'flow-edit-poses',
        pathParameters: {'flowId': newFlow.id,},
        // queryParameters: {'from': 'add-new-flow'},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      appBar: AppBar(
          leading: const SmartBackButton(),
          title: const Text("Create New Flow")
      ),
      body: BlocConsumer<FlowsCubit, FlowsState>(
        listener: (context, state) {
          if (state is FlowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("There was an error adding the flow")),
            );
          } else if (state is AddNewFlowSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Flow added successfully")),
            );
            context.goNamed('flow-library');
          }
        },
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    /// Basic Info
                    ExpandableCard(
                      title: "Basic Info",
                      initiallyExpanded: true,
                      children: [
                        TextInputField(
                          "Flow Name",
                          nameController,
                          required: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This field is required';
                            }

                            final flowName = value.trim().toLowerCase();
                            final nameTaken = userFlows.any(
                                  (f) => f.name.trim().toLowerCase() == flowName,
                            );

                            if (nameTaken) {
                              return 'You already have a flow with this name';
                            }

                            return null;
                          },
                        ),

                        DropdownField("Apparatus", apparatusController,
                            Constants.apparatusOptions),
                        IntInputField("Level", levelController,),
                        TextInputField(
                            "Description", descriptionController, maxLines: 2),
                        const SizedBox(height: 10),
                      ],
                    ),

                    /// Instructor Notes
                    ExpandableCard(
                      title: "Instructor Notes",
                      initiallyExpanded: false,
                      children: [
                        TextInputField("Teaching Cues", teachingCuesController,
                            maxLines: 2),
                        TextInputField(
                            "Safety Cues", safetyCuesController, maxLines: 2),
                        TextInputField("Progressions", progressionsController,
                            maxLines: 2),
                        TextInputField("Modifications", modificationsController,
                            maxLines: 2),
                        TextInputField("Common Errors", commonErrorsController,
                            maxLines: 2),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: createNewFlow,
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
