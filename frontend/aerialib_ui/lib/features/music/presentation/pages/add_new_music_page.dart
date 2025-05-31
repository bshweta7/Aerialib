import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';

import 'package:frontend/features/music/presentation/cubit/music_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

class AddNewMusicPage extends StatefulWidget {
  const AddNewMusicPage({super.key});

  @override
  State<AddNewMusicPage> createState() => _AddNewMusicPageState();
}

class _AddNewMusicPageState extends State<AddNewMusicPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final artistController = TextEditingController();
  final moodController = TextEditingController();
  final linkController = TextEditingController();
  final notesController = TextEditingController();
  final tempoController = TextEditingController();
  final durationController = TextEditingController();

  bool isFavorite = false;

  void createNewMusic() async {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;

      final tempo = int.tryParse(tempoController.text.trim());
      final duration = int.tryParse(durationController.text.trim());

      await context.read<MusicCubit>().createNewMusic(
        name: nameController.text.trim(),
        artist: artistController.text.trim(),
        mood: moodController.text.trim(),
        link: linkController.text.trim(),
        performanceNotes: notesController.text.trim(),
        tempoBpm: tempo,
        durationSec: duration,
        favorite: isFavorite,
        userId: user.user.id,
        token: user.user.token,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    artistController.dispose();
    moodController.dispose();
    linkController.dispose();
    notesController.dispose();
    tempoController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0, // or wherever this fits in your bottom nav
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Add New Music"),
      ),
      body: BlocConsumer<MusicCubit, MusicState>(
        listener: (context, state) {
          if (state is MusicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("There was an error adding the song")),
            );
          } else if (state is AddNewMusicSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Song added successfully")),
            );
            context.goNamed('music-library');
          }
        },
        builder: (context, state) {
          if (state is MusicLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _inputField("Song Name", nameController, required: true),
                    const SizedBox(height: 10),
                    _inputField("Artist", artistController),
                    const SizedBox(height: 10),
                    _inputField("Mood", moodController),
                    const SizedBox(height: 10),
                    _inputField("Link (YouTube/Spotify)", linkController),
                    const SizedBox(height: 10),
                    _inputField("Performance Notes", notesController, maxLines: 2),
                    const SizedBox(height: 10),
                    _numericField("Tempo (BPM)", tempoController),
                    const SizedBox(height: 10),
                    _numericField("Duration (seconds)", durationController),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isFavorite,
                          onChanged: (val) {
                            setState(() => isFavorite = val ?? false);
                          },
                        ),
                        const Text("Mark as Favorite"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: createNewMusic,
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {int maxLines = 1, bool required = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(hintText: label),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }

  Widget _numericField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        if (int.tryParse(value.trim()) == null) {
          return "Please enter a valid number";
        }
        return null;
      },
    );
  }
}
