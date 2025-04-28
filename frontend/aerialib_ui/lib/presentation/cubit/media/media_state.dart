part of 'media_cubit.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MediaState {
  const MediaInitial();
}

class MediaLoading extends MediaState {
  const MediaLoading();
}

class GetMediasSuccess extends MediaState {
  final List<MediaEntity> medias;
  const GetMediasSuccess(this.medias);

  @override
  List<Object?> get props => [medias];
}

class AddNewMediaSuccess extends MediaState {
  final MediaEntity media;
  const AddNewMediaSuccess(this.media);

  @override
  List<Object?> get props => [media];
}

class UpdateMediaSuccess extends MediaState {
  final MediaEntity updatedMedia;
  const UpdateMediaSuccess(this.updatedMedia);

  @override
  List<Object?> get props => [updatedMedia];
}

class MediaError extends MediaState {
  final String message;
  const MediaError(this.message);

  @override
  List<Object?> get props => [message];
}
