import 'package:equatable/equatable.dart';
import 'package:frontend/features/tags/domain/tag_entity.dart';

abstract class TagState extends Equatable {
  const TagState();

  @override
  List<Object?> get props => [];
}

class TagInitial extends TagState {}

class TagLoading extends TagState {}

class TagError extends TagState {
  final String message;

  const TagError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetTagsSuccess extends TagState {
  final List<TagEntity> tags;

  const GetTagsSuccess(this.tags);

  @override
  List<Object?> get props => [tags];
}

class AddTagSuccess extends TagState {
  final TagEntity tag;

  const AddTagSuccess(this.tag);

  @override
  List<Object?> get props => [tag];
}

class UpdateTagSuccess extends TagState {
  final TagEntity tag;

  const UpdateTagSuccess(this.tag);

  @override
  List<Object?> get props => [tag];
}

class DeleteTagSuccess extends TagState {
  final String deletedTagId;

  const DeleteTagSuccess(this.deletedTagId);

  @override
  List<Object?> get props => [deletedTagId];
}
