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

class GetMediaSuccess extends MediaState {
  final List<MediaEntity> mediaList;
  const GetMediaSuccess(this.mediaList);

  @override
  List<Object?> get props => [mediaList];
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
  final String error;
  const MediaError(this.error);

  @override
  List<Object?> get props => [error];
}
