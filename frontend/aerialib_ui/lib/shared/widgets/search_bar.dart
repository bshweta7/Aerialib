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
  final List<String>? dropdownOptions; // e.g., ["All", "From", "To"]
  final void Function(String)? onDropdownChanged;

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
    this.dropdownOptions,
    this.onDropdownChanged,
  });

  @override
  State<LibrarySearchBar<T>> createState() => _LibrarySearchBarState<T>();
}

class _LibrarySearchBarState<T> extends State<LibrarySearchBar<T>> {
  final _searchController = SearchController();
  String? _selectedDropdown;

  @override
  void initState() {
    super.initState();
    _selectedDropdown = widget.dropdownOptions?.first;
  }

  Widget _buildDropdown() {
    return widget.dropdownOptions != null
        ? DropdownButton<String>(
      value: _selectedDropdown,
      onChanged: (value) {
        setState(() {
          _selectedDropdown = value;
        });
        if (value != null && widget.onDropdownChanged != null) {
          widget.onDropdownChanged!(value);
        }
      },
      underline: const SizedBox(),
      items: widget.dropdownOptions!
          .map((option) => DropdownMenuItem(
        value: option,
        child: Text(option),
      ))
          .toList(),
    )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showSuggestions) {
      return Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.transparent,
        child: TextField(
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _buildDropdown(),
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return TextField(
          controller: controller,
          onChanged: (value) {
            widget.onSearchChanged(value);
            controller.openView();
          },
          onTap: () => controller.openView(),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _buildDropdown(),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
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
                  context.goNamed(
                    widget.routeName!,
                    pathParameters: {'poseId': id},
                    queryParameters: widget.fromPage != null ? {'from': widget.fromPage!} : {},
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