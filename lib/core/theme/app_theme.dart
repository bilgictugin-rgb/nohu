import 'package:flutter/material.dart';

class LightColorTokens {
  static const canvas = Color(0xFFF4F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFEAF2FF);
  static const ink = Color(0xFF061A34);
  static const muted = Color(0xFF71809A);
  static const line = Color(0xFFE0E8F2);
  static const primary = Color(0xFF1967FF);
  static const secondary = Color(0xFF145464);
  static const navy = Color(0xFF071D3D);
  static const tertiary = Color(0xFF7B61FF);
  static const campus = Color(0xFF18B785);
  static const coral = Color(0xFFFF7A59);
  static const success = Color(0xFF2F9E6E);
  static const warning = Color(0xFFFFC247);
  static const danger = Color(0xFFEF4444);
  static const info = Color(0xFF20B9F2);
  static const nohu = Color(0xFF00A9A5);
}

class DarkColorTokens {
  static const canvas = Color(0xFF0B0B0D);
  static const surface = Color(0xFF151518);
  static const surfaceAlt = Color(0xFF1B1B1F);
  static const ink = Color(0xFFF5F7FB);
  static const muted = Color(0xFFB7C0D1);
  static const line = Color(0xFF2A2B31);
  static const primary = Color(0xFF7AA7FF);
  static const secondary = Color(0xFF87C8D2);
  static const navy = Color(0xFF0D1424);
  static const tertiary = Color(0xFFB59CFF);
  static const campus = Color(0xFF65D89A);
  static const coral = Color(0xFFFF9A84);
  static const success = Color(0xFF70D99B);
  static const warning = Color(0xFFF2C56B);
  static const danger = Color(0xFFFF7A7A);
  static const info = Color(0xFF67DCEC);
  static const nohu = Color(0xFF48D6D1);
}

class LightThemeColors {
  static const background = LightColorTokens.canvas;
  static const surface = LightColorTokens.surface;
  static const primary = LightColorTokens.primary;
  static const secondary = LightColorTokens.secondary;
}

class DarkThemeColors {
  static const background = DarkColorTokens.canvas;
  static const surface = DarkColorTokens.surface;
  static const primary = DarkColorTokens.primary;
  static const secondary = DarkColorTokens.secondary;
}

class LightThemeTokens extends LightThemeColors {
  static const accent = LightColorTokens.nohu;
  static const hero = Color(0xFF163B92);
}

class DarkThemeTokens extends DarkThemeColors {
  static const accent = DarkColorTokens.nohu;
  static const hero = Color(0xFF121B32);
}

class AppColors {
  static const indigo = LightColorTokens.primary;
  static const blue = LightColorTokens.primary;
  static const coral = LightColorTokens.coral;
  static const lavender = LightColorTokens.tertiary;
  static const green = LightColorTokens.campus;
  static const amber = LightColorTokens.warning;
  static const red = LightColorTokens.danger;
  static const success = LightColorTokens.success;
  static const warning = LightColorTokens.warning;
  static const info = LightColorTokens.info;
  static const ink = LightColorTokens.ink;
  static const graphite = LightColorTokens.muted;
  static const canvas = LightColorTokens.canvas;
  static const surface = LightColorTokens.surface;
  static const surfaceAlt = LightColorTokens.surfaceAlt;
  static const mist = LightColorTokens.canvas;
  static const line = LightColorTokens.line;
  static const darkCanvas = DarkColorTokens.canvas;
  static const darkSurface = DarkColorTokens.surface;
  static const darkSurfaceAlt = DarkColorTokens.surfaceAlt;
  static const darkLine = DarkColorTokens.line;

  static const teal = LightColorTokens.nohu;
  static const tealDark = Color(0xFF087E82);
  static const petrol = LightColorTokens.secondary;
  static const navy = LightColorTokens.navy;
  static const violet = lavender;
  static const sky = Color(0xFFE8F4FF);
  static const softCyan = Color(0xFFE7FBFD);
  static const softLavender = Color(0xFFF0ECFF);
  static const softCoral = Color(0xFFFFEFEA);
  static const softMint = Color(0xFFE9FAF3);
  static const softAmber = Color(0xFFFFF6D8);
}

