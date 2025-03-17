import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
// import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/poses/pages/pose_library_page.dart';
// import 'package:frontend/features/home/pages/add_new_task_page.dart';
// import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          title: const Text("My Dashboard"),
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
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Navigation",
                    style: TextStyle(
                      fontSize:50,
                      fontWeight: FontWeight.bold,
                    )
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(PoseLibraryPage.route());
                    },
                    child: const Text(
                        'Pose Library',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )
                    )
                ),

                const SizedBox(height:15),
                const Text("Dashboard is under development. "),

              ]
          ),
        )



      // BlocBuilder<TasksCubit, TasksState>(
      //   builder: (context, state) {
      //     if (state is TaskLoading) {
      //       return const Center(child: CircularProgressIndicator(),);
      //     }
      //     if (state is TaskError) {
      //       print("AAACK ERROR");
      //       return Center(child: Column(
      //         children: [
      //           Text("AAACK We got an error :("),
      //           Text(state.error),
      //         ],
      //       ),);
      //     }
      //     if (state is GetTasksSuccess) {
      //       final tasks = state.tasks.where(
      //               (elem) =>
      //           DateFormat('d').format(elem.dueAt) == DateFormat('d').format(selectedDate) &&
      //               selectedDate.month == elem.dueAt.month &&
      //               selectedDate.year == elem.dueAt.year
      //       ).toList();
      //
      //       print(tasks);
      //
      //       return Column(
      //           children: [
      //             DateSelector(
      //                 selectedDate: selectedDate,
      //                 onTap: (date) {
      //                   setState(() {
      //                     selectedDate = date;
      //                   });
      //                 }
      //             ),
      //             Expanded(
      //               child: ListView.builder(
      //                   itemCount: tasks.length,
      //                   itemBuilder: (context, index) {
      //                     final task = tasks[index];
      //                     return Row(
      //                       children: [
      //                         Expanded(
      //                           child: TaskCard(
      //                               color: task.color,
      //                               headerText: task.title,
      //                               descriptionText: task.description
      //                           ),
      //                         ),
      //                         Container(
      //                           height: 10,
      //                           width: 10,
      //                           decoration: BoxDecoration(
      //                             color: strengthenColor(
      //                               task.color,
      //                               0.69,
      //                             ),
      //                             shape: BoxShape.circle,
      //                           ),
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.all(12.0),
      //                           child: Text(
      //                               DateFormat.jm().format(task.dueAt),
      //                               style: const TextStyle(
      //                                 fontSize: 17,
      //                               )
      //                           ),
      //                         )

      //                       ],
      //                     );
      //                   }
      //               ),
      //             )
      //           ]
      //       );
      //     }
      //     return const SizedBox();
      //   },
      // )
    );
  }
}