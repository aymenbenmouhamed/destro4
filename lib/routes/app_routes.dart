import 'package:flutter/material.dart';

import '../presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import '../presentation/admin_panel_screen/admin_panel_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/seller_visit_screen/seller_visit_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String adminDashboardScreen = '/admin-dashboard-screen';
  static const String sellerVisitScreen = '/seller-visit-screen';
  static const String adminPanelScreen = '/admin-panel-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    adminDashboardScreen: (context) => const AdminDashboardScreen(),
    sellerVisitScreen: (context) => const SellerVisitScreen(),
    adminPanelScreen: (context) => const AdminPanelScreen(),
  };
}
