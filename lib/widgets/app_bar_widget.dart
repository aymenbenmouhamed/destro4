import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Widget? bottom;
  final double bottomHeight;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = false,
    this.onBack,
    this.backgroundColor,
    this.bottom,
    this.bottomHeight = 0,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottomHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: backgroundColor ?? AppTheme.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: AppTheme.outline.withAlpha(77),
      leading: showBack
          ? IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : leading,
      title: Text(
        title,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: bottom!,
            )
          : null,
    );
  }
}
