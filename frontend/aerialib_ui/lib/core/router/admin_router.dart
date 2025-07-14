import 'package:go_router/go_router.dart';

import '../../features/admin/admin_flows_dashboard_page.dart';
import '../../features/admin/admin_users_dashboard_page.dart';


List<GoRoute> adminRoutes = [
  GoRoute(
    path: '/admin/flows',
    name: 'admin-flows',
    builder: (context, state) => const AdminFlowsDashboardPage(),
  ),
  GoRoute(
    path: '/admin/roster',
    name: 'admin-users',
    builder: (context, state) => const AdminUsersDashboardPage(),
  ),
];