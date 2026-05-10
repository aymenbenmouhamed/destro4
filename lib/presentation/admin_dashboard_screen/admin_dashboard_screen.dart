import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/loading_skeleton_widget.dart';
import './widgets/dashboard_ai_insight_widget.dart';
import './widgets/dashboard_kpi_grid_widget.dart';
import './widgets/dashboard_low_stock_widget.dart';
import './widgets/dashboard_revenue_chart_widget.dart';
import './widgets/dashboard_top_sellers_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod for production
  bool _isLoading = true;
  int _navIndex = 0;

  late AnimationController _entranceController;
  final List<Animation<double>> _sectionAnimations = [];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    for (int i = 0; i < 5; i++) {
      final start = i * 0.12;
      final end = (start + 0.5).clamp(0.0, 1.0);
      _sectionAnimations.add(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    }

    Future.microtask(() async {
      // TODO: Replace with real API call for production
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() => _isLoading = false);
      _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: const AdminDrawerWidget(
        currentRoute: AppRoutes.adminDashboardScreen,
      ),
      body: isTablet ? _buildTabletLayout(context) : _buildPhoneLayout(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.sellerVisitScreen),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(
          'Nouvelle visite',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.adminPanelScreen),
              icon: const Icon(Icons.manage_accounts_rounded, size: 18),
              label: Text(
                'Gérer produits & vendeurs',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
      bottomNavigationBar: isTablet
          ? null
          : AppBottomNavigation(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: _isLoading
              ? const DashboardSkeletonWidget()
              : _buildPhoneContent(context),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _navIndex,
          onDestinationSelected: (i) => setState(() => _navIndex = i),
          backgroundColor: AppTheme.surface,
          indicatorColor: AppTheme.primaryContainer,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: Text('Tableau'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people_outline_rounded),
              selectedIcon: Icon(Icons.people_rounded),
              label: Text('Vendeurs'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: Text('Rapports'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _isLoading
              ? const DashboardSkeletonWidget()
              : _buildTabletContent(context),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppTheme.surface,
      shadowColor: AppTheme.outline.withAlpha(77),
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_rounded,
              size: 20,
              color: AppTheme.primary,
            ),
          ),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: AppTheme.primary,
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'MK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DistriPro',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            Text(
              _getGreeting(),
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
        background: Container(color: AppTheme.surface),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour — 3 visites planifiées aujourd\'hui';
    if (hour < 18) return 'Bon après-midi — 2 factures en attente';
    return 'Bonsoir — Récapitulatif de la journée';
  }

  Widget _buildPhoneContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedSection(
            index: 0,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: DashboardKpiGridWidget(),
            ),
          ),
          _buildAnimatedSection(
            index: 1,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: DashboardAiInsightWidget(),
            ),
          ),
          _buildAnimatedSection(
            index: 2,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: DashboardRevenueChartWidget(),
            ),
          ),
          _buildAnimatedSection(
            index: 3,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: DashboardLowStockWidget(),
            ),
          ),
          _buildAnimatedSection(
            index: 4,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: DashboardTopSellersWidget(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTabletContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          DashboardKpiGridWidget(isTablet: true),
                          SizedBox(height: 24),
                          DashboardRevenueChartWidget(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const DashboardAiInsightWidget(),
                          const SizedBox(height: 24),
                          const DashboardLowStockWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const DashboardTopSellersWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSection({required int index, required Widget child}) {
    if (index >= _sectionAnimations.length) return child;
    return FadeTransition(
      opacity: _sectionAnimations[index],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(_sectionAnimations[index]),
        child: child,
      ),
    );
  }
}
