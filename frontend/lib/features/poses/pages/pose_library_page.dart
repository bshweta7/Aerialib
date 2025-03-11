import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
// import 'package:frontend/features/home/cubit/tasks_cubit.dart';
// import 'package:frontend/features/home/pages/add_new_task_page.dart';
// import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

// import '../widgets/date_selector.dart';

class PoseLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const PoseLibraryPage(),
      );
  const PoseLibraryPage({super.key});

  @override
  State<PoseLibraryPage> createState() => _PoseLibraryPageState();
}

class _PoseLibraryPageState extends State<PoseLibraryPage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    // context.read<TasksCubit>().getAllTasks(token: user.user.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pose Library"),
          // actions: [
          //   IconButton(
          // TODO hamburger menu or profile/settings on the top right ?
          //       onPressed: () {
          //         Navigator.push(context, AddNewTaskPage.route());
          //       },
          //       icon: const Icon(CupertinoIcons.add,
          //       )
          //   )
          // ]
        ),
        body: Center(
          child: const Text("Pose Library Page is under development. "),
        )

    );
  }
}