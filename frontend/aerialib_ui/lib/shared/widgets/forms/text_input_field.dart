import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool required;

  const TextInputField(
    this.label,
    this.controller, {
      this.maxLines = 1,
      this.required = false,
      super.key,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
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
