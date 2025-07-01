import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A generic and reusable search bar for Aerialib library pages.
/// Supports optional suggestion dropdown, generic types, and custom tap behavior.
class LibrarySearchBar<T> extends StatefulWidget {
  final String hintText;
  final List<T> suggestions;
  final String Function(T) getDisplayText;
  final void Function(String) onSearchChanged;
  final void Function(T)? onSuggestionTapped;
  final String? routeName;
  final String? Function(T)? getRouteParam;
  final String? fromPage;
  final bool showSuggestions;

  const LibrarySearchBar({
    super.key,
    required this.hintText,
    required this.suggestions,
    required this.getDisplayText,
    required this.onSearchChanged,
    this.onSuggestionTapped,
    this.routeName,
    this.getRouteParam,
    this.fromPage,
    this.showSuggestions = false,
  });

  @override
  State<LibrarySearchBar<T>> createState() => _LibrarySearchBarState<T>();
}

class _LibrarySearchBarState<T> extends State<LibrarySearchBar<T>> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    if (!widget.showSuggestions) {
      // Simple search bar that filters external list as you type
      return TextField(
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      );
    }

    // Suggestion-enabled search bar using SearchAnchor
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: widget.hintText,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () => controller.openView(),
          onChanged: (value) {
            widget.onSearchChanged(value);
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final text = controller.text.toLowerCase();
        final matches = widget.suggestions
            .where((item) => widget.getDisplayText(item).toLowerCase().contains(text))
            .toList();

        return List<ListTile>.generate(matches.length, (index) {
          final item = matches[index];
          final displayText = widget.getDisplayText(item);

          return ListTile(
            title: Text(displayText),
            onTap: () {
              setState(() {
                controller.clear();
                controller.closeView("");
              });

              if (widget.onSuggestionTapped != null) {
                widget.onSuggestionTapped!(item);
              } else if (widget.routeName != null && widget.getRouteParam != null) {
                final id = widget.getRouteParam!(item);
                if (id != null) {
                  final queryParams = <String, String>{};
                  if (widget.fromPage != null) {
                    queryParams['from'] = widget.fromPage!;
                  }

                  context.goNamed(
                    widget.routeName!,
                    pathParameters: {'poseId': id}, // Customize as needed
                    queryParameters: queryParams,
                  );
                }
              }
            },
          );
        });
      },
    );
  }
}
