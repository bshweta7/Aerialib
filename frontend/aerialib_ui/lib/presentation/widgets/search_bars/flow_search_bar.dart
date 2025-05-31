import 'package:flutter/material.dart';
import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/features/flow/presentation/pages/flow_view_page.dart';
import 'package:go_router/go_router.dart';

class FlowSearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final List<FlowEntity> suggestionList;
  final String? hintText;

  const FlowSearchBarWidget({
    super.key,
    required this.onSearchChanged,
    this.onSearchSubmitted,
    required this.suggestionList,
    this.hintText,
  });

  @override
  State<FlowSearchBarWidget> createState() => _FlowSearchBarWidgetState();
}

class _FlowSearchBarWidgetState extends State<FlowSearchBarWidget> {
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

              context.goNamed(
                'flow-view',
                pathParameters: {
                  'flowId': flow.id,
                },
                extra: flow,
              );
              // Navigator.push(
              //   context,
              //   FlowViewPage.route(flow), // Navigate directly to FlowViewPage
              // );
            },
          );
        });
      },
    );
  }
}