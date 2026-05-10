import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SellerVisitHeaderWidget extends StatelessWidget {
  final String sellerName;
  final String location;
  final String contact;
  final double previousDebt;
  final String lastVisitDate;

  const SellerVisitHeaderWidget({
    super.key,
    required this.sellerName,
    required this.location,
    required this.contact,
    required this.previousDebt,
    required this.lastVisitDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(102),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'KT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerName,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          location,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_rounded,
                          size: 13,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          contact,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    label: 'Dette précédente',
                    value: '${previousDebt.toStringAsFixed(0)} TND',
                    icon: Icons.account_balance_wallet_rounded,
                    valueColor: previousDebt > 0
                        ? const Color(0xFFFFCDD2)
                        : Colors.white,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withAlpha(51),
                ),
                Expanded(
                  child: _buildInfoTile(
                    label: 'Dernière visite',
                    value: lastVisitDate,
                    icon: Icons.calendar_today_rounded,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.white60),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: valueColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
