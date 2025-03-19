// import 'package:flutter/material.dart';
// import 'package:frontend/features/auth/cubit/auth_cubit.dart';
// import 'package:frontend/features/media/cubit/media_cubit.dart';
// import 'package:frontend/features/home/pages/home_page.dart';
// import 'package:frontend/features/media/pages/media_library_page.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class AddNewMediaPage extends StatefulWidget {
//   static MaterialPageRoute route() => MaterialPageRoute(
//     builder: (context) => const AddNewMediaPage(),
//   );
//   const AddNewMediaPage({super.key});
//
//   @override
//   State<AddNewMediaPage> createState() => _AddNewMediaPageState();
// }
//
// class _AddNewMediaPageState extends State<AddNewMediaPage> {
//   TextEditingController nameController = TextEditingController();
//
//   final formKey = GlobalKey<FormState>();
//
//   void createNewMedia() async {
//     if (formKey.currentState!.validate()) {
//       AuthLoggedIn user = context
//           .read<AuthCubit>()
//           .state as AuthLoggedIn;
//
//       await context.read<MediaCubit>().createNewMedia(
//         name: nameController.text.trim(),
//         token: user.user.token,
//         mediaURL: 'mediaURLController.text.trim()',
//         description: 'test',
//         apparatus: 'lyra', // TODO
//         uploadedBy: user.user.id,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Add New Media"),
//         ),
//         body: BlocConsumer<MediaCubit, MediaState>(
//           listener: (context, state) {
//             if (state is MediaError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                       content: Text("There was an error adding the media")
//                   )
//                 // SnackBar(content: Text(state.error))
//               );
//             } else if (state is AddNewMediaSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Media added successfully"))
//               );
//               // Navigator.pushAndRemoveUntil(
//               //     context,
//               //     MediaLibraryPage.route(),
//               //         (_) => false
//               //   // TODO should this go to media specific MediaViewPage instead?
//               // );
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
//                 child: Column(
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
//                       // Submit button
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
