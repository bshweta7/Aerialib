// import 'package:flex_color_picker/flex_color_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/features/auth/cubit/auth_cubit.dart';
// // import 'package:frontend/features/media/cubit/medias_cubit.dart';
// import 'package:frontend/features/home/pages/home_page.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// // TODO Make this page!!!
//
// class MediaViewPage extends StatefulWidget {
//   static MaterialPageRoute route() => MaterialPageRoute(
//     builder: (context) => const MediaViewPage(),
//   );
//   const MediaViewPage({super.key});
//
//   @override
//   State<MediaViewPage> createState() => _MediaViewPageState();
// }
//
// class _MediaViewPageState extends State<MediaViewPage> {
//   final formKey = GlobalKey<FormState>(); // TODO what does this do, do i need it?
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: const Text("MEDIA VIEW"),
//             actions: const [
//               // GestureDetector(
//               //   onTap: () async {
//               //     final _selectedDate = await showDatePicker(
//               //         context: context,
//               //         firstDate: DateTime.now(),
//               //         lastDate: DateTime.now().add(
//               //             const Duration(days:90)
//               //         )
//               //     );
//               //     if(_selectedDate!=null) {
//               //       setState(() {
//               //         selectedDate = _selectedDate;
//               //       });
//               //     }
//               //   },
//               //   child: Padding(
//               //     padding: const EdgeInsets.all(8.0),
//               //     child: Text(DateFormat("MM-d-y").format(selectedDate)),
//               //   ),
//               // )
//             ]
//         ),
//         body: BlocConsumer<MediasCubit, MediasState>(
//           listener: (context, state) {
//             if (state is MediaError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("There was an error adding the media"))
//                 // SnackBar(content: Text(state.error))
//               );
//             } else if (state is AddNewMediaSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Media added successfully"))
//               );
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   HomePage.route(),
//                       (_) => false
//               );
//             }
//           },
//           builder: (context, state) {
//             if(state is MediaLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: formKey,
//                 child: Column( // TODO expanded widget here???
//                     children: [
//                       // Name Textbox
//                       TextFormField(
//                         controller: nameController,
//                         decoration: const InputDecoration(
//                           hintText: 'Media Name',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return "Name cannot be empty";
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       const SizedBox(height: 10,),
//
//                       // Apparatus Dropdown
//                       DropdownButtonFormField<String>(
//                         value: apparatusController.text.isNotEmpty ? apparatusController.text : null,
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             apparatusController.text = newValue;
//                           }
//                         },
//                         items: <String>['Lyra', 'Hammock']
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         decoration: const InputDecoration(
//                           labelText: 'Apparatus',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select an apparatus';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Level Dropdown
//                       DropdownButtonFormField<int>(
//                         value: levelController.text.isNotEmpty ? int.tryParse(levelController.text) : null,
//                         onChanged: (int? newValue) {
//                           if (newValue != null) {
//                             levelController.text = newValue.toString();
//                           }
//                         },
//                         items: <int>[0, 1, 2, 3, 4,]
//                             .map<DropdownMenuItem<int>>((int value) {
//                           return DropdownMenuItem<int>(
//                             value: value,
//                             child: Text(value.toString()),
//                           );
//                         }).toList(),
//                         decoration: const InputDecoration(
//                           labelText: 'Level',
//                         ),
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Please select a level';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Description Textbox
//                       TextFormField(
//                         controller: descriptionController,
//                         decoration: const InputDecoration(
//                           hintText: 'Description',
//                         ),
//                         maxLines: 2,
//                       ),
//                       const SizedBox(height: 10,),
//
//                       // Cues Textbox
//                       TextFormField(
//                         controller: cuesController,
//                         decoration: const InputDecoration(
//                           hintText: 'Cues',
//                         ),
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 10,),
//
//
//                       const SizedBox(height: 10,),
//                       ElevatedButton(
//                           onPressed: createNewMedia,
//                           child: const Text(
//                               "SUBMIT",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.normal
//                               )
//                           )
//                       ),
//                     ]
//                 ),
//               ),
//             );
//           },
//         )
//     );
//   }
// }
