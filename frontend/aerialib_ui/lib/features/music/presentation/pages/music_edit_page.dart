import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/music/domain/entities/music_entity.dart';
import 'package:frontend/features/music/presentation/cubit/music_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';
import 'package:frontend/shared/helpers/validators.dart';

class MusicEditPage extends StatefulWidget {
  final MusicEntity music;

  const MusicEditPage({super.key, required this.music});

  @override
  State<MusicEditPage> createState() => _MusicEditPageState();
}

class _MusicEditPageState extends State<MusicEditPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController artistController;
  late TextEditingController moodController;
  late TextEditingController linkController;
  late TextEditingController notesController;
  late TextEditingController tempoController;
  late TextEditingController durationController;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.music.name);
    artistController = TextEditingController(text: widget.music.artist ?? '');
    moodController = TextEditingController(text: widget.music.mood ?? '');
    linkController = TextEditingController(text: widget.music.link ?? '');
    notesController = TextEditingController(text: widget.music.performanceNotes ?? '');
    tempoController = TextEditingController(
      text: widget.music.tempoBpm?.toString() ?? '',
    );
    durationController = TextEditingController(
      text: widget.music.durationSec?.toString() ?? '',
    );
    isFavorite = widget.music.favorite;
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

  Future<void> _handleUpdateMusic() async {
    if (!formKey.currentState!.validate()) return;

    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedMusic = MusicEntity(
      id: widget.music.id,
      userId: widget.music.userId,
      name: nameController.text.trim(),
      artist: artistController.text.trim(),
      mood: moodController.text.trim(),
      link: linkController.text.trim(),
      performanceNotes: notesController.text.trim(),
      tempoBpm: int.tryParse(tempoController.text.trim()),
      durationSec: int.tryParse(durationController.text.trim()),
      favorite: isFavorite,
      createdAt: widget.music.createdAt,
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    await context.read<MusicCubit>().updateMusic(
      updatedMusic: updatedMusic,
      token: user.user.token,
    );

    await context.read<MusicCubit>().getAllMusic(token: user.user.token);

    context.goNamed(
      'music-view',
      pathParameters: {'musicId': updatedMusic.id},
      // queryParameters: {'from': 'music-edit'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      appBar: AppBar(
        title: const Text('Update Song'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _handleUpdateMusic,
            tooltip: 'Save changes',
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: requiredFieldValidator,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: artistController,
                  decoration: const InputDecoration(labelText: 'Artist'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: moodController,
                  decoration: const InputDecoration(labelText: 'Mood'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: linkController,
                  decoration: const InputDecoration(labelText: 'Link'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Performance Notes'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: tempoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Tempo (BPM)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Duration (seconds)'),
                ),
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
                  onPressed: _handleUpdateMusic,
                  child: const Text('Update Song'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
