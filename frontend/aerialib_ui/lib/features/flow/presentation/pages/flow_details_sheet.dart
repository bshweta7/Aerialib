import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/features/flow/domain/entities/flow_entity.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import '../../../../shared/widgets/info_display/info_row.dart';


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

  Future<void> _confirmDeleteFlow(BuildContext context) async {
    log('[FlowDetailsSheet] Showed confirmation popup');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Flow?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete")
          ),
        ],
      ),
    );

    if (confirmed == true) {
      log('[FlowDetailsSheet] Deleting flow...');
      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthLoggedIn) return;
      final token = authState.user.token;

      await context.read<FlowsCubit>().deleteFlow(
          flowId: flow.id,
          token: token
      );

      log('[FlowDetailsSheet] Re-fetching latest flow list');
      await context.read<FlowsCubit>().getAllFlows(token: token);

      Navigator.pop(context); // Close the bottom sheet
      context.goNamed(
        'flow-library',
        queryParameters: {'from': 'home'},
        // TODO THIS WHOLE PAGE NEEDS A LOT OF TESTING!!!
      ); // Redirect to Flow Library

    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Widget _infoRow(String label, String? value) {
    //   return Padding(
    //     padding: const EdgeInsets.only(bottom: 10),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "$label ",
    //           style: const TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         Expanded(
    //           child: Text(
    //             value?.isNotEmpty == true ? value! : 'None',
    //             style: TextStyle(
    //               fontStyle: value?.isNotEmpty == true
    //                   ? FontStyle.normal
    //                   : FontStyle.italic,
    //               color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

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

        InfoRow("Apparatus:", capitalizeFirstLetter(flow.apparatus)),
        InfoRow("Level:", flow.level!=-1 ?
            "Level ${flow.level}" :
            "None"
        ),
        const Divider(),
        InfoRow("Description:", flow.description),
        InfoRow("Teaching Cues:", flow.teachingCues),
        InfoRow("Safety Cues:", flow.safetyCues),
        InfoRow("Progressions:", flow.progressions),
        InfoRow("Created At:", formatDate(flow.createdAt)),
        InfoRow("Updated At:", formatDate(flow.updatedAt)),
        // TODO add thumbnail picture

        const SizedBox(height: 20),
        if (onEdit != null)
          Center(
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Flow Details"),
            ),
          ),
      ],
    );
  }
}
