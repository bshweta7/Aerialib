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
  TextEditingController cuesController = TextEditingController();
  TextEditingController apparatusController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  // TextEditingController thumbnailURLController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void createNewFlow() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context
          .read<AuthCubit>()
          .state as AuthLoggedIn;
      int? level = int.tryParse(
          levelController.text.trim()); // Parse level to int

      if (level != null) { // Check if level is a valid integer
        await context.read<FlowsCubit>().createNewFlow(
          name: nameController.text.trim(),
          apparatus: apparatusController.text.trim(),
          description: descriptionController.text.trim(),
          // TODO add upload image portion on create new flow page
          // TODO OR allow image selection
          // TODO this should be default to exclamation point
          token: user.user.token,
          createdBy: user.user.id,
          level: 1, // TODO use level Controller.
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
    // TODO add other controllers here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add New Flow"),
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
                    builder: (context) => EditFlowPage(flow: state.flow),
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
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column( // TODO expanded widget here???
                    children: [
                      // Name Textbox
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Flow Name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10,),

                      // Apparatus Dropdown
                      DropdownButtonFormField<String>(
                        value: apparatusController.text.isNotEmpty ? apparatusController.text : null,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            apparatusController.text = newValue;
                          }
                        },
                        items: <String>['Lyra', 'Hammock']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Apparatus',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an apparatus';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Level Dropdown
                      DropdownButtonFormField<int>(
                        value: levelController.text.isNotEmpty ? int.tryParse(levelController.text) : null,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            levelController.text = newValue.toString();
                          }
                        },
                        items: <int>[0, 1, 2, 3, 4,]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Level',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a level';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Description Textbox
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10,),

                      // Cues Textbox
                      TextFormField(
                        controller: cuesController,
                        decoration: const InputDecoration(
                          hintText: 'Cues',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10,),


                      const SizedBox(height: 10,),
                      ElevatedButton(
                          onPressed: createNewFlow,
                          // TODO change formatting to make clear that this is page one and add poses on next page
                          child: const Text(
                              "Add Poses",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal
                              )
                          )
                      ),
                    ]
                ),
              ),
            );
          },
        )
    );
  }
}
