import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardRevenueChartWidget extends StatefulWidget {
  const DashboardRevenueChartWidget({super.key});

  @override
  State<DashboardRevenueChartWidget> createState() =>
      _DashboardRevenueChartWidgetState();
}

class _DashboardRevenueChartWidgetState
    extends State<DashboardRevenueChartWidget> {
  // TODO: Replace with real data from Riverpod/backend for production
  int _selectedPeriod = 0;
  final List<String> _periods = ['7 jours', '30 jours', '3 mois'];

  // Weekly revenue data in TND per day (Mon–Sun)
  final List<Map<String, dynamic>> _weeklyData = [
    {'day': 'Lun', 'revenue': 850.0, 'visits': 3},
    {'day': 'Mar', 'revenue': 1320.0, 'visits': 5},
    {'day': 'Mer', 'revenue': 640.0, 'visits': 2},
    {'day': 'Jeu', 'revenue': 1780.0, 'visits': 6},
    {'day': 'Ven', 'revenue': 1245.0, 'visits': 4},
    {'day': 'Sam', 'revenue': 920.0, 'visits': 3},
    {'day': 'Dim', 'revenue': 430.0, 'visits': 1},
  ];

  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenus hebdomadaires',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '7 185 TND cette semaine',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: List.generate(
                    _periods.length,
                    (i) => GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == i
                              ? AppTheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          _periods[i],
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _selectedPeriod == i
                                ? Colors.white
                                : AppTheme.muted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 2200,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    setState(() {
                      if (response?.spot != null) {
                        _touchedIndex = response!.spot!.touchedBarGroupIndex;
                      } else {
                        _touchedIndex = null;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFF1A1A2E),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final d = _weeklyData[groupIndex];
                      return BarTooltipItem(
                        '${d['revenue'].toStringAsFixed(0)} TND\n${d['visits']} visites',
                        GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= _weeklyData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _weeklyData[i]['day'] as String,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _touchedIndex == i
                                  ? AppTheme.primary
                                  : AppTheme.muted,
                            ),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      reservedSize: 48,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          '${(value / 1000).toStringAsFixed(1)}k',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 10,
                            color: AppTheme.muted,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppTheme.outlineVariant,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_weeklyData.length, (i) {
                  final isToday = i == 4; // Friday = today
                  final isTouched = _touchedIndex == i;
                  final revenue = _weeklyData[i]['revenue'] as double;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: revenue,
                        width: 28,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(7),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isTouched || isToday
                              ? [AppTheme.primary, AppTheme.primaryLight]
                              : [
                                  AppTheme.primaryContainer,
                                  AppTheme.primaryContainer,
                                ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem(color: AppTheme.primary, label: 'Aujourd\'hui'),
              const SizedBox(width: 16),
              _buildLegendItem(
                color: AppTheme.primaryContainer,
                label: 'Autres jours',
              ),
              const Spacer(),
              Text(
                'Mis à jour: 04:35',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(fontSize: 11, color: AppTheme.muted),
        ),
      ],
    );
  }
}