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
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  DateTime selectedDate = DateTime.now();
  final formKey = GlobalKey<FormState>();

  void createNewPose() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      await context.read<PosesCubit>().createNewPose(
        uid: user.user.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        color: selectedColor,
        token: user.user.token,
        dueAt: selectedDate);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add New Pose"),
            actions: [
              GestureDetector(
                onTap: () async {
                  final _selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                          const Duration(days:90)
                      )
                  );
                  if(_selectedDate!=null) {
                    setState(() {
                      selectedDate = _selectedDate;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("MM-d-y").format(selectedDate)),
                ),
              )
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
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Title cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Description cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 4,
                      ),
                      const SizedBox(height: 10,),
                      ColorPicker(
                        heading: const Text("Select Color"),
                        subheading: const Text("Select a different shade"),
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        color: selectedColor,
                        pickersEnabled: {
                          ColorPickerType.wheel: true,
                        },
                      ),
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
