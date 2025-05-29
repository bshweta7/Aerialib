import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/domain/entities/music_entity.dart';
import 'package:frontend/domain/repositories/music_repository.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  final MusicRepository _musicRepository;
  bool _isSyncing = false;

  MusicCubit(this._musicRepository) : super(const MusicInitial());

  /// Create a new music entry
  Future<void> createNewMusic({
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
      emit(const MusicLoading());

      final music = await _musicRepository.createMusic(
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

      emit(AddNewMusicSuccess(music));
    } catch (e) {
      log('[MusicCubit] Error creating music: $e');
      emit(MusicError(e.toString()));
    }
  }

  /// Fetch all music (from local storage or remote if needed)
  Future<void> getAllMusic({required String token}) async {
    try {
      emit(const MusicLoading());

      final musicList = await _musicRepository.getAllMusic();
      emit(GetMusicSuccess(musicList));
    } catch (e) {
      log('[MusicCubit] GetAllMusic failed: $e');
      emit(MusicError(e.toString()));
    }
  }

  /// Sync local to remote and remote to local
  Future<void> syncMusic({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    log("[MusicCubit] Starting music sync...");

    try {
      await _musicRepository.syncLocalToRemote(token);
      await _musicRepository.syncRemoteToLocal(token);

      final updatedMusic = await _musicRepository.getAllMusic();
      emit(GetMusicSuccess(updatedMusic));
    } catch (e) {
      log('[MusicCubit] Sync error: $e');
      emit(MusicError('[MusicCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }

  /// Update a music entry
  Future<void> updateMusic({
    required MusicEntity updatedMusic,
    required String token,
  }) async {
    emit(const MusicLoading());

    try {
      await _musicRepository.updateMusic(
        updatedMusic: updatedMusic,
        token: token,
      );
      emit(UpdateMusicSuccess(updatedMusic));
    } catch (e) {
      emit(MusicError("Failed to update music: $e"));
    }
  }

  /// Toggle the favorite status of a music entry
  Future<void> toggleFavorite({
    required MusicEntity music,
    required String token,
  }) async {
    emit(const MusicLoading());

    try {
      final updatedMusic = music.copyWith(
        favorite: !music.favorite,
        updatedAt: DateTime.now(),
        isSynced: 0,
      );

      await _musicRepository.updateMusic(
        updatedMusic: updatedMusic,
        token: token,
      );

      emit(UpdateMusicSuccess(updatedMusic));
    } catch (e) {
      emit(MusicError("Failed to update favorite status: $e"));
    }
  }

  /// Delete a music entry
  Future<void> deleteMusic(String musicId) async {
    try {
      emit(const MusicLoading());
      await _musicRepository.deleteMusic(musicId);
      emit(DeleteMusicSuccess(musicId));
    } catch (e) {
      log('[MusicCubit] Delete error: $e');
      emit(MusicError(e.toString()));
    }
  }


}
