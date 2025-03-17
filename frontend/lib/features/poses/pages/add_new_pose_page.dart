import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/poses/cubit/poses_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  TextEditingController thumbnailURLController = TextEditingController();

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
          description: descriptionController.text.trim(),
          cues: cuesController.text.trim(),
          apparatus: apparatusController.text.trim(),
          level: level, // Use the parsed integer
          thumbnailURL: thumbnailURLController.text.trim(),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add New Pose"),
            actions: const [
              // GestureDetector(
              //   onTap: () async {
              //     final _selectedDate = await showDatePicker(
              //         context: context,
              //         firstDate: DateTime.now(),
              //         lastDate: DateTime.now().add(
              //             const Duration(days:90)
              //         )
              //     );
              //     if(_selectedDate!=null) {
              //       setState(() {
              //         selectedDate = _selectedDate;
              //       });
              //     }
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(DateFormat("MM-d-y").format(selectedDate)),
              //   ),
              // )
            ]
        ),
        body: BlocConsumer<PosesCubit, PosesState>(
          listener: (context, state) {
            if (state is PoseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error))
              );
            } else if (state is AddNewPoseSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pose added successfully"))
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  HomePage.route(),
                      (_) => false
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
                child: Column(
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
                      


                      // ColorPicker(
                      //   heading: const Text("Select Color"),
                      //   subheading: const Text("Select a different shade"),
                      //   onColorChanged: (Color color) {
                      //     setState(() {
                      //       selectedColor = color;
                      //     });
                      //   },
                      //   color: selectedColor,
                      //   pickersEnabled: {
                      //     ColorPickerType.wheel: true,
                      //   },
                      // ),
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
