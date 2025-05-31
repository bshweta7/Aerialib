import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tags/domain/tag_entity.dart';
import 'package:frontend/features/tags/domain/tag_repository.dart';
import 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final TagRepository tagRepository;

  TagCubit({required this.tagRepository}) : super(TagInitial());

  Future<void> getAllTags() async {
    emit(TagLoading());
    try {
      final tags = await tagRepository.getAllTags();
      emit(GetTagsSuccess(tags));
    } catch (e) {
      emit(TagError("Failed to fetch tags: $e"));
    }
  }

  Future<void> addNewTag(TagEntity tag, String token) async {
    emit(TagLoading());
    try {
      final createdTag = await tagRepository.createTag(
        name: tag.name,
        userId: tag.userId,
        color: tag.color,
        token: token,
      );
      emit(AddTagSuccess(createdTag));
      await getAllTags(); // optional refresh
    } catch (e) {
      emit(TagError("Failed to add tag: $e"));
    }
  }


  Future<void> updateTag(TagEntity updatedTag, String token) async {
    emit(TagLoading());
    try {
      final tag = await tagRepository.createTag(
        name: updatedTag.name,
        userId: updatedTag.userId,
        color: updatedTag.color,
        token: token,
      );
      emit(UpdateTagSuccess(tag));
      await getAllTags(); // optional refresh
    } catch (e) {
      emit(TagError("Failed to update tag: $e"));
    }
  }

  Future<void> deleteTag(String id, String token) async {
    emit(TagLoading());
    try {
      await tagRepository.deleteTagById(id, token);
      emit(DeleteTagSuccess(id));
      await getAllTags(); // optional refresh
    } catch (e) {
      emit(TagError("Failed to delete tag: $e"));
    }
  }
}
