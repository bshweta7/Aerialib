import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/auth/signup_page.dart';

import '../../../core/constants/constants.dart';


class WebLandingPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const WebLandingPage(),
      );
  const WebLandingPage({super.key});

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // NavBar(),
          Expanded(
            child: SingleChildScrollView(// Allows scrolling
              child: Column(
                children: <Widget>[
                  HeroSection(),
                  AboutSection(),
                  ProblemSolutionSection(),
                  KeyFeaturesSection(),
                  TestimonialsSection(),
                  PricingSection(),
                  CallToActionSection(),
                  FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// --- Sections ---

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32.0), // Increased padding for better spacing
      decoration: BoxDecoration(
        color: Constants.darkPurple
      ),
      child: Row(
        // TODO space evenly
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Aerialib",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.05, // Increased font size for "Aerialib"
              fontWeight: FontWeight.w900, // Make it extra bold
              color: Colors.white, // Make it pop with a light color against gradient
            ),
          ),
        ],
      ),
    );
  }
}


class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32.0), // Increased padding for better spacing
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(20),
        color: Constants.midPurple,
        // gradient: LinearGradient(
          // colors: [Constants.darkPurple, Constants.midPurple],
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
          // stops: [0.1, 0.25],
          // tileMode: TileMode.repeated,
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Aerialib",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.08, // Increased font size for "Aerialib"
              fontWeight: FontWeight.w900, // Make it extra bold
              color: Colors.white, // Make it pop with a light color against gradient
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "The All-In-One Aerial Arts Library to Streamline Your Teaching.",
            style: TextStyle(
              fontSize: 28, // Increase tagline font size
              fontWeight: FontWeight.w700, // Make it bold
              color: Colors.white, //Make it pop with light color against gradient
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            "Generate custom flows, manage student progress, and access a comprehensive pose library, all in one place.",
            // "Effortlessly create flows, track student progress, and elevate your studio's experience with the all-in-one aerial arts management app.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70, // Slightly faded for less emphasis
            ),
          ),
          SizedBox(height: 30), // Increased space before button
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, SignupPage.route());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Larger button
              textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white
              ),
            ),
            child: const Text(
              "Get Started!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24
              )
            ),
          ),
          // Add your image or video here
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.7,
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0), // Increased padding for better spacing
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(20),
        color:Constants.backgroundBlue
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "About Aerialib",
            style: TextStyle(
              fontSize: 30, // Increased font size for "Aerialib"
              fontWeight: FontWeight.bold, // Make it extra bold
              color: Colors.black, // Make it pop with a light color against gradient
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Text(
            "Say Goodbye to Tedious Lesson Planning and Student Management.",
            style: TextStyle(
              fontSize: 28, // Increase tagline font size
              fontWeight: FontWeight.w700, // Make it bold
              color: Colors.white, //Make it pop with light color against gradient
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            "Generate custom flows, manage student progress, and access a comprehensive pose library, all in one place.",
            // "Effortlessly create flows, track student progress, and elevate your studio's experience with the all-in-one aerial arts management app.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70, // Slightly faded for less emphasis
            ),
          ),
          SizedBox(height: 30), // Increased space before button
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, SignupPage.route());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Larger button
              textStyle: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            child: const Text("Get Started!"),
          ),
          // Add your image or video here
        ],
      ),
    );
  }
}


class ProblemSolutionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            "Say Goodbye to Tedious Lesson Planning and Student Management.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Problem: ..."), // Add your problem description
          SizedBox(height: 10),
          Text("Solution: ..."), // Add your solution description
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("- Benefit 1"),
              Text("- Benefit 2"),
              // Add other benefits
            ],
          ),
        ],
      ),
    );
  }
}

class KeyFeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            "Powerful Features Designed for Aerial Excellence.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          FeatureBlock(
            title: "Flow Generator",
            description: "Create dynamic and customized flows...",
          ),
          FeatureBlock(
            title: "Pose Library & Tagging",
            description: "Access a comprehensive library...",
          ),
          // Add other FeatureBlock widgets
        ],
      ),
    );
  }
}

class FeatureBlock extends StatelessWidget {
  final String title;
  final String description;

  FeatureBlock({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text("Hear From Aerial Instructors and Studio Owners."),
          // Add testimonial widgets
        ],
      ),
    );
  }
}

class PricingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text("Pricing/Plans"),
          // Add pricing plan widgets
        ],
      ),
    );
  }
}

class CallToActionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle download/trial action
        },
        child: Text("Download Now"),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Text("Contact Info, Social Media Links, etc."),
        ],
      ),
    );
  }
}