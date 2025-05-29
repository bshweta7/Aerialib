part of 'music_cubit.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {
  const MusicInitial();
}

class MusicLoading extends MusicState {
  const MusicLoading();
}

class MusicError extends MusicState {
  final String message;
  const MusicError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddNewMusicSuccess extends MusicState {
  final MusicEntity music;
  const AddNewMusicSuccess(this.music);

  @override
  List<Object?> get props => [music];
}

class GetMusicSuccess extends MusicState {
  final List<MusicEntity> musicList;
  const GetMusicSuccess(this.musicList);

  @override
  List<Object?> get props => [musicList];
}

class UpdateMusicSuccess extends MusicState {
  final MusicEntity updatedMusic;
  const UpdateMusicSuccess(this.updatedMusic);

  @override
  List<Object?> get props => [updatedMusic];
}

class DeleteMusicSuccess extends MusicState {
  final String musicId;
  const DeleteMusicSuccess(this.musicId);

  @override
  List<Object?> get props => [musicId];
}
