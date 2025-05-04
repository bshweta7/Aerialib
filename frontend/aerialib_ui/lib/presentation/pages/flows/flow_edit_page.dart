import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';

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

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late double level;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.flow.name);
    descriptionController = TextEditingController(text: widget.flow.description);
    level = widget.flow.level ?? 0;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateFlow() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedFlow = widget.flow.copyWith(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
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

    Navigator.pushAndRemoveUntil(
      context,
      FlowLibraryPage.route(),
          (route) => true,
      // TODO change this to false so it clears the entire navigation stack
      // TODO need to make bottom bar for navigation
    );
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
                  validator: (value) =>
                  value == null || value.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
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
