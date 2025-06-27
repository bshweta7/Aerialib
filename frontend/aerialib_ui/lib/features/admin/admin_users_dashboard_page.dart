import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/http_service.dart';
import 'package:frontend/features/user/data/models/user_model.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import '../../shared/widgets/info_display/info_row.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../user/presentation/cubit/auth_cubit.dart';
import 'admin_repository.dart';

class AdminUsersDashboardPage extends StatefulWidget {
  const AdminUsersDashboardPage({super.key});

  @override
  State<AdminUsersDashboardPage> createState() => _AdminUsersDashboardPageState();
}

class _AdminUsersDashboardPageState extends State<AdminUsersDashboardPage> {
  final ScrollController _scrollController = ScrollController();
  late final AdminRepository _repo;
  late Future<List<UserModel>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _repo = AdminRepository(httpService: HttpService());
    final adminUser = context.read<AuthCubit>().state as AuthLoggedIn;

    _dashboardFuture = _loadData(adminUser.user.token);
  }

  Future<List<UserModel>> _loadData(String token) async {
    final users = await _repo.getAllUsers(token: token);
    return users;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      appBar: AppBar(
        title: const Text("Admin Users Dashboard")
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          final users = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: users.map((u) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ExpandableCard(
                  title: u.username ?? "Unknown",
                  children: [
                    InfoRow("Email:", u.email),
                    InfoRow("Name:", "${u.firstName} ${u.lastName}"),
                    InfoRow("Last login:", "${u.lastLogin ?? 'Never'}"),
                    // if (u.isAdmin == true) const Text("Admin", style: TextStyle(color: Colors.deepPurple)),
                  ],
                ),
              )).toList(),
            ),
          );
        },
      ),
    );
  }
}
