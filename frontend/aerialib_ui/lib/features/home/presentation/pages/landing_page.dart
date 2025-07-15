import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_image.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// TODO add google fonts

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerPadding = screenWidth < 900 ? 10 : screenWidth * 0.2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(vertical: 12),

        child: Column(
          children: [
            /// Title Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF78658F),
                    Color(0xFF624D7B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 36,
                          width: 36,
                          child: FormattedImage(
                              'default/aerialib_logo_v1.png')
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Aerialib",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfff4f4f4),
                          // color: Color(0xFF1e293b),
                        ),
                      ),
                      // TODO add signup / login right aligned
                    ],
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.goNamed('login'),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 48,
                  //   child: ElevatedButton(
                  //     onPressed: () => context.goNamed('signup'),
                  //     child: const Text(
                  //       'SIGN UP',
                  //       style: TextStyle(fontSize: 18),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       width: 100,
                  //       height: 48,
                  //       child: ElevatedButton(
                  //         onPressed: () => context.goNamed('login'),
                  //         child: const Text(
                  //           'LOG IN',
                  //           style: TextStyle(fontSize: 18),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //
                  //     SizedBox(
                  //       width: double.infinity,
                  //       height: 48,
                  //       child: ElevatedButton(
                  //       onPressed: () => context.goNamed('signup'),
                  //         child: const Text(
                  //           'LOG IN',
                  //           style: TextStyle(fontSize: 18),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(height: 16),
                  //
                  //     // TextButton.icon(
                  //     //   onPressed: () => context.goNamed('login'),
                  //     //   icon: const Icon(Icons.info_outline, size: 0, color: Colors.grey),
                  //     //   label: const Text(
                  //     //     'Login',
                  //     //     style: TextStyle(
                  //     //       fontSize: 20,
                  //     //       // fontWeight: FontWeight.bold,
                  //     //       color: Color(0xfff4f4f4),
                  //     //       // color: Color(0xFF1e293b),
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     // const Text(
                  //     //   "/",
                  //     //   style: TextStyle(
                  //     //     fontSize: 20,
                  //     //     fontWeight: FontWeight.bold,
                  //     //     color: Color(0xfff4f4f4),
                  //     //     // color: Color(0xFF1e293b),
                  //     //   ),
                  //     // ),
                  //     // TextButton.icon(
                  //     //   onPressed: () => context.goNamed('signup'),
                  //     //   icon: const Icon(Icons.info_outline, size: 0, color: Colors.grey),
                  //     //   label: const Text(
                  //     //     'Sign Up',
                  //     //     style: TextStyle(
                  //     //       fontSize: 20,
                  //     //       // fontWeight: FontWeight.bold,
                  //     //       color: Color(0xfff4f4f4),
                  //     //       // color: Color(0xFF1e293b),
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ]
                  // )

                ],
              ),
            ),

            /// Splash
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 40.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEDE7F6),
                    Color(0xFFDED3EC),

                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       flex: 3,
                  //       child: Text(
                  //         // "Let your aerial \njourney take off",
                  //         "Create aerial flows with ease",
                  //         style: TextStyle(
                  //           fontSize: 32,
                  //           fontWeight: FontWeight.bold,
                  //           color: Color(0xFF1e293b),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 24),
                  //     SizedBox(
                  //       height: 80,
                  //       width: 80,
                  //       child: FormattedCachedNetworkImage(
                  //           'default/butterfly.png'),
                  //     ),
                  //     // Optional butterfly icon beside logo
                  //     // const SizedBox(width: 8),
                  //     // const Icon(Icons.flutter_dash, color: Colors.deepPurple),
                  //   ],
                  // ),
                  const Text(
                    // "Let your aerial \njourney take off",
                    "Create aerial flows with ease",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e293b),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Online pose library and flow creation tools for aerialists",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF475569),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// CTA
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.goNamed('login'), // TODO change this back to sign up or demo
                      style: ElevatedButton.styleFrom(
                      //   backgroundColor: const Color(0xFF9383B6), // soft purple
                      //   foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontSize: 24,),
                      //   // fontWeight: FontWeight.w600),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ),
                ],
              ),
            ),

            _divider(),

            Container(
              padding: EdgeInsets.symmetric(horizontal: containerPadding),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFDED3EC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Problem Statement
                  _section(
                    title: "Designing flows should be fun",
                    body: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Scribbled notes, 300 screenshots, and a brain full of "ooh I should try that"... but still no flow.'),
                        SizedBox(height: 8),
                        Text("Starting is overwhelming. Transitions are confusing."),
                        SizedBox(height: 8),
                        Text(
                            "Aerialib helps you organize your ideas, discover smooth transitions, and design a flow you’re proud to perform.",
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),

                  /// Intro to Aerialib
                  _section(
                    title: "How can Aerialib help?",
                    body: const Column(
                      children: [
                        Text(
                            "Aerialib is a creative toolset designed to help you build professional quality flows with ease"
                          // "It’s a creative toolset built for hoop artists, flow seekers, and instructors who want to plan routines, track progress, and stay inspired — even offline."
                        ),
                        _Feature(
                          emoji: '🧩',
                          title: 'Flow Creator',
                          description: 'Easily add, remove, and reorder poses to your flow',
                        ),
                        _Feature(
                          emoji: '📚',
                          title: 'Pose Library',
                          description: "Re-discover forgotten poses using the pose library's search or filtering tools",
                        ),
                        _Feature(
                          emoji: '🔄',
                          title: 'Transition Suggestions',
                          description: 'Find poses using the library of known transitions from one pose to the next',
                        ),
                        _Feature(
                          emoji: '🎵',
                          title: 'Holistic Tools',
                          description: 'Quickly jot down song ideas or notes.',
                        ),
                        _Feature(
                          emoji: '🌐',
                          title: 'Works offline too',
                          description: 'Train wherever you fly — Aerialib works without internet.',
                        ),
                      ],
                    ),
                  ),


                  /// Final
                  _section(
                    title: "Built by aerialists, for aerialists",
                    body: Column(
                      children: [
                        const Text(
                            "Aerialib was developed in collaboration with Uplift Aerial Arts."
                        ),
                        const SizedBox(
                            height: 150,
                            width: 200,
                            child: FormattedImage('default/uplift.jpg')
                        ),
                        TextButton(
                          onPressed: () => context.pushNamed('install'),
                          child: const Text(
                            "Click to Add Aerialib to Your Home Screen",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1e293b),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),


                  // const SizedBox(height: 32),
                  // _SectionTitle('🧠 Built by an aerialist, for aerialists'),
                  // const SizedBox(height: 8),
                  // Text(
                  //   '“I created Aerialib because I couldn’t find a tool that helped me organize my skills and create flows without losing track of everything. I wanted something flexible, fast, and fun to use — something that actually matched how aerialists think.”\n– Shweta, founder of Aerialib',
                  // ),
                  // const SizedBox(height: 32),
                  // _SectionTitle('🚀 Join the early access list'),
                  // const SizedBox(height: 8),
                  // Text('We\'re rolling out Aerialib to a small group of students and instructors first. Want in?'),
                  // const SizedBox(height: 16),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Email address',
                  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  //   ),
                  // ),
                  // const SizedBox(height: 12),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: const Text('Join the waitlist'),
                  // ),
                  // const SizedBox(height: 32),
                  // _SectionTitle('✅ Ready to test it now?'),
                  // const SizedBox(height: 8),
                  // Text('If you\'re a coach, studio owner, or dedicated student, we\'d love your feedback.'),
                  // const SizedBox(height: 12),
                  // OutlinedButton(
                  //   onPressed: () {},
                  //   child: const Text('Apply for early testing access'),
                  // ),
                ],
              ),
            ),

            /// Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF78658F),
                    Color(0xFF624D7B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Text(
                      "Contact: aerialib@outlook.com",
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                        color: Color(0xfff4f4f4),
                      ),
                    ),
              ),
              ),

              // child: const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // SizedBox(
              //     //     height: 48,
              //     //     width: 48,
              //     //     child: FormattedCachedNetworkImage(
              //     //         'default/aerialib_logo_v1.png')
              //     // ),
              //     // SizedBox(width: 10),
              //     Text(
              //       "Aerialib",
              //       style: TextStyle(
              //         fontSize: 24,
              //         // fontWeight: FontWeight.bold,
              //         color: Color(0xfff4f4f4),
              //       ),
              //     ),
              //     // Text(
              //     //   "Copyright 2025",
              //     //   style: TextStyle(
              //     //     fontSize: 24,
              //     //     fontWeight: FontWeight.bold,
              //     //     color: Color(0xffd2d2d2),
              //     //   ),
              //     // ),
              //     Text(
              //       "Contact: aerialib@outlook.com",
              //       style: TextStyle(
              //         fontSize: 24,
              //         // fontWeight: FontWeight.bold,
              //         color: Color(0xfff4f4f4),
              //       ),
              //     ),
              //
              //   ],
              // ),

          ],
        ),
      ),
    );
  }


  // TODO move this to another page
  Widget _divider() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE6E6E6),
              Color(0xFFF6F6F6),
              Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const SizedBox(height: 10)
    );
  }

  Widget _section({required String title, required Widget body}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        width: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xFFFFFFFF), Color(0xFFF0ECFF)],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            body,
          ],
        ),
      ),
    );
  }
}




class _Feature extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _Feature({required this.emoji, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji ', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}



