import 'package:flutter/material.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/presentation/pages/pose_view_page.dart';
import 'package:go_router/go_router.dart';

class PoseSearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final List<PoseEntity> suggestionList;
  final Function(PoseEntity)? onSuggestionTapped;
  final String? hintText;
  final String? fromPage;

  const PoseSearchBarWidget({
    super.key,
    required this.onSearchChanged,
    required this.suggestionList,
    this.onSuggestionTapped,
    this.hintText,
    this.fromPage,
  });

  @override
  State<PoseSearchBarWidget> createState() => _PoseSearchBarWidgetState();
}

class _PoseSearchBarWidgetState extends State<PoseSearchBarWidget> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: widget.hintText,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (value) {
            widget.onSearchChanged(value); // Notify parent widget
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final suggestions = widget.suggestionList
            .where((pose) => pose.displayName.toLowerCase().contains(controller.text.toLowerCase()))
            .toList();

        return List<ListTile>.generate(suggestions.length, (int index) {
          final PoseEntity pose = suggestions[index];
          return ListTile(
            title: Text(pose.displayName),
            onTap: () {
              setState(() {
                controller.clear(); // ✨ clear the search text
                controller.closeView(""); // ✨ close suggestion view without filling text
              });

              if (widget.onSuggestionTapped != null) {
                widget.onSuggestionTapped!(pose);
              } else {
                context.goNamed(
                  'pose-view',
                  pathParameters: {'poseId': pose.id},
                  queryParameters: {'from': widget.fromPage},
                );
              }
            }
          );
        });
      },
    );
  }
}
