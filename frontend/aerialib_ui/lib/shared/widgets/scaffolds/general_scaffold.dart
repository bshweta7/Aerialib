import 'package:flutter/material.dart';

class GeneralScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const GeneralScaffold({
    super.key,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9084AF),
              // Color(0xFFBDB4D7),
              Color(0xFFDAD2EE),
              Color(0xFFBDB4D7),
              Color(0xFF9084AF),
              // Color(0xFF9084AF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: body,
      ),
    );
  }
}