import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tags/domain/tag_entity.dart';
import 'package:frontend/features/tags/presentation/cubit/tag_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import '../cubit/tag_state.dart';

class TagManagerPage extends StatelessWidget {
  const TagManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Tag',
            onPressed: () => _showAddTagDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<TagCubit, TagState>(
        builder: (context, state) {
          if (state is TagLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TagError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          final tags = state is GetTagsSuccess ? state.tags : [];

          return tags.isEmpty
              ? const Center(
            child: Text(
              "No Tags",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];

              return Card(
                child: ListTile(
                  title: GestureDetector(
                    child: Text(tag.name),
                    onTap: () => _editNameDialog(context, tag),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _pickColor(context, tag),
                    child: CircleAvatar(
                      backgroundColor: tag.color != null
                          ? Color(int.parse(tag.color!))
                          : Colors.grey,
                      radius: 12,
                    ),
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }

  void _editNameDialog(BuildContext context, TagEntity tag) {
    final controller = TextEditingController(text: tag.name);
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tag Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "New tag name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != tag.name) {
                final updatedTag = tag.copyWith(name: newName);
                context.read<TagCubit>().updateTag(updatedTag, user.user.token);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _pickColor(BuildContext context, TagEntity tag) async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final currentColor = tag.color != null
        ? Color(int.parse(tag.color!))
        : Colors.grey;

    final pickedColor = await showColorPickerDialog(
      context,
      currentColor,
      title: const Text('Pick a color'),
      showColorName: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.accent: false,
        ColorPickerType.primary: true,
      },
    );

    final updatedTag = tag.copyWith(color: pickedColor.value.toString());
    context.read<TagCubit>().updateTag(updatedTag, user.user.token);
  }

  void _showAddTagDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tag'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter tag name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final user = context.read<AuthCubit>().state as AuthLoggedIn;
                final newTag = TagEntity(
                  id: '', // backend will assign
                  name: name,
                  userId: user.user.id,
                  color: null,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isSynced: 0,
                );
                context.read<TagCubit>().addNewTag(newTag, user.user.token);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

}
