import 'package:flutter/material.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/constants.dart';
import '../../data/models/pose_model.dart';

class UpdatePosePage extends StatefulWidget {
  final PoseModel pose;

  const UpdatePosePage({super.key, required this.pose});

  static MaterialPageRoute route(PoseModel pose) => MaterialPageRoute(
    builder: (context) => UpdatePosePage(pose: pose),
  );


  @override
  State<UpdatePosePage> createState() => _UpdatePosePageState();
}

class _UpdatePosePageState extends State<UpdatePosePage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController cuesController;
  late TextEditingController apparatusController;
  late int level;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pose.name);
    descriptionController = TextEditingController(text: widget.pose.description);
    cuesController = TextEditingController(text: widget.pose.cues);
    apparatusController = TextEditingController(text: widget.pose.apparatus);
    level = widget.pose.level;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    cuesController.dispose();
    apparatusController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePose() async {
    AuthLoggedIn user = context
        .read<AuthCubit>()
        .state as AuthLoggedIn;
    // int? level = int.tryParse(
    //     levelController.text.trim()); // Parse level to int

    final updatedPose = PoseModel(
      id: widget.pose.id,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      cues: cuesController.text.trim(),
      apparatus: apparatusController.text.trim(),
      level: level,
      createdBy: widget.pose.createdBy,
      createdAt: widget.pose.createdAt,
      updatedBy: user.user.id,
      updatedAt: DateTime.now(),
      isSynced: widget.pose.isSynced,
      primaryImageId: Constants.missingImageId,
      primaryImageUrl: widget.pose.primaryImageUrl,
    );

    await context.read<PosesCubit>().updatePoseInfo(
      updatedPose: updatedPose,
      token: user.user.token,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Pose')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: cuesController, decoration: const InputDecoration(labelText: 'Cues')),
            TextField(controller: apparatusController, decoration: const InputDecoration(labelText: 'Apparatus')),
            TextField(
              decoration: const InputDecoration(labelText: 'Level'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                level = int.tryParse(value) ?? level;
              },
              controller: TextEditingController(text: level.toString()),
            ),
            ElevatedButton(
              onPressed: _handleUpdatePose, // Call the separate function
              child: const Text('Update Pose'),
            ),
          ],
        ),
      ),


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
    );
  }
}
