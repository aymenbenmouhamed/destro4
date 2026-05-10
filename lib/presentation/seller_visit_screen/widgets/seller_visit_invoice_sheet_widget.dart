import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../seller_visit_screen.dart';

class SellerVisitInvoiceSheetWidget extends StatelessWidget {
  final String sellerName;
  final String sellerContact;
  final String sellerLocation;
  final List<VisitProduct> products;
  final Map<String, int> newStockToGive;
  final double totalOwed;
  final double previousDebt;
  final double grandTotal;
  final DateTime visitDate;

  const SellerVisitInvoiceSheetWidget({
    super.key,
    required this.sellerName,
    required this.sellerContact,
    required this.sellerLocation,
    required this.products,
    required this.newStockToGive,
    required this.totalOwed,
    required this.previousDebt,
    required this.grandTotal,
    required this.visitDate,
  });

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final soldProducts = products.where((p) => p.soldQuantity > 0).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      builder: (ctx, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Facture de visite',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            'N° INV-${visitDate.millisecondsSinceEpoch % 100000}',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Invoice content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company + Seller info block
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoBlock(
                              title: 'ÉMETTEUR',
                              lines: [
                                'DistriPro SARL',
                                'Tunis, Tunisie',
                                'contact@distripro.tn',
                                '+216 71 000 000',
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _InfoBlock(
                              title: 'VENDEUR',
                              lines: [
                                sellerName,
                                sellerLocation,
                                sellerContact,
                                'Date: ${_formatDate(visitDate)}',
                              ],
                              highlight: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Products table
                      Text(
                        'DÉTAIL DES VENTES',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.muted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.outlineVariant,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _TableHeader(),
                            if (soldProducts.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Aucun produit vendu lors de cette visite',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 13,
                                    color: AppTheme.muted,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            else
                              ...soldProducts.asMap().entries.map(
                                (e) => _InvoiceProductRow(
                                  product: e.value,
                                  isEven: e.key % 2 == 0,
                                  isLast: e.key == soldProducts.length - 1,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // New stock section
                      if (newStockToGive.values.any((v) => v > 0)) ...[
                        Text(
                          'NOUVEAU STOCK LAISSÉ',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.successContainer,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.success.withAlpha(77),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: products
                                .where((p) => (newStockToGive[p.id] ?? 0) > 0)
                                .map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          p.name,
                                          style: GoogleFonts.ibmPlexSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                        Text(
                                          '${newStockToGive[p.id]} ${p.unit}(s)',
                                          style: GoogleFonts.ibmPlexSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Financial summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _SummaryLine(
                              label: 'Sous-total ventes',
                              value: totalOwed,
                              bold: false,
                            ),
                            const SizedBox(height: 8),
                            _SummaryLine(
                              label: 'Dette précédente (info)',
                              value: previousDebt,
                              bold: false,
                              color: AppTheme.warning,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TOTAL À PAYER',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.debtRed,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '${totalOwed.toStringAsFixed(3)} TND',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.debtRed,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Status badge
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.debtContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.debtRed.withAlpha(77),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'STATUT: IMPAYÉ',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.debtRed,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stock à laisser section
                      Text(
                        'STOCK À LAISSER',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.muted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primary.withAlpha(77),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Produit',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Stock actuel',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.muted,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Nouveau',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.muted,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Total',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            ...products.map((p) {
                              final newStock = newStockToGive[p.id] ?? 0;
                              final stockALaisser = p.currentVisible + newStock;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        p.name,
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A1A2E),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${p.currentVisible} ${p.unit}',
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 12,
                                          color: AppTheme.muted,
                                          fontFeatures: const [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        newStock > 0
                                            ? '+$newStock ${p.unit}'
                                            : '—',
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 12,
                                          color: newStock > 0
                                              ? AppTheme.success
                                              : AppTheme.muted,
                                          fontWeight: newStock > 0
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontFeatures: const [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '$stockALaisser ${p.unit}',
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primary,
                                          fontFeatures: const [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Partage de la facture... (fonctionnalité à connecter)',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 13,
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share_rounded, size: 18),
                              label: const Text('Partager'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primary,
                                side: const BorderSide(
                                  color: AppTheme.primary,
                                  width: 1.5,
                                ),
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.picture_as_pdf_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'PDF généré — connexion PDF requise',
                                          style: GoogleFonts.ibmPlexSans(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: AppTheme.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.picture_as_pdf_rounded,
                                size: 18,
                              ),
                              label: const Text('Télécharger PDF'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final List<String> lines;
  final bool highlight;

  const _InfoBlock({
    required this.title,
    required this.lines,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? AppTheme.primaryContainer : AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: highlight
            ? Border.all(color: AppTheme.primary.withAlpha(77), width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: highlight ? AppTheme.primary : AppTheme.muted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: line == lines.first
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Produit',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Qté',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'P.U.',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Total',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceProductRow extends StatelessWidget {
  final VisitProduct product;
  final bool isEven;
  final bool isLast;

  const _InvoiceProductRow({
    required this.product,
    required this.isEven,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isEven ? AppTheme.surface : AppTheme.surfaceVariant,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(10))
            : BorderRadius.zero,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              product.name,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${product.soldQuantity}',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              product.pricePerUnit.toStringAsFixed(2),
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                color: AppTheme.muted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${product.lineTotal.toStringAsFixed(3)} TND',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.debtRed,
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

class _SummaryLine extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  final Color? color;

  const _SummaryLine({
    required this.label,
    required this.value,
    required this.bold,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(fontSize: 13, color: AppTheme.muted),
        ),
        Text(
          '${value.toStringAsFixed(3)} TND',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: color ?? const Color(0xFF1A1A2E),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
