import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppTheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      elevation: 8,
      height: 72,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Tableau de bord',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline_rounded),
          selectedIcon: Icon(Icons.people_rounded),
          label: 'Vendeurs',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart_rounded),
          label: 'Rapports',
        ),
      ],
    );
  }
}

class AdminDrawerWidget extends StatelessWidget {
  final String currentRoute;

  const AdminDrawerWidget({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surface,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  label: 'Tableau de bord',
                  route: AppRoutes.adminDashboardScreen,
                  isActive: currentRoute == AppRoutes.adminDashboardScreen,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_rounded,
                  label: 'Vendeurs',
                  route: AppRoutes.adminPanelScreen,
                  isActive: currentRoute == AppRoutes.adminPanelScreen,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.store_rounded,
                  label: 'Produits',
                  route: AppRoutes.adminPanelScreen,
                  isActive: currentRoute == AppRoutes.adminPanelScreen,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.receipt_long_rounded,
                  label: 'Factures',
                  route: AppRoutes.adminDashboardScreen,
                  isActive: false,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.analytics_rounded,
                  label: 'Analyse IA',
                  route: AppRoutes.adminDashboardScreen,
                  isActive: false,
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                _buildNavItem(
                  context,
                  icon: Icons.settings_rounded,
                  label: 'Paramètres',
                  route: AppRoutes.adminDashboardScreen,
                  isActive: false,
                ),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.secondary],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(102), width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mohammed Karim',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Administrateur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive ? AppTheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: AppTheme.primaryContainer,
          onTap: () {
            Navigator.of(context).pop();
            if (!isActive) Navigator.pushNamed(context, route);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isActive ? AppTheme.primary : AppTheme.muted,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AppTheme.primary
                        : const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.outlineVariant, width: 1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: AppTheme.errorContainer,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreen,
              (route) => false,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                const Icon(
                  Icons.logout_rounded,
                  size: 22,
                  color: AppTheme.error,
                ),
                const SizedBox(width: 14),
                Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
