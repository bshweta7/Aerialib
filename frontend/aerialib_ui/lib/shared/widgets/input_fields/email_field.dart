import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const EmailField({
    super.key,
    required this.controller,
    this.label = "Email",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Email field cannot be empty!";
        }
        if (!value.contains('@') || !value.contains('.')) {
          return "Please enter a valid email address.";
        }
        return null;
      },
    );
  }
}
