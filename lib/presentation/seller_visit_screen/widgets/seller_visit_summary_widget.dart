import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../seller_visit_screen.dart';

class SellerVisitSummaryWidget extends StatelessWidget {
  final List<VisitProduct> products;
  final double previousDebt;
  final double totalOwed;
  final double grandTotal;

  const SellerVisitSummaryWidget({
    super.key,
    required this.products,
    required this.previousDebt,
    required this.totalOwed,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    final soldProducts = products.where((p) => p.soldQuantity > 0).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.debtRed.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Récapitulatif de la visite',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          // Product breakdown
          if (soldProducts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                children: soldProducts
                    .map((p) => _SummaryLineItem(product: p))
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Divider(height: 1),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Entrez le stock visible pour calculer les ventes',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  color: AppTheme.muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          // Totals
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                _TotalRow(
                  label: 'Ventes cette visite',
                  value: totalOwed,
                  style: _TotalStyle.normal,
                ),
                const SizedBox(height: 8),
                _TotalRow(
                  label: 'Dette précédente (info)',
                  value: previousDebt,
                  style: _TotalStyle.warning,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.debtContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.debtRed.withAlpha(77),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'À PAYER (ventes)',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.debtRed,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'Stock vendu uniquement',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${totalOwed.toStringAsFixed(2)} TND',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.debtRed,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Payment status buttons
                Row(
                  children: [
                    Expanded(
                      child: _PaymentButton(
                        label: 'Paiement partiel',
                        icon: Icons.payments_outlined,
                        color: AppTheme.warning,
                        bgColor: AppTheme.warningContainer,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PaymentButton(
                        label: 'Payé intégralement',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.success,
                        bgColor: AppTheme.successContainer,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLineItem extends StatelessWidget {
  final VisitProduct product;

  const _SummaryLineItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              product.name,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
          Text(
            '${product.soldQuantity} × ${product.pricePerUnit.toStringAsFixed(2)}',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              color: AppTheme.muted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '${product.lineTotal.toStringAsFixed(2)} TND',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

enum _TotalStyle { normal, warning, grand }

class _TotalRow extends StatelessWidget {
  final String label;
  final double value;
  final _TotalStyle style;

  const _TotalRow({
    required this.label,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final color = style == _TotalStyle.warning
        ? AppTheme.warning
        : style == _TotalStyle.grand
        ? AppTheme.debtRed
        : AppTheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(fontSize: 14, color: AppTheme.muted),
        ),
        Text(
          '${value.toStringAsFixed(2)} TND',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _PaymentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _PaymentButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
