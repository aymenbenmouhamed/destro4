import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum VisitStatus { paid, partial, unpaid, inProgress, lowStock, normal }

class StatusBadgeWidget extends StatelessWidget {
  final VisitStatus status;
  final String? customLabel;
  final bool large;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.customLabel,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    final fontSize = large ? 13.0 : 11.0;
    final hPad = large ? 12.0 : 8.0;
    final vPad = large ? 6.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (config['text'] as Color).withAlpha(77),
          width: 1,
        ),
      ),
      child: Text(
        customLabel ?? config['label'] as String,
        style: GoogleFonts.ibmPlexSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: config['text'] as Color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Map<String, dynamic> _getConfig(VisitStatus s) {
    switch (s) {
      case VisitStatus.paid:
        return {
          'bg': AppTheme.successContainer,
          'text': AppTheme.paidGreen,
          'label': 'Payé',
        };
      case VisitStatus.partial:
        return {
          'bg': AppTheme.warningContainer,
          'text': AppTheme.partialAmber,
          'label': 'Partiel',
        };
      case VisitStatus.unpaid:
        return {
          'bg': AppTheme.debtContainer,
          'text': AppTheme.debtRed,
          'label': 'Impayé',
        };
      case VisitStatus.inProgress:
        return {
          'bg': AppTheme.primaryContainer,
          'text': AppTheme.primary,
          'label': 'En cours',
        };
      case VisitStatus.lowStock:
        return {
          'bg': AppTheme.warningContainer,
          'text': AppTheme.warning,
          'label': 'Stock faible',
        };
      case VisitStatus.normal:
        return {
          'bg': AppTheme.successContainer,
          'text': AppTheme.success,
          'label': 'Normal',
        };
    }
  }
}