class AppTypography {
  static const fontFamily = 'Manrope';
  static const screenTitle = 24.0;
  static const sectionTitle = 17.0;
  static const body = 14.5;
  static const helper = 12.5;
}

class AppShadows {
  static List<BoxShadow> floating(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.34 : 0.09),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];

  static List<BoxShadow> soft(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}

class AppShadow extends AppShadows {}

class AppAnimations {
  static const fast = Duration(milliseconds: 160);
  static const normal = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 420);
  static const curve = Curves.easeOutCubic;
}

class AppIconTheme {
  static const size = 22.0;
  static const small = 20.0;
}

class AppTheme {
  static ThemeData get light => _base(
    ColorScheme.fromSeed(
      seedColor: LightColorTokens.primary,
      brightness: Brightness.light,
      primary: LightColorTokens.primary,
      secondary: LightColorTokens.secondary,
      tertiary: LightColorTokens.tertiary,
      surface: LightColorTokens.surface,
      error: LightColorTokens.danger,
    ),
  );

  static ThemeData get dark => _base(
    ColorScheme.fromSeed(
      seedColor: DarkColorTokens.primary,
      brightness: Brightness.dark,
      primary: DarkColorTokens.primary,
      secondary: DarkColorTokens.secondary,
      tertiary: DarkColorTokens.tertiary,
      surface: DarkColorTokens.surface,
      error: DarkColorTokens.danger,
    ),
  );

  static ThemeData _base(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final canvas = isDark ? DarkColorTokens.canvas : LightColorTokens.canvas;
    final surfaceAlt = isDark
        ? DarkColorTokens.surfaceAlt
        : LightColorTokens.surfaceAlt;
    final line = isDark ? DarkColorTokens.line : LightColorTokens.line;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: AppTypography.fontFamily,
      dividerColor: line,
      textTheme: _textTheme(isDark),
      iconTheme: IconThemeData(
        color: isDark ? DarkColorTokens.muted : LightColorTokens.muted,
        size: AppIconTheme.size,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: isDark ? DarkColorTokens.ink : LightColorTokens.ink,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(
          color: isDark ? DarkColorTokens.ink : LightColorTokens.ink,
          fontSize: 23,
          fontWeight: FontWeight.w900,
          height: 1.15,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: line),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? surfaceAlt : LightColorTokens.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDark
              ? const Color(0xFF2B2B30)
              : const Color(0xFFE2E2E8),
          disabledForegroundColor: isDark
              ? const Color(0xFF777982)
              : const Color(0xFF8B8D94),
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          foregroundColor: scheme.primary,
          side: BorderSide(color: line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: line),
        selectedColor: scheme.primary.withValues(alpha: isDark ? 0.24 : 0.12),
        labelStyle: TextStyle(
          color: isDark ? DarkColorTokens.ink : LightColorTokens.ink,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 66,
        elevation: 0,
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: isDark ? 0.18 : 0.12),
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 23,
            color: selected
                ? scheme.primary
                : (isDark ? DarkColorTokens.muted : LightColorTokens.muted),
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            height: 1.1,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected
                ? scheme.primary
                : (isDark ? DarkColorTokens.muted : LightColorTokens.muted),
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: isDark
            ? DarkColorTokens.muted
            : LightColorTokens.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }

  static TextTheme _textTheme(bool isDark) {
    final color = isDark ? DarkColorTokens.ink : LightColorTokens.ink;
    final muted = isDark ? DarkColorTokens.muted : LightColorTokens.muted;
    return TextTheme(
      headlineSmall: TextStyle(
        color: color,
        fontSize: AppTypography.screenTitle,
        fontWeight: FontWeight.w800,
        height: 1.16,
      ),
      titleLarge: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.2,
      ),
      titleMedium: TextStyle(
        color: color,
        fontSize: AppTypography.sectionTitle,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleSmall: TextStyle(
        color: color,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      bodyLarge: TextStyle(color: color, fontSize: 16, height: 1.45),
      bodyMedium: TextStyle(
        color: color,
        fontSize: AppTypography.body,
        height: 1.42,
      ),
      bodySmall: TextStyle(
        color: muted,
        fontSize: AppTypography.helper,
        height: 1.35,
      ),
      labelLarge: TextStyle(
        color: color,
        fontSize: AppTypography.body,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        color: muted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
    );
  }
}
