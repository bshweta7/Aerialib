import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/http_service.dart';
import 'package:frontend/features/user/legacy/user_model.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import '../../../shared/features/navigation/widgets/smart_back_button.dart';
import '../../../shared/widgets/info_display/info_row.dart';
import '../../../shared/widgets/main_scaffold.dart';
import '../../user/presentation/cubit/auth_cubit.dart';
import '../data/admin_flow_model.dart';
import '../data/admin_repository.dart';

class AdminFlowsDashboardPage extends StatefulWidget {
  const AdminFlowsDashboardPage({super.key});

  @override
  State<AdminFlowsDashboardPage> createState() => _AdminFlowsDashboardPageState();
}

class _AdminFlowsDashboardPageState extends State<AdminFlowsDashboardPage> {
  final ScrollController _scrollController = ScrollController();
  late final AdminRepository _repo;
  late Future<List<AdminFlowModel>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _repo = AdminRepository(httpService: HttpService());
    final adminFlow = context.read<AuthCubit>().state as AuthLoggedIn;

    _dashboardFuture = _loadData(adminFlow.user.token);
  }

  Future<List<AdminFlowModel>> _loadData(String token) async {
    return await _repo.getAllFlows(token: token);
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
          leading: const SmartBackButton(),
          title: const Text("Admin Flows Dashboard")
      ),
      body: FutureBuilder<List<AdminFlowModel>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          final flows = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: flows.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ExpandableCard(
                  title: "${f.createdBy ?? "Unknown"} | ${f.name ?? "Unknown"}",
                  children: [
                    InfoRow("Number of Poses:", "${f.numPoses}"),
                    InfoRow("Apparatus:", f.apparatus),
                    // InfoRow("Id:", f.id),
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
