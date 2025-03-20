import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  // final List<String> suggestionList;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    this.onSearchSubmitted,
    // required this.suggestionList,
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
        // final suggestions = widget.suggestionList
        //     .where((item) => item.toLowerCase().contains(controller.text.toLowerCase()))
        //     .toList();

        return List<ListTile>.generate(5, (int index){
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        }); // TODO update suggestion builder

        // return List<ListTile>.generate(suggestionList.length, (int index) {
        //   final String item = suggestionList[index];
        //   return ListTile(
        //     title: Text(item),
        //     onTap: () {
        //       setState(() {
        //         controller.closeView(item);
        //       });
        //     },
        //   );
        // });
      },
    );
  }
}