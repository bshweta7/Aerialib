import 'package:flutter/material.dart';
import 'package:frontend/features/music/domain/entities/music_entity.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/info_row.dart';

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
            InfoRow("Artist:", music.artist),
            InfoRow("Mood:", music.mood),
            InfoRow("Link:", music.link),
            InfoRow("Performance Notes:", music.performanceNotes),
            InfoRow("Tempo (BPM):", music.tempoBpm?.toString()),
            InfoRow("Duration (sec):", music.durationSec?.toString()),
            InfoRow("Favorite:", music.favorite ? "Yes" : "No"),
            InfoRow("Created At:", formatDate(music.createdAt)),
            InfoRow("Updated At:", formatDate(music.updatedAt)),
          ],
        ),
      ),
    );
  }

  // Widget _infoRow(String label, String? value) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "$label ",
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value?.isNotEmpty == true ? value! : 'None',
  //             style: TextStyle(
  //               fontStyle: value?.isNotEmpty == true ? FontStyle.normal : FontStyle.italic,
  //               color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
