import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFBAAEC8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Aerialib",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1e293b),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "The smarter way to organize aerial flows",
              // "The smarter way to plan and teach aerial classes.\nDesigned for studio owners.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => context.goNamed('login'),
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: const Color(0xFF3b82f6),
                    //   padding: const EdgeInsets.symmetric(vertical: 16),
                    //   textStyle: const TextStyle(fontSize: 18),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    // ),
                    child: const Text('Log In'),
                  ),
                ),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => context.goNamed('signup'),
                    // style: OutlinedButton.styleFrom(
                    //   foregroundColor: const Color(0xFF3b82f6),
                    //   side: const BorderSide(color: Color(0xFF3b82f6), width: 2),
                    //   padding: const EdgeInsets.symmetric(vertical: 16),
                    //   textStyle: const TextStyle(fontSize: 18),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    // ),
                    child: const Text('Sign Up'),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pushNamed('install'),
                  child: const Text(
                    "How to Add Aerialib to Your Home Screen",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1e293b),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

              ],
            ),
            const Spacer(),
            const Text(
              "© 2025 Aerialib. All rights reserved.",
              style: TextStyle(color: Color(0xFF1e293b)),
            ),
          ],
        ),
      ),
    );
  }
}
