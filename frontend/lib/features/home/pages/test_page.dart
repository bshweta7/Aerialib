import 'package:flutter/material.dart';

// NOTE: this page is reserved for quick-testing features
// TESTING REORDERABLE WIDGETS

class TestPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const TestPage(),
      );
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  final TextEditingController _textController = TextEditingController();

  void _addItem(String newItem) {
    setState(() {
      items.add(newItem);
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reorderable List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(labelText: 'New Item'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _addItem(_textController.text);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView(
              children: items.map((item) {
                return ListTile(
                  key: ValueKey(item),
                  title: Text(item),
                  leading: Icon(Icons.drag_handle),
                );
              }).toList(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}