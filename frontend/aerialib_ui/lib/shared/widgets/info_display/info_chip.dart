import 'package:flutter/material.dart';

import '../../helpers/formatters.dart';

class InfoChip extends StatelessWidget {
  final String? label;
  final String tooltipMessage;
  final bool isVisible;
  // TODO can take color as param

  const InfoChip({
    super.key,
    required this.label,
    required this.tooltipMessage,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = label?.trim();
    if (!isVisible || trimmed == null || trimmed.isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: tooltipMessage,
      child: Chip(label: Text(capitalizeFirstLetter(trimmed))),
    );
  }
}
