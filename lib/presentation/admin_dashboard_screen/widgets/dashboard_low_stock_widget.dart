import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardLowStockWidget extends StatelessWidget {
  const DashboardLowStockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real stock data from backend for production
    final alerts = [
      _StockAlert(
        name: 'Huile Végétale 5L',
        current: 8,
        minimum: 20,
        category: 'Alimentaire',
      ),
      _StockAlert(
        name: 'Savon Palmolive 200g',
        current: 3,
        minimum: 15,
        category: 'Hygiène',
      ),
      _StockAlert(
        name: 'Lait Vache Noire 1L',
        current: 12,
        minimum: 30,
        category: 'Laitier',
      ),
      _StockAlert(
        name: 'Sucre Cristal 1kg',
        current: 5,
        minimum: 25,
        category: 'Épicerie',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: AppTheme.warning,
            ),
            const SizedBox(width: 8),
            Text(
              'Alertes stock faible',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.warningContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${alerts.length}',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.warning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _StockAlertCard(alert: alerts[i]),
          ),
        ),
      ],
    );
  }
}

class _StockAlertCard extends StatelessWidget {
  final _StockAlert alert;

  const _StockAlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final pct = alert.current / alert.minimum;
    final isCritical = pct < 0.3;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCritical ? AppTheme.debtContainer : AppTheme.warningContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCritical
              ? AppTheme.debtRed.withAlpha(102)
              : AppTheme.warning.withAlpha(102),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  alert.name,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                isCritical ? Icons.error_rounded : Icons.warning_amber_rounded,
                size: 16,
                color: isCritical ? AppTheme.debtRed : AppTheme.warning,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${alert.current} / ${alert.minimum} unités',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isCritical ? AppTheme.debtRed : AppTheme.warning,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: pct.clamp(0.0, 1.0),
                  backgroundColor: Colors.white.withAlpha(128),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCritical ? AppTheme.debtRed : AppTheme.warning,
                  ),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockAlert {
  final String name;
  final int current;
  final int minimum;
  final String category;

  const _StockAlert({
    required this.name,
    required this.current,
    required this.minimum,
    required this.category,
  });
}
