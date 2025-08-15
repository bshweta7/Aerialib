// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:frontend/core/services/http_service.dart';
// import 'package:frontend/shared/widgets/main_scaffold.dart';
// import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
// import 'package:frontend/shared/widgets/search_bar.dart';
// import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
// import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
//
// import 'package:frontend/features/user/data/models/user_model.dart';
// import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';
// import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
// import 'package:frontend/features/admin/data/admin_repository.dart';
//
// class StudentLibraryPage extends StatefulWidget {
//   const StudentLibraryPage({super.key});
//
//   @override
//   State<StudentLibraryPage> createState() => _StudentLibraryPageState();
// }
//
// class _StudentLibraryPageState extends State<StudentLibraryPage> {
//   final ScrollController _scrollController = ScrollController();
//   late final AdminRepository _repo;
//   List<UserModel> _allStudents = [];
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _repo = AdminRepository(httpService: HttpService());
//     final user = context.read<AuthCubit>().state as AuthLoggedIn;
//     _loadStudents(user.user.token);
//   }
//
//   Future<void> _loadStudents(String token) async {
//     final students = await _repo.getAllUsers(token: token);
//     setState(() {
//       _allStudents = students.where((u) => u.accountType == 'student').toList();
//     });
//   }
//
//   void _navigateToStudentProfile(UserModel student) {
//     context.goNamed(
//       'student-profile',
//       pathParameters: {'userId': student.id},
//     );
//   }
//
//   List<MediaIconEntity> _studentsToMediaIcons(List<UserModel> students) {
//     return students.map((s) {
//       return MediaIconEntity(
//         data: s,
//         id: s.id,
//         title: s.username ?? "${s.firstName} ${s.lastName}",
//         subtitle: s.email ?? '',
//         imageUrl: null, // Replace with profile photo if you have one
//         caption: 'Student',
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final filtered = _allStudents.where((s) {
//       final fullName = "${s.firstName} ${s.lastName}".toLowerCase();
//       return fullName.contains(_searchQuery.toLowerCase()) ||
//           (s.username ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
//     }).toList();
//
//     final mediaIcons = _studentsToMediaIcons(filtered);
//
//     return MainScaffold(
//       isScrollable: false,
//       currentIndex: 3,
//       appBar: AppBar(
//         leading: const SmartBackButton(),
//         title: const Text("Student Roster"),
//       ),
//       body: Column(
//         children: [
//           /// Search bar
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//             child: LibrarySearchBar<UserModel>(
//               hintText: 'Search Students',
//               suggestions: _allStudents,
//               getDisplayText: (s) => s.username ?? "${s.firstName} ${s.lastName}",
//               onSearchChanged: (query) => setState(() => _searchQuery = query),
//             ),
//           ),
//
//           /// Student list
//           Expanded(
//             child: Stack(
//               children: [
//                 if (mediaIcons.isEmpty)
//                   const Center(child: Text("No students match your search"))
//                 else
//                   Padding(
//                     padding: const EdgeInsets.only(right: 1),
//                     child: MediaList(
//                       mediaItems: mediaIcons,
//                       onMediaTap: (mediaItem) =>
//                           _navigateToStudentProfile(mediaItem.data as UserModel),
//                       scrollController: _scrollController,
//                     ),
//                   ),
//                 ScrollToTopButton(scrollController: _scrollController),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
