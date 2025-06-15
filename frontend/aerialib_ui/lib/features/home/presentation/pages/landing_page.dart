// import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
//
// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '🌀 Aerialib',
//               // style: GoogleFonts.playfairDisplay(
//               //   fontSize: 36,
//               //   fontWeight: FontWeight.bold,
//               // ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Design. Track. Master.',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Your personal aerial flow builder and training companion.',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 48),
//             _SectionTitle('🎯 For aerial students who want more than just watching videos.'),
//             const SizedBox(height: 8),
//             Text(
//               "Aerialib isn’t a class subscription. It’s a creative toolset built for hoop artists, flow seekers, and instructors who want to plan routines, track progress, and stay inspired — even offline.",
//             ),
//             const SizedBox(height: 32),
//             _Feature(
//               emoji: '🧩',
//               title: 'Build your own flows',
//               description: 'Drag, drop, and organize poses and transitions into custom sequences with pose order, grip types, and notes.',
//             ),
//             _Feature(
//               emoji: '🖼️',
//               title: 'See your progress at a glance',
//               description: 'Track what you’ve tried, what you’ve mastered, and what you want to learn next — complete with tags, media, and personal notes.',
//             ),
//             _Feature(
//               emoji: '📸',
//               title: 'Upload your own media',
//               description: 'Use your own training photos or reference videos. Keep your journey visual, searchable, and organized.',
//             ),
//             _Feature(
//               emoji: '🪄',
//               title: 'Plan smarter, not longer',
//               description: 'Prep for class or train solo without losing track of combos or scribbling down notes.',
//             ),
//             _Feature(
//               emoji: '🌐',
//               title: 'Works offline too',
//               description: 'Train wherever you fly — Aerialib works without internet.',
//             ),
//             const SizedBox(height: 32),
//             _SectionTitle('🧠 Built by an aerialist, for aerialists'),
//             const SizedBox(height: 8),
//             Text(
//               '“I created Aerialib because I couldn’t find a tool that helped me organize my skills and create flows without losing track of everything. I wanted something flexible, fast, and fun to use — something that actually matched how aerialists think.”\n– Shweta, founder of Aerialib',
//             ),
//             const SizedBox(height: 32),
//             _SectionTitle('🚀 Join the early access list'),
//             const SizedBox(height: 8),
//             Text('We\'re rolling out Aerialib to a small group of students and instructors first. Want in?'),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Email address',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('Join the waitlist'),
//             ),
//             const SizedBox(height: 32),
//             _SectionTitle('✅ Ready to test it now?'),
//             const SizedBox(height: 8),
//             Text('If you\'re a coach, studio owner, or dedicated student, we\'d love your feedback.'),
//             const SizedBox(height: 12),
//             OutlinedButton(
//               onPressed: () {},
//               child: const Text('Apply for early testing access'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _Feature extends StatelessWidget {
//   final String emoji;
//   final String title;
//   final String description;
//
//   const _Feature({required this.emoji, required this.title, required this.description});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('$emoji ', style: const TextStyle(fontSize: 20)),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(description),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SectionTitle extends StatelessWidget {
//   final String text;
//
//   const _SectionTitle(this.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//     );
//   }
// }






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
