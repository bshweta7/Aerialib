import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/presentation/cubit/media/media_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

class UploadNewMediaPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const UploadNewMediaPage());

  const UploadNewMediaPage({super.key});

  @override
  State<UploadNewMediaPage> createState() => _UploadNewMediaPageState();
}

class _UploadNewMediaPageState extends State<UploadNewMediaPage> {
  final formKey = GlobalKey<FormState>();

  File? _image;
  String? _uploadedPath;

  final picker = ImagePicker();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final apparatusController = TextEditingController();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadedPath = null; // Reset upload state
      });
    }
  }

  Future<void> uploadImage() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to upload.')),
      );
      return;
    }
    final token = authState.user.token;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    final dio = Dio();
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        _image!.path,
        filename: _image!.path.split('/').last,
      ),
    });

    try {
      final response = await dio.post(
        '${Constants.backendUrl}/media/upload',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _uploadedPath = response.data['path'];
        });
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
        SnackBar(content: Text('Upload error: $e')),
      );
    }
  }

  Future<void> createNewMedia() async {
    if (formKey.currentState?.validate() != true) return;

    if (_uploadedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload the image first.')),
      );
      return;
    }

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    await context.read<MediaCubit>().createNewMedia(
      token: user.user.token,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      apparatus: apparatusController.text.trim(),
      uploadedBy: user.user.id,
      path: _uploadedPath!,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    apparatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload New Media")),
      body: BlocConsumer<MediaCubit, MediaState>(
        listener: (context, state) {
          if (state is MediaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error adding media.")),
            );
          } else if (state is AddNewMediaSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Media added successfully")),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is MediaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _image != null
                      ? Image.file(_image!, height: 200)
                      : const Text("No image selected."),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: getImage, child: const Text("Select Image")),
                  const SizedBox(height: 5),
                  ElevatedButton(onPressed: uploadImage, child: const Text("Upload Image")),
                  const SizedBox(height: 20),

                  // Name
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "Name cannot be empty"
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Apparatus
                  DropdownButtonFormField<String>(
                    value: apparatusController.text.isNotEmpty ? apparatusController.text : null,
                    onChanged: (val) => apparatusController.text = val ?? '',
                    items: Constants.apparatusOptions
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                    decoration: const InputDecoration(labelText: "Apparatus"),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please select an apparatus' : null,
                  ),
                  const SizedBox(height: 10),

                  // Description
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: createNewMedia,
                    child: const Text("SUBMIT"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
