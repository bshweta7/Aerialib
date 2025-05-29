import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:frontend/data/models/music_model.dart';
import 'package:frontend/data/services/http_service.dart';

class MusicRemoteDataSource {
  final HttpService httpService;

  MusicRemoteDataSource({required this.httpService});

  /// Create and return MusicModel
  Future<MusicModel> createMusic({
    required String name,
    required String userId,
    required String token,
    String? artist,
    String? mood,
    String? link,
    String? performanceNotes,
    int? tempoBpm,
    int? durationSec,
    bool favorite = false,
  }) async {
    final body = {
      'name': name,
      'userId': userId,
      if (artist != null) 'artist': artist,
      if (mood != null) 'mood': mood,
      if (link != null) 'link': link,
      if (performanceNotes != null) 'performanceNotes': performanceNotes,
      if (tempoBpm != null) 'tempoBpm': tempoBpm,
      if (durationSec != null) 'durationSec': durationSec,
      'favorite': favorite ? 1 : 0,
    };

    try {
      final response = await httpService.post(
        path: "/music",
        token: token,
        body: body,
      );

      return MusicModel.fromJson(response.body);
    } catch (e) {
      return MusicModel(
        id: const Uuid().v6(),
        name: name,
        userId: userId,
        artist: artist,
        mood: mood,
        link: link,
        performanceNotes: performanceNotes,
        tempoBpm: tempoBpm,
        durationSec: durationSec,
        favorite: favorite,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: 0,
      );
    }
  }

  Future<List<MusicModel>> fetchRemoteMusic({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/music",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => MusicModel.fromMap(e)).toList();
  }

  Future<bool> syncMusic({
    required String token,
    required List<MusicModel> musicList,
  }) async {
    final musicListInMap = musicList.map((music) {
      final map = music.toMap();
      map.remove('is_synced');
      return map;
    }).toList();

    log('[MusicRemoteDataSource] Sync payload:');
    for (final map in musicListInMap) {
      log('[MusicRemoteDataSource] ${map.keys}');
    }

    final response = await httpService.post(
      path: "/music/sync",
      token: token,
      body: musicListInMap,
    );

    if (response.statusCode == 201) {
      log('[MusicRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[MusicRemoteDataSource] Sync failed: ${response.statusCode}');
      return false;
    }
  }

  Future<MusicModel> updateMusic({
    required MusicModel updatedMusic,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/music/update/${updatedMusic.id}",
      token: token,
      body: updatedMusic.toMap(),
    );

    if (response.statusCode != 200) {
      log("[MusicRemoteDataSource] Failed to update music:");
      log("[MusicRemoteDataSource] Status: ${response.statusCode}");
      log("[MusicRemoteDataSource] Body: ${response.body}");
      throw Exception("[MusicRemoteDataSource] Failed to update music remotely");
    }

    final json = jsonDecode(response.body);
    return MusicModel.fromMap(json);
  }

// TODO: deleteMusic function if needed
}
