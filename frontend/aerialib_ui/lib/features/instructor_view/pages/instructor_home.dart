import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/features/navigation/widgets/smart_back_button.dart';

class InstructorHomePage extends StatefulWidget {
  const InstructorHomePage({super.key});

  @override
  State<InstructorHomePage> createState() => _InstructorHomePageState();
}

class _InstructorHomePageState extends State<InstructorHomePage> {

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isScrollable: false,
      currentIndex: 0,
      appBar: AppBar( // TODO add appBar to mainScaffold
          leading: const SmartBackButton(),
          title: const Text("Instructor Home Page"), // TODO change to "welcome UserName" like home page, because it will direct route to here
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Welcome back, Instructor!'),
          SizedBox(height: 16),
          Text('Next steps:'),
          Text('• View students'),
          Text('• Open pose library'),
          Text('• (Later) See upcoming classes'),
        ],
      ),
    );
  }
}
