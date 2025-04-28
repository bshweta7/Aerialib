import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/pages/poses/pose_details_page.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final List<PoseEntity> suggestionList;
  final Function(PoseEntity)? onSuggestionTapped;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.suggestionList,
    this.onSuggestionTapped,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
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
            .where((pose) => pose.name.toLowerCase().contains(controller.text.toLowerCase()))
            .toList();

        return List<ListTile>.generate(suggestions.length, (int index) {
          final PoseEntity pose = suggestions[index];
          return ListTile(
            title: Text(pose.name),
            onTap: () {
              setState(() {
                controller.clear(); // ✨ clear the search text
                controller.closeView(""); // ✨ close suggestion view without filling text
              });

              if (widget.onSuggestionTapped != null) {
                widget.onSuggestionTapped!(pose);
              } else {
                Navigator.push(
                  context,
                  PoseDetailsPage.route(pose),
                );
              }
            }
          );
        });
      },
    );
  }
}
