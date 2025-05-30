import 'package:flutter/material.dart';

class QuickAddMusicCard extends StatefulWidget {
  final Function(String name, String description, bool isFavorite) onSubmit;

  const QuickAddMusicCard({super.key, required this.onSubmit});

  @override
  State<QuickAddMusicCard> createState() => _QuickAddMusicCardState();
}

class _QuickAddMusicCardState extends State<QuickAddMusicCard> {
  bool _isExpanded = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isFavorite = false;

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isNotEmpty) {
      widget.onSubmit(name, description, _isFavorite);
      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _isFavorite = false;
        _isExpanded = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Song Name",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isExpanded
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Quick add song',
                  onPressed: _handleSubmit,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _isFavorite,
                    onChanged: (val) {
                      setState(() => _isFavorite = val ?? false);
                    },
                  ),
                  const Text("Mark as Favorite"),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
