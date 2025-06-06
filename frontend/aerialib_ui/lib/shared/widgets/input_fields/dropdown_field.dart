import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> options;
  final bool required;

  const DropdownField(
    this.label,
    this.controller,
    this.options, {
        this.required = false,
        super.key,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.text = newValue;
          }
        },
        items: options.map((lowerValue) {
          final displayLabel =
              lowerValue[0].toUpperCase() + lowerValue.substring(1);
          return DropdownMenuItem(
            value: lowerValue,
            child: Text(displayLabel),
          );
        }).toList(),
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
             return '$label cannot be empty';
          }
        }
      ),
    );
  }
}
