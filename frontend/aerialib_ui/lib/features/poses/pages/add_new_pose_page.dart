import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/cubit/poses_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/features/poses/pages/pose_library_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';

class AddNewPosePage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
    builder: (context) => const AddNewPosePage(),
  );
  const AddNewPosePage({super.key});

  @override
  State<AddNewPosePage> createState() => _AddNewPosePageState();
}

class _AddNewPosePageState extends State<AddNewPosePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cuesController = TextEditingController();
  TextEditingController apparatusController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  // TextEditingController thumbnailURLController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void createNewPose() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context
          .read<AuthCubit>()
          .state as AuthLoggedIn;
      int? level = int.tryParse(
          levelController.text.trim()); // Parse level to int

      if (level != null) { // Check if level is a valid integer
        await context.read<PosesCubit>().createNewPose(
          name: nameController.text.trim(),
          apparatus: apparatusController.text.trim(),
          level: level, // Use the parsed integer
          description: descriptionController.text.trim(),
          cues: cuesController.text.trim(),
          primaryImageId: Constants.missingImageId,
          // TODO add upload image portion on create new pose page
          // TODO OR allow image selection
          // TODO this should be default to exclamation point
          token: user.user.token,
          createdBy: user.user.id,
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
            title: const Text("Add New Pose"),
        ),
        body: BlocConsumer<PosesCubit, PosesState>(
          listener: (context, state) {
            if (state is PoseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("There was an error adding the pose")
                )
                // SnackBar(content: Text(state.error))
              );
            } else if (state is AddNewPoseSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pose added successfully"))
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  HomePage.route(),
                      (_) => false
                  // TODO should this go to pose specific PoseViewPage instead?
              );
            }
          },
          builder: (context, state) {
            if(state is PoseLoading) {
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
                          hintText: 'Pose Name',
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
                          onPressed: createNewPose,
                          child: const Text(
                              "SUBMIT",
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
