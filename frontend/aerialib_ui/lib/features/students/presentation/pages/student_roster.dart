import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import 'package:frontend/shared/helpers/conversions.dart';

import '../../../../shared/widgets/media_display/cards/list_card.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../domain/student_entity.dart';
import '../cubit/students_cubit.dart';

class StudentLibraryPage extends StatefulWidget {
  const StudentLibraryPage({super.key});

  @override
  State<StudentLibraryPage> createState() => _StudentLibraryPageState();
}

class _StudentLibraryPageState extends State<StudentLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  List<StudentEntity> _allStudent = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    if (!mounted) return;
    context.read<StudentsCubit>().getAllStudents(token: user.user.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToStudentPage(MediaIconEntity mediaItem) {
    context.goNamed(
      'student-view',
      pathParameters: {'studentId': mediaItem.data.id},
      queryParameters: {'from': 'student-library'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AuthCubit>().state;
    final userToken = (userState is AuthLoggedIn) ? userState.user.token : null;

    return MainScaffold(
      isScrollable: false,
      currentIndex: 0, // TODO move this to a "media" tab instead of home
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Student Ideas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.goNamed(
                'add-new-student',
                queryParameters: {'from': 'student-library'},
              );
            },
            tooltip: 'Add new song',
          ),
        ],
      ),
      body: BlocBuilder<StudentsCubit, StudentsState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is GetStudentsSuccess) {
            _allStudent = state.students;

            return Column(
              children: [

                Expanded(
                  child: Stack(
                    children: [
                      if (_allStudent.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "No students yet, try adding one!",
                              style: TextStyle(fontSize: 16, color: Colors.black38),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          // controller: scrollController,
                          itemCount: _allStudent.length,
                          itemBuilder: (context, index) {
                            final student = _allStudent[index];

                            Text(student.name);

                          },
                          cacheExtent: 600.0,
                        )
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
