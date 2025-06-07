import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> options;
  final bool required;
  final bool enabled;

  const DropdownField(
    this.label,
    this.controller,
    this.options, {
        this.required = false,
        this.enabled = true,
        super.key,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
          onChanged: enabled
              ? (String? newValue) {
            if (newValue != null) {
              controller.text = newValue;
            }
          }
              : null,
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
