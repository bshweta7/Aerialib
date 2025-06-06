import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final hasValue = value?.trim().isNotEmpty == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              hasValue ? value! : 'None',
              style: TextStyle(
                fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                color: hasValue ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
