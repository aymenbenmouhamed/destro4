import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardKpiGridWidget extends StatelessWidget {
  final bool isTablet;

  const DashboardKpiGridWidget({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from Riverpod/backend for production
    final kpis = [
      _KpiData(
        label: 'Total Dû',
        value: '4 820',
        unit: 'TND',
        icon: Icons.account_balance_wallet_rounded,
        color: AppTheme.debtRed,
        bgColor: AppTheme.debtContainer,
        trend: '+12%',
        trendUp: false,
        subtitle: 'par 8 vendeurs',
      ),
      _KpiData(
        label: 'Ventes Aujourd\'hui',
        value: '1 245',
        unit: 'TND',
        icon: Icons.trending_up_rounded,
        color: AppTheme.success,
        bgColor: AppTheme.successContainer,
        trend: '+8%',
        trendUp: true,
        subtitle: '3 visites effectuées',
      ),
      _KpiData(
        label: 'Vendeurs Actifs',
        value: '12',
        unit: '',
        icon: Icons.people_rounded,
        color: AppTheme.primary,
        bgColor: AppTheme.primaryContainer,
        trend: '+2',
        trendUp: true,
        subtitle: 'ce mois-ci',
      ),
      _KpiData(
        label: 'Alertes Stock',
        value: '4',
        unit: '',
        icon: Icons.warning_amber_rounded,
        color: AppTheme.warning,
        bgColor: AppTheme.warningContainer,
        trend: '2 critiques',
        trendUp: false,
        subtitle: 'produits concernés',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vue d\'ensemble',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            Text(
              '30 Apr 2026',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, i) => _KpiCard(data: kpis[i]),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;

  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: data.color.withAlpha(38), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: data.bgColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(data.icon, size: 18, color: data.color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: data.trendUp
                      ? AppTheme.successContainer
                      : AppTheme.debtContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.trendUp
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 10,
                      color: data.trendUp ? AppTheme.success : AppTheme.debtRed,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      data.trend,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: data.trendUp
                            ? AppTheme.success
                            : AppTheme.debtRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.value,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: data.color,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (data.unit.isNotEmpty) ...[
                    const SizedBox(width: 3),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        data.unit,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: data.color,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                data.subtitle,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String trend;
  final bool trendUp;
  final String subtitle;

  const _KpiData({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.trend,
    required this.trendUp,
    required this.subtitle,
  });
}
