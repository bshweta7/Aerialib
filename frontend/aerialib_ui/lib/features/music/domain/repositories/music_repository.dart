import 'dart:developer';

import 'package:frontend/features/music/domain/entities/music_entity.dart';
import 'package:frontend/features/music/domain/mappers/music_mapper.dart';

import 'package:frontend/features/music/data/datasources/music_local_data.dart';
import 'package:frontend/features/music/data/datasources/music_remote_data.dart';
import 'package:frontend/features/music/data/models/music_model.dart';

class MusicRepository {
  final MusicLocalDataSource localDataSource;
  final MusicRemoteDataSource remoteDataSource;

  MusicRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new music entry (tries remote first, fallback to local if offline)
  Future<MusicEntity> createMusic({
    required String name,
    String? artist,
    String? mood,
    String? link,
    String? performanceNotes,
    int? tempoBpm,
    int? durationSec,
    bool favorite = false,
    required String userId,
    required String token,
  }) async {
    try {
      log('[MusicRepository] Creating music remotely...');

      final musicModel = await remoteDataSource.createMusic(
        name: name,
        artist: artist,
        mood: mood,
        link: link,
        performanceNotes: performanceNotes,
        tempoBpm: tempoBpm,
        durationSec: durationSec,
        favorite: favorite,
        userId: userId,
        token: token,
      );

      log('[MusicRepository] Remote music created with ID: ${musicModel.id}');

      await localDataSource.insertMusic(musicModel);
      log('[MusicRepository] Music inserted into local database.');

      return MusicMapper.modelToEntity(musicModel);
    } catch (e) {
      log('[MusicRepository] Error creating music remotely, fallback to local. Error: $e');

      final fallback = MusicModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: name,
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

      await localDataSource.insertMusic(fallback);
      return MusicMapper.modelToEntity(fallback);
    }
  }

  /// Get all music from local DB
  Future<List<MusicEntity>> getAllMusic() async {
    final musicModels = await localDataSource.getAllMusic();
    return MusicMapper.modelsToEntities(musicModels);
  }

  /// Fetch remote music and cache locally
  Future<void> syncRemoteToLocal(String token) async {
    final remoteModels = await remoteDataSource.fetchRemoteMusic(token: token);
    await localDataSource.insertMusicList(remoteModels);
  }

  /// Push unsynced local music to backend
  Future<void> syncLocalToRemote(String token) async {
    final unsynced = await localDataSource.getUnsyncedMusic();
    if (unsynced.isEmpty) return;

    log('[MusicRepository] Syncing ${unsynced.length} music items to remote...');
    final success = await remoteDataSource.syncMusic(
      token: token,
      musicList: unsynced,
    );

    if (success) {
      for (final music in unsynced) {
        await localDataSource.setSyncedStatus(music.id, 1);
      }
    }
  }

  /// Update music entry remotely and locally
  Future<void> updateMusic({
    required MusicEntity updatedMusic,
    required String token,
  }) async {
    try {
      log("[MusicRepository] Updating music: ${updatedMusic.name}");

      // Convert entity to model
      final model = MusicMapper.entityToModel(updatedMusic);

      // Update remotely
      final updated = await remoteDataSource.updateMusic(
        updatedMusic: model,
        token: token,
      );
      log("[MusicRepository] Remote update succeeded for: ${updated.id}");

      // Save updated version locally
      final syncedModel = updated.copyWith(isSynced: 1);
      await localDataSource.updateMusic(syncedModel);
      log("[MusicRepository] Local update completed for: ${syncedModel.id}");

    } catch (e, st) {
      log("[MusicRepository] ERROR during music update: $e");
      log("[MusicRepository] Stacktrace:\n$st");
      rethrow;
    }
  }

  /// Delete music entry locally
  Future<void> deleteMusic(String id) async {
    await localDataSource.deleteMusic(id);
  }
}
