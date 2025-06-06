import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Color? valueColor;

  const InfoRow(this.label, this.value, {this.valueColor, super.key});

  @override
  Widget build(BuildContext context) {
    final hasValue = value?.trim().isNotEmpty == true;
    final displayText = hasValue ? value!.trim() : 'None';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: displayText,
              style: TextStyle(
                fontSize: 18,
                fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                color: hasValue
                    ? (valueColor ?? Colors.black)
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
