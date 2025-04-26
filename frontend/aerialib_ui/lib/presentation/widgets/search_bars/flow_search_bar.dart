import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/pages/flows/flow_details_page.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final List<FlowEntity> suggestionList;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    this.onSearchSubmitted,
    required this.suggestionList,
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
          onSubmitted: (value) {
            if (widget.onSearchSubmitted != null) {
              widget.onSearchSubmitted!();
            }
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final suggestions = widget.suggestionList
            .where((flow) => flow.name.toLowerCase().contains(controller.text.toLowerCase()))
            .toList();

        return List<ListTile>.generate(suggestions.length, (int index) {
          final FlowEntity flow = suggestions[index];
          return ListTile(
            title: Text(flow.name),
            onTap: () {
              setState(() {
                controller.closeView(flow.name);
              });
              Navigator.push(
                context,
                FlowDetailsPage.route(flow), // Navigate directly to FlowViewPage
              );
            },
          );
        });
      },
    );
  }
}