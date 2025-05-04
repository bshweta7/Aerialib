import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/pages/poses/pose_library_page.dart';

class UpdatePosePage extends StatefulWidget {
  final PoseEntity pose;

  const UpdatePosePage({super.key, required this.pose});

  static MaterialPageRoute route(PoseEntity pose) => MaterialPageRoute(
    builder: (context) => UpdatePosePage(pose: pose),
  );

  @override
  State<UpdatePosePage> createState() => _UpdatePosePageState();
}


class _UpdatePosePageState extends State<UpdatePosePage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController teachingCuesController;
  late TextEditingController safetyCuesController;
  late TextEditingController progressionsController;
  late String apparatus;
  late double level;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.pose.name);
    descriptionController =
        TextEditingController(text: widget.pose.description);
    teachingCuesController =
        TextEditingController(text: widget.pose.teachingCues);
    safetyCuesController = TextEditingController(text: widget.pose.safetyCues);
    progressionsController =
        TextEditingController(text: widget.pose.progressions);

    apparatus = widget.pose.apparatus;
    level = widget.pose.level;
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


  Future<void> _handleUpdatePose() async {
    final user = context
        .read<AuthCubit>()
        .state as AuthLoggedIn;

    final updatedPose = PoseEntity(
      id: widget.pose.id,
      name: nameController.text.trim(),
      primaryMediaId: widget.pose.primaryMediaId,
      primaryMediaPath: widget.pose.primaryMediaPath,
      description: descriptionController.text.trim(),
      teachingCues: teachingCuesController.text.trim(),
      safetyCues: safetyCuesController.text.trim(),
      progressions: progressionsController.text.trim(),
      apparatus: apparatus,
      level: level,
      createdBy: widget.pose.createdBy,
      createdAt: widget.pose.createdAt,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<PosesCubit>().updatePoseInfo(
      updatedPose: updatedPose,
      token: user.user.token,
    );

    await context.read<PosesCubit>().getAllPoses(token: user.user.token);
    Navigator.pushAndRemoveUntil(
      context,
      PoseLibraryPage.route(),
          (route) => true,
      // TODO change this to false so it clears the entire navigation stack
      // TODO need to make bottom bar for navigation

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Pose')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: apparatus,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      apparatus = newValue;
                    });
                  }
                },
                items: Constants.apparatusOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Apparatus'),
              ),

              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Level'),
                keyboardType: TextInputType.number,
                initialValue: level.toString(),
                onChanged: (value) {
                  setState(() {
                    level = double.tryParse(value) ?? level;
                  });
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
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

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleUpdatePose,
                child: const Text('Update Pose'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
      //       TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
      //       TextField(controller: cuesController, decoration: const InputDecoration(labelText: 'Cues')),
      //       TextField(controller: apparatusController, decoration: const InputDecoration(labelText: 'Apparatus')),
      //       TextField(
      //         decoration: const InputDecoration(labelText: 'Level'),
      //         keyboardType: TextInputType.number,
      //         onChanged: (value) {
      //           level = int.tryParse(value) ?? level;
      //         },
      //         controller: TextEditingController(text: level.toString()),
      //       ),
      //       ElevatedButton(
      //         onPressed: _handleUpdatePose, // Call the separate function
      //         child: const Text('Update Pose'),
      //       ),
      //     ],
      //   ),
      // ),


        // appBar: AppBar(
        //   title: const Text("Update Pose: ${widget.pose}"),
        // ),
        // body: BlocConsumer<PosesCubit, PosesState>(
        //   listener: (context, state) {
        //     if (state is PoseError) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(
        //               content: Text("There was an error adding the pose")
        //           )
        //         // SnackBar(content: Text(state.error))
        //       );
        //     } else if (state is AddNewPoseSuccess) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(content: Text("Pose added successfully"))
        //       );
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           HomePage.route(),
        //               (_) => false
        //         // TODO should this go to pose specific PoseViewPage instead?
        //       );
        //     }
        //   },
        //   builder: (context, state) {
        //     if(state is PoseLoading) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     return Padding(
        //       padding: const EdgeInsets.all(20),
        //       child: Form(
        //         key: formKey,
        //         child: Column( // TODO expanded widget here???
        //             children: [
        //               // Name Textbox
        //               TextFormField(
        //                 controller: nameController,
        //                 decoration: const InputDecoration(
        //                   hintText: 'Pose Name',
        //                 ),
        //                 validator: (value) {
        //                   if (value == null || value.trim().isEmpty) {
        //                     return "Name cannot be empty";
        //                   } else {
        //                     return null;
        //                   }
        //                 },
        //               ),
        //               const SizedBox(height: 10,),
        //
        //               // Apparatus Dropdown
        //               DropdownButtonFormField<String>(
        //                 value: apparatusController.text.isNotEmpty ? apparatusController.text : null,
        //                 onChanged: (String? newValue) {
        //                   if (newValue != null) {
        //                     apparatusController.text = newValue;
        //                   }
        //                 },
        //                 items: <String>['Lyra', 'Hammock']
        //                     .map<DropdownMenuItem<String>>((String value) {
        //                   return DropdownMenuItem<String>(
        //                     value: value,
        //                     child: Text(value),
        //                   );
        //                 }).toList(),
        //                 decoration: const InputDecoration(
        //                   labelText: 'Apparatus',
        //                 ),
        //                 validator: (value) {
        //                   if (value == null || value.isEmpty) {
        //                     return 'Please select an apparatus';
        //                   }
        //                   return null;
        //                 },
        //               ),
        //               const SizedBox(height: 10),
        //
        //               // Level Dropdown
        //               DropdownButtonFormField<int>(
        //                 value: levelController.text.isNotEmpty ? int.tryParse(levelController.text) : null,
        //                 onChanged: (int? newValue) {
        //                   if (newValue != null) {
        //                     levelController.text = newValue.toString();
        //                   }
        //                 },
        //                 items: <int>[0, 1, 2, 3, 4,]
        //                     .map<DropdownMenuItem<int>>((int value) {
        //                   return DropdownMenuItem<int>(
        //                     value: value,
        //                     child: Text(value.toString()),
        //                   );
        //                 }).toList(),
        //                 decoration: const InputDecoration(
        //                   labelText: 'Level',
        //                 ),
        //                 validator: (value) {
        //                   if (value == null) {
        //                     return 'Please select a level';
        //                   }
        //                   return null;
        //                 },
        //               ),
        //               const SizedBox(height: 10),
        //
        //               // Description Textbox
        //               TextFormField(
        //                 controller: descriptionController,
        //                 decoration: const InputDecoration(
        //                   hintText: 'Description',
        //                 ),
        //                 maxLines: 2,
        //               ),
        //               const SizedBox(height: 10,),
        //
        //               // Cues Textbox
        //               TextFormField(
        //                 controller: cuesController,
        //                 decoration: const InputDecoration(
        //                   hintText: 'Cues',
        //                 ),
        //                 maxLines: 3,
        //               ),
        //               const SizedBox(height: 10,),
        //
        //
        //               const SizedBox(height: 10,),
        //               ElevatedButton(
        //                   onPressed: () async {
        //                     updatePoseInfo,
        //                     child: const Text(
        //                     "SUBMIT"
        //                   },
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 18,
        //                           fontWeight: FontWeight.normal
        //                       )
        //                   )
        //               ),
        //             ]
        //         ),
        //       ),
        //     );
        //   },
        // )
//     );
//   }
// }
