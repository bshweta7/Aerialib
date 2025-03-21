import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/media/cubit/media_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/features/media/pages/media_library_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/utils.dart';

class UploadNewMediaPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
    builder: (context) => const UploadNewMediaPage(),
  );
  const UploadNewMediaPage({super.key});

  @override
  State<UploadNewMediaPage> createState() => _UploadNewMediaPageState();
}

class _UploadNewMediaPageState extends State<UploadNewMediaPage> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController apparatusController = TextEditingController();
  ValueNotifier<File?> imageController = ValueNotifier(null);
  final formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(_image!.path, filename: _image!.path.split('/').last),
    });

    try {
      Response response = await dio.post(
        Constants.backendUri,
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total'); // Progress tracking
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image upload failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  void createNewMedia() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context
          .read<AuthCubit>()
          .state as AuthLoggedIn;

      await context.read<MediaCubit>().createNewMedia(
        name: nameController.text.trim(),
        token: user.user.token,
        // TODO this should not always be default - should be users/userID/mediaID.jpg if user is uploading
        mediaURL: '/default/${formatUrlFromName(nameController.text.trim())}.jpg',
        // TODO send media file to server to place in data folder
        description: descriptionController.text.trim(),
        apparatus: apparatusController.text.trim(),
        uploadedBy: user.user.id,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add New Media"),
        ),
        body: BlocConsumer<MediaCubit, MediaState>(
          listener: (context, state) {
            if (state is MediaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("There was an error adding the media")
                  )
                // SnackBar(content: Text(state.error))
              );
            } else if (state is AddNewMediaSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Media added successfully"))
              );
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MediaLibraryPage.route(),
              //         (_) => false
              //   // TODO should this go to media specific MediaViewPage instead?
              // );
            }
          },
          builder: (context, state) {
            if(state is MediaLoading) {
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

                      // TODO enable upload image for when users are uploading their own images
                      // Expanded(
                      //     child: _image == null ? Text('No image selected.') : Image.file(_image!)
                      // ), // TODO show missing image if no image selected
                      // ElevatedButton(
                      //   onPressed: getImage,
                      //   child: Text('Select Image'),
                      // ),
                      // ElevatedButton(
                      //   onPressed: uploadImage,
                      //   child: Text('Upload Image'),
                      // ),

                      // Name Textbox
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Media Name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),

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



                      const SizedBox(height: 10,),

                      // Submit button
                      ElevatedButton(
                          onPressed: createNewMedia,
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





// import 'package:flutter/material.dart';
// import 'package:frontend/features/auth/cubit/auth_cubit.dart';
// import 'package:frontend/features/media/cubit/transition_cubit.dart';
// import 'package:frontend/features/home/pages/home_page.dart';
// import 'package:frontend/features/media/pages/transition_library_page.dart';
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
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController cuesController = TextEditingController();
//   TextEditingController apparatusController = TextEditingController();
//   TextEditingController levelController = TextEditingController();
//
//   final formKey = GlobalKey<FormState>();
//
//   void createNewMedia() async {
//     if (formKey.currentState!.validate()) {
//       AuthLoggedIn user = context
//           .read<AuthCubit>()
//           .state as AuthLoggedIn;
//       int? level = int.tryParse(
//           levelController.text.trim()); // Parse level to int
//
//       if (level != null) { // Check if level is a valid integer
//         await context.read<MediaCubit>().createNewMedia(
//           name: nameController.text.trim(),
//           apparatus: apparatusController.text.trim(),
//           level: level, // Use the parsed integer
//           description: descriptionController.text.trim(),
//           cues: cuesController.text.trim(),
//           primaryImageId: user.user.id, // TODO add upload image portion on create new media page
//           token: user.user.token,
//           createdBy: user.user.id,
//         );
//       }
//     }
//   }
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
