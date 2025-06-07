import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AutoAspectVideo extends StatefulWidget {
  final String videoUrl;
  final BorderRadius borderRadius;

  const AutoAspectVideo({
    super.key,
    required this.videoUrl,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<AutoAspectVideo> createState() => _AutoAspectVideoState();
}

class _AutoAspectVideoState extends State<AutoAspectVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
