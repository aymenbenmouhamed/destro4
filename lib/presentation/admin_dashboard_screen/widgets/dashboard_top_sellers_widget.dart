import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../routes/app_routes.dart';

class DashboardTopSellersWidget extends StatelessWidget {
  const DashboardTopSellersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from Riverpod/backend for production
    final sellers = [
      _SellerSummary(
        name: 'Kamel Trabelsi',
        location: 'Tunis Centre',
        debt: 920.0,
        lastVisit: 'Aujourd\'hui, 09:15',
        revenue: 3200.0,
        status: VisitStatus.partial,
        initials: 'KT',
        rank: 1,
      ),
      _SellerSummary(
        name: 'Fatma Ben Salah',
        location: 'La Marsa',
        debt: 0.0,
        lastVisit: 'Hier, 14:30',
        revenue: 2850.0,
        status: VisitStatus.paid,
        initials: 'FB',
        rank: 2,
      ),
      _SellerSummary(
        name: 'Riadh Chaabane',
        location: 'Ariana',
        debt: 1540.0,
        lastVisit: '28 Apr',
        revenue: 2410.0,
        status: VisitStatus.unpaid,
        initials: 'RC',
        rank: 3,
      ),
      _SellerSummary(
        name: 'Amira Jelassi',
        location: 'Sousse',
        debt: 380.0,
        lastVisit: '27 Apr',
        revenue: 1980.0,
        status: VisitStatus.partial,
        initials: 'AJ',
        rank: 4,
      ),
      _SellerSummary(
        name: 'Noureddine Bou Ali',
        location: 'Sfax',
        debt: 1980.0,
        lastVisit: '25 Apr',
        revenue: 1620.0,
        status: VisitStatus.unpaid,
        initials: 'NB',
        rank: 5,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meilleurs vendeurs',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'Voir tous',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...sellers.asMap().entries.map(
          (e) => _SellerRow(
            seller: e.value,
            isLast: e.key == sellers.length - 1,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.sellerVisitScreen),
          ),
        ),
      ],
    );
  }
}

class _SellerRow extends StatelessWidget {
  final _SellerSummary seller;
  final bool isLast;
  final VoidCallback onTap;

  const _SellerRow({
    required this.seller,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: seller.status == VisitStatus.unpaid
            ? Border.all(color: AppTheme.debtRed.withAlpha(77), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: AppTheme.primaryContainer,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Rank badge
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: seller.rank <= 3
                        ? AppTheme.primaryContainer
                        : AppTheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#${seller.rank}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: seller.rank <= 3
                            ? AppTheme.primary
                            : AppTheme.muted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      seller.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller.name,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: AppTheme.muted,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            seller.location,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppTheme.muted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: AppTheme.muted,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            seller.lastVisit,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Debt + Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      seller.debt > 0
                          ? '${seller.debt.toStringAsFixed(0)} TND'
                          : 'Soldé',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: seller.debt > 0
                            ? AppTheme.debtRed
                            : AppTheme.success,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadgeWidget(status: seller.status),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppTheme.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SellerSummary {
  final String name;
  final String location;
  final double debt;
  final String lastVisit;
  final double revenue;
  final VisitStatus status;
  final String initials;
  final int rank;

  const _SellerSummary({
    required this.name,
    required this.location,
    required this.debt,
    required this.lastVisit,
    required this.revenue,
    required this.status,
    required this.initials,
    required this.rank,
  });
}
