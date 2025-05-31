import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:frontend/core/services/http_service.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';

class LogoPollPage extends StatelessWidget {
  const LogoPollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      appBar: AppBar(title: const Text("Help Pick a Logo!")),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: LogoPollContent(),
        ),
      ),
    );
  }
}

class LogoPollContent extends StatefulWidget {
  const LogoPollContent({super.key});

  @override
  State<LogoPollContent> createState() => _LogoPollContentState();
}

class _LogoPollContentState extends State<LogoPollContent> {
  bool _submitting = false;
  String? _selectedLabel;
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, String>> logoOptions = [
    {"label": "A", "url": "${Constants.backendUrl}/media/data/default/logo_options/clouds_a.png"},
    {"label": "B", "url": "${Constants.backendUrl}/media/data/default/logo_options/clouds_b.png"},
    {"label": "C", "url": "${Constants.backendUrl}/media/data/default/logo_options/books_a.png"},
    {"label": "D", "url": "${Constants.backendUrl}/media/data/default/logo_options/books_b.png"},
  ];

  Future<void> _submitVote() async {
    if (_submitting || _selectedLabel == null) return;

    setState(() => _submitting = true);

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthLoggedIn) return;

    final token = authState.user.token;
    final notes = _notesController.text.trim();
    final message = "[LogoPoll] Choice $_selectedLabel${notes.isNotEmpty ? ": $notes" : ""}";

    final body = {
      "type": "poll",
      "message": message,
      "email": "",
    };

    try {
      final response = await HttpService().post(
        path: "/feedback",
        token: token,
        body: body,
      );

      if (response.statusCode == 201 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thanks for voting!")),
        );
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit vote: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Which logo do you like best?\nTap to select, then submit your vote.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: logoOptions.map((option) {
              final isSelected = _selectedLabel == option["label"];
              return InkWell(
                onTap: () => setState(() => _selectedLabel = option["label"]),
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: option["url"]!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 50, color: Colors.red),
                      ),
                    ),
                    if (isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Logo ${option["label"]!}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: "Optional: What made you choose it?",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: (_selectedLabel == null || _submitting) ? null : _submitVote,
          child: _submitting
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text("Submit Vote"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
