import 'package:flutter/material.dart';

class FlowHelpDialog extends StatelessWidget {
  const FlowHelpDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const FlowHelpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('How to Use'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpItem(
              icon: Icons.search,
              text: 'Tap the search bar to find and add poses.',
            ),
            _HelpItem(
              icon: Icons.swipe,
              text: 'Swipe left on a pose to remove it.',
            ),
            _HelpItem(
              icon: Icons.drag_indicator,
              text: 'Drag poses up/down to reorder them.',
            ),
            _HelpItem(
              icon: Icons.info_outline,
              text: 'Tap a pose to view its details.',
            ),
            _HelpItem(
              icon: Icons.save,
              text: 'Tap "Save Changes" to update the flow.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Got it'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HelpItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
