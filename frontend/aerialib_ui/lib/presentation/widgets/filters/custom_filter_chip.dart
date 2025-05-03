import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? foregroundColor;

  const CustomFilterChip({
    super.key,
    required this.label,
    this.fontSize = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
    this.backgroundColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.foregroundColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize, color: foregroundColor),
      ),
    );
  }
}