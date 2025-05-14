// TODO make _infoRow a separate widget, search for _infoRow and replace it.

// import 'package:flutter/material.dart';
//
// class FlowHelpDialog extends StatelessWidget {
//   const FlowHelpDialog({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('How to Use'),
//       content: const SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _HelpItem(
//               icon: Icons.search,
//               text: 'Tap the search bar to find and add poses.',
//             ),
//             _HelpItem(
//               icon: Icons.swipe,
//               text: 'Swipe left on a pose to remove it.',
//             ),
//             _HelpItem(
//               icon: Icons.drag_indicator,
//               text: 'Drag poses up/down to reorder them.',
//             ),
//             _HelpItem(
//               icon: Icons.info_outline,
//               text: 'Tap a pose to view its details.',
//             ),
//             _HelpItem(
//               icon: Icons.save,
//               text: 'Tap "Save Changes" to update the flow.',
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           child: const Text('Got it'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }
// }
//
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
