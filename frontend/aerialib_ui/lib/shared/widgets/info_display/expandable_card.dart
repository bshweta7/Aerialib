import 'package:flutter/material.dart';

class ExpandableCard extends StatelessWidget {
  final String title;
  final bool initiallyExpanded;
  final List<Widget> children;

  const ExpandableCard({
    super.key,
    required this.title,
    this.initiallyExpanded = false,
    required this.children,
  });

  // TODO optional subtitles to explain the card title

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      initiallyExpanded: initiallyExpanded,
      children: children,
    );
  }
}
