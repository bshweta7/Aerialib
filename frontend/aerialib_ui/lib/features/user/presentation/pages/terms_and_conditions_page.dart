import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';


class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // TODO should indicate if the user has or has not agreed to the latest terms and conditions

  @override
  Widget build(BuildContext context) {
    log('[TermsAndConditionsPage] Building TermsAndConditionsPage UI');

    return MainScaffold(
      currentIndex: 0,
      scrollController: _scrollController,
      isScrollable: true,
      isScrollbarVisible: false,
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed('user-profile');
            },
            tooltip: "Visit profile page",
            icon: const Icon(CupertinoIcons.profile_circled),
          )
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Version 1.0: Last Updated July 15, 2025",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Text(
                  'This Privacy Notice for Aerialib ("we," "us," or "our"), describes how and why we might access, collect, store, use, and/or share ("process") your personal information when you use our services ("Services"), including when you: \n\t-Visit our website at https://aerialib.com or any website of ours that links to this Privacy Notice\n\t-Download and use our mobile application (Aerialib), or any other application of ours that links to this Privacy Notice\n\t-Use Aerialib. Aerialib is a student management platform for aerial studios. Featuring a comprehensive and editable pose and transition library, a student dashboard, and a flow generator, Aerialib makes it easy to track your students progress and design custom curriculum.\n\t-Engage with us in other related ways, including any sales, marketing, or events',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                const Text(
                  "Questions or concerns?\nReading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at aerialib@outlook.com.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                const Text(
                  "What personal information do we process? \nWhen you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use. Learn more about personal information you disclose to us.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'Do we process any sensitive personal information?\nSome of the information may be considered "special" or "sensitive" in certain jurisdictions, for example your racial or ethnic origins, sexual orientation, and religious beliefs. We do not process sensitive personal information.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "Do we collect any information from third parties?\nWe do not collect any information from third parties.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "How do we process your information?\nWe process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent. We process your information only when we have a valid legal reason to do so. Learn more about how we process your information.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "In what situations and with which parties do we share personal information?\nWe may share information in specific situations and with specific third parties. Learn more about when and with whom we share your personal information.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "How do we keep your information safe?\nWe have adequate organizational and technical processes and procedures in place to protect your personal information. However, no electronic transmission over the internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information. Learn more about how we keep your information safe.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "What are your rights?\nDepending on where you are located geographically, the applicable privacy law may mean you have certain rights regarding your personal information. Learn more about your privacy rights.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "How do you exercise your rights?\nThe easiest way to exercise your rights is by submitting a data subject access request, or by contacting us. We will consider and act upon any request in accordance with applicable data protection laws.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }
}