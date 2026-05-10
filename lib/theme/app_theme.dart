import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Palette ──────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF003C8F);
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryContainer = Color(0xFFD6E4FF);
  static const Color secondary = Color(0xFF0277BD);
  static const Color secondaryContainer = Color(0xFFCCE5FF);

  // ── Semantic Colors ────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFD4EDDA);
  static const Color warning = Color(0xFFE65100);
  static const Color warningContainer = Color(0xFFFFE0CC);
  static const Color error = Color(0xFFC62828);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color debtRed = Color(0xFFB71C1C);
  static const Color debtContainer = Color(0xFFFFCDD2);
  static const Color paidGreen = Color(0xFF1B5E20);
  static const Color partialAmber = Color(0xFFBF360C);

  // ── Surface Palette ────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F7FF);
  static const Color background = Color(0xFFF0F4F8);
  static const Color outline = Color(0xFFBDBDBD);
  static const Color outlineVariant = Color(0xFFE0E0E0);
  static const Color muted = Color(0xFF78909C);

  // ── Dark Surface Palette ───────────────────────────────────
  static const Color darkSurface = Color(0xFF1C1C2E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A3E);
  static const Color darkBackground = Color(0xFF12121E);

  static ThemeData get lightTheme {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        surface: surface,
        error: error,
        errorContainer: errorContainer,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1A2E),
        onError: Colors.white,
        outline: outline,
        outlineVariant: outlineVariant,
        surfaceContainerHighest: surfaceVariant,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.ibmPlexSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.ibmPlexSans(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
        displayMedium: GoogleFonts.ibmPlexSans(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
        headlineLarge: GoogleFonts.ibmPlexSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
        headlineMedium: GoogleFonts.ibmPlexSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
        headlineSmall: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
        titleLarge: GoogleFonts.ibmPlexSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
        titleMedium: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
        titleSmall: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1A1A2E),
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1A1A2E),
        ),
        bodySmall: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        labelLarge: GoogleFonts.ibmPlexSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        labelMedium: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        labelSmall: GoogleFonts.ibmPlexSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: GoogleFonts.ibmPlexSans(fontSize: 15, color: muted),
        hintStyle: GoogleFonts.ibmPlexSans(fontSize: 15, color: muted),
        errorStyle: GoogleFonts.ibmPlexSans(fontSize: 12, color: error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.ibmPlexSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return const IconThemeData(color: muted, size: 24);
        }),
        elevation: 8,
        height: 72,
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        primaryContainer: Color(0xFF1A3A6B),
        secondary: Color(0xFF4FC3F7),
        surface: darkSurface,
        error: Color(0xFFEF9A9A),
        onPrimary: Colors.white,
        onSurface: Color(0xFFE8EAF6),
        outline: Color(0xFF546E7A),
        outlineVariant: Color(0xFF37474F),
        surfaceContainerHighest: darkSurfaceVariant,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: GoogleFonts.ibmPlexSansTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.ibmPlexSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE8EAF6),
        ),
        titleLarge: GoogleFonts.ibmPlexSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE8EAF6),
        ),
        titleMedium: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE8EAF6),
        ),
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFE8EAF6),
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFB0BEC5),
        ),
        bodySmall: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF78909C),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: darkSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        titleTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE8EAF6),
        ),
      ),
    );
  }
}
