import 'package:flutter/material.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

class FlowDetailsSheet extends StatelessWidget {
  final FlowEntity flow;
  final VoidCallback? onEdit;

  const FlowDetailsSheet({
    super.key,
    required this.flow,
    this.onEdit,
  });

  /// Modal Bottom Sheet launcher
  static Future<void> show({
    required BuildContext context,
    required FlowEntity flow,
    VoidCallback? onEdit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: FlowDetailsSheet(flow: flow, onEdit: onEdit),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _infoRow(String label, String? value) {
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
                value?.isNotEmpty == true ? value! : 'None',
                style: TextStyle(
                  fontStyle: value?.isNotEmpty == true
                      ? FontStyle.normal
                      : FontStyle.italic,
                  color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Text(
          flow.name,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        _infoRow("Apparatus:", capitalizeFirstLetter(flow.apparatus)),
        _infoRow("Level:", "Level ${flow.level}"),
        const Divider(),
        _infoRow("Description:", flow.description),
        _infoRow("Teaching Cues:", flow.teachingCues),
        _infoRow("Safety Cues:", flow.safetyCues),
        _infoRow("Progressions:", flow.progressions),
        // TODO add thumbnail picture

        const SizedBox(height: 20),
        if (onEdit != null)
          Center(
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Flow"),
            ),
          ),
      ],
    );
  }
}
