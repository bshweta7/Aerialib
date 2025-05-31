import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/constants.dart';

class InstallPage extends StatelessWidget {
  const InstallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'image': '${Constants.backendUrl}/media/data/default/install_instructions/apple_1.jpg',
        'caption': '1. Tap the Share icon at the bottom of Safari',
      },
      {
        'image': '${Constants.backendUrl}/media/data/default/install_instructions/apple_2.jpg',
        'caption': '2. Scroll down in the share menu',
      },
      {
        'image': '${Constants.backendUrl}/media/data/default/install_instructions/apple_3.jpg',
        'caption': '3. Tap "Add to Home Screen',
      },
      {
        'image': '${Constants.backendUrl}/media/data/default/install_instructions/apple_4.jpg',
        'caption': '4. Edit the name if you like, then tap "Add"',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to Home Screen"),
        backgroundColor: const Color(0xFF3A2E58), // Optional: app's theme
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFBAAEC8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: steps.map((step) {
                  return Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.network(
                                step['image']!,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            step['caption']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1e293b),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 🎉 "You're Done!" message
            const Column(
              // padding: EdgeInsets.symmetric(vertical: 16.0),
              children: [
                Text(
                  "🎉 You're Done!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A2E58),
                  ),
                ),
                Text(
                  "Now you can open Aerialib from your home screen",
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Color(0xFF3A2E58),
                  ),
                ),
                SizedBox(height: 16,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
