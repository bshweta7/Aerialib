import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FormattedVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FormattedVideoPlayer({super.key, required this.videoUrl});

  @override
  State<FormattedVideoPlayer> createState() => _FormattedVideoPlayerState();
}

class _FormattedVideoPlayerState extends State<FormattedVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_controller),
          _ControlsOverlay(controller: _controller),
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.value.isPlaying ? controller.pause() : controller.play(),
      child: Center(
        child: Icon(
          controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
          color: Colors.white.withOpacity(0.8),
          size: 48,
        ),
      ),
    );
  }
}
