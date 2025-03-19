part of 'media_cubit.dart';

sealed class MediaState {
  const MediaState();
}
final class MediaInitial extends MediaState {}

final class MediaLoading extends MediaState {}

final class MediaError extends MediaState {
  final String error;
  MediaError(this.error);
}

final class AddNewMediaSuccess extends MediaState {
  final MediaModel mediaModel;
  const AddNewMediaSuccess(this.mediaModel);
}

final class GetMediaListSuccess extends MediaState {
  final List<MediaModel> mediaList;
  const GetMediaListSuccess(this.mediaList);
}