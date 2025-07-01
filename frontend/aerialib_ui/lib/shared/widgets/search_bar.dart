import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO make a version of this WITH search suggestions
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
  final SearchController _searchController = SearchController();
  String? _selectedDropdown;

  @override
  void initState() {
    super.initState();
    _selectedDropdown = widget.dropdownOptions?.first;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showSuggestions) {
      // TextField version
      return TextField(
        onChanged: widget.onSearchChanged,
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
    }

    // ✅ SearchBar with preserved controller
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: _searchController,
          hintText: widget.hintText,
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100),
          leading: const Icon(Icons.search),
          trailing: widget.dropdownOptions != null
              ? [
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: _selectedDropdown,
              onChanged: (value) {
                setState(() => _selectedDropdown = value);
                if (value != null && widget.onDropdownChanged != null) {
                  widget.onDropdownChanged!(value);
                }
              },
              underline: const SizedBox(),
              items: widget.dropdownOptions!
                  .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
            ),
          ]
              : null,
          onTap: () => _searchController.openView(),
          onChanged: (value) {
            widget.onSearchChanged(value);
            _searchController.openView();
          },
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = _searchController.text.toLowerCase();
        final matches = widget.suggestions
            .where((item) => widget.getDisplayText(item).toLowerCase().contains(query))
            .toList();

        return List<ListTile>.generate(matches.length, (index) {
          final item = matches[index];
          final label = widget.getDisplayText(item);

          return ListTile(
            title: Text(label),
            onTap: () {
              setState(() {
                _searchController.clear();
                _searchController.closeView("");
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

  Widget _buildDropdown() {
    if (widget.dropdownOptions == null || widget.dropdownOptions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedDropdown,
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: (value) {
          setState(() => _selectedDropdown = value);
          if (value != null && widget.onDropdownChanged != null) {
            widget.onDropdownChanged!(value);
          }
        },
        items: widget.dropdownOptions!
            .map((option) => DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        ))
            .toList(),
        style: Theme.of(context).textTheme.bodyMedium,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

}
