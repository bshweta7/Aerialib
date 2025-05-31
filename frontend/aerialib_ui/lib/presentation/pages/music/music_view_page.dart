import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/music_entity.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';
import 'package:frontend/presentation/widgets/navigation/smart_back_button.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:go_router/go_router.dart';

class MusicViewPage extends StatelessWidget {
  final MusicEntity music;

  const MusicViewPage({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Song Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.goNamed(
                'music-edit',
                pathParameters: {'musicId': music.id},
                queryParameters: {'from': 'music-library'},
              );
            },
            tooltip: 'Edit music details',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                music.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _infoRow("Artist:", music.artist),
            _infoRow("Mood:", music.mood),
            _infoRow("Link:", music.link),
            _infoRow("Performance Notes:", music.performanceNotes),
            _infoRow("Tempo (BPM):", music.tempoBpm?.toString()),
            _infoRow("Duration (sec):", music.durationSec?.toString()),
            _infoRow("Favorite:", music.favorite ? "Yes" : "No"),
            _infoRow("Created At:", formatDate(music.createdAt)),
            _infoRow("Updated At:", formatDate(music.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : 'None',
              style: TextStyle(
                fontStyle: value?.isNotEmpty == true ? FontStyle.normal : FontStyle.italic,
                color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
