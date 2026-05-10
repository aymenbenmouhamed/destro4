import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginCredentialsBoxWidget extends StatelessWidget {
  final bool isAdmin;

  const LoginCredentialsBoxWidget({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final email = isAdmin ? 'admin@distripro.tn' : 'agent@distripro.tn';
    final password = isAdmin ? 'DistriPro2026' : 'Agent2026';
    final role = isAdmin ? 'Administrateur' : 'Agent de terrain';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(77), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Compte de démonstration — $role',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCredentialRow(context, label: 'E-mail', value: email),
          const SizedBox(height: 8),
          _buildCredentialRow(context, label: 'Mot de passe', value: password),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.muted,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: AppTheme.primary.withAlpha(51),
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$label copié',
                    style: GoogleFonts.ibmPlexSans(fontSize: 13),
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.copy_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
