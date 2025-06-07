import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool required;
  final bool enabled;

  const TextInputField(
    this.label,
    this.controller, {
      this.maxLines = 1,
      this.required = false,
      this.enabled = true,
      super.key,
    }
  );

  // TODO optional info buttons that show details when you hover for each entry - also for other input field widgets

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }
}
