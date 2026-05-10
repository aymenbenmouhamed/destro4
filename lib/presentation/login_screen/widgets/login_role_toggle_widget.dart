import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginRoleToggleWidget extends StatelessWidget {
  final bool isAdmin;
  final Function(bool) onChanged;

  const LoginRoleToggleWidget({
    super.key,
    required this.isAdmin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connexion en tant que',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildToggleOption(
                label: 'Administrateur',
                icon: Icons.admin_panel_settings_rounded,
                isSelected: isAdmin,
                onTap: () => onChanged(true),
              ),
              _buildToggleOption(
                label: 'Agent de terrain',
                icon: Icons.directions_walk_rounded,
                isSelected: !isAdmin,
                onTap: () => onChanged(false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : AppTheme.muted,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
