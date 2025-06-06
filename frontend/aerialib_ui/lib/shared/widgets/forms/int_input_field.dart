import 'package:flutter/material.dart';

class IntInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool required;

  const IntInputField(
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
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return "$label cannot be empty";
          }

          if (value != null && value.trim().isNotEmpty) {
            final parsed = int.tryParse(value);
            if (parsed == null) {
              return 'Please enter a valid number';
            }
          }
          return null;
        }
      ),
    );
  }
}
