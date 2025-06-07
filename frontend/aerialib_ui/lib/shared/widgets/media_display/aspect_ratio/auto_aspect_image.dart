import 'package:flutter/material.dart';

class AutoAspectImage extends StatefulWidget {
  final String imageUrl;
  final BorderRadius borderRadius;

  const AutoAspectImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<AutoAspectImage> createState() => _AutoAspectImageState();
}

class _AutoAspectImageState extends State<AutoAspectImage> {
  double? aspectRatio;

  @override
  void initState() {
    super.initState();

    final image = Image.network(widget.imageUrl);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        final width = info.image.width.toDouble();
        final height = info.image.height.toDouble();

        if (mounted) {
          setState(() {
            aspectRatio = width / height;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (aspectRatio == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: aspectRatio!,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
