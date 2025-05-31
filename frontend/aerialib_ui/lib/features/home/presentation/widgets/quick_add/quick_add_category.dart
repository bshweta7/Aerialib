import 'package:flutter/material.dart';
import 'package:frontend/features/home/presentation/widgets/quick_add/quick_add_music.dart';

class QuickAddCategoryCard extends StatelessWidget {
  final void Function(String name, String description, bool isFavorite) onMusicSubmit;

  const QuickAddCategoryCard({
    super.key,
    required this.onMusicSubmit,
  });

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$label feature coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Color(0xFFF2EFF6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                "Quick Add",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600; // TODO adjust this so it works for phones
                final showText = constraints.maxWidth > 500;

                return isNarrow
                    ? Column(
                  children: [
                    QuickAddMusicCard(onSubmit: onMusicSubmit),
                    const SizedBox(height: 16),
                    // TODO add back button column
                    // _buildButtonColumn(context, showText),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: QuickAddMusicCard(onSubmit: onMusicSubmit),
                    ),
                    // TODO add back button column
                    // const SizedBox(width: 24),
                    // Flexible(
                    //   flex: 1,
                    //   child: _buildButtonColumn(context, showText),
                    // ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonColumn(BuildContext context, bool showText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _quickAddButton(
          context,
          icon: Icons.fitness_center,
          label: "Session",
          showText: showText,
        ),
        const SizedBox(height: 12),
        _quickAddButton(
          context,
          icon: Icons.photo_library,
          label: "Media",
          showText: showText,
        ),
        const SizedBox(height: 12),
        _quickAddButton(
          context,
          icon: Icons.auto_stories,
          label: "Flow",
          showText: showText,
        ),
      ],
    );
  }

  Widget _quickAddButton(BuildContext context,
      {required IconData icon, required String label, required bool showText}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: showText ? Text("Add $label") : const SizedBox.shrink(),
      onPressed: () => _showComingSoon(context, label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
    );
  }
}
