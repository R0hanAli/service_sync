import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class AppColors {
  AppColors._();

  
  static const Color darkBackground   = Color(0xFF0A0E27);
  static const Color darkSurface      = Color(0xFF1A1F4E);
  static const Color darkSurface2     = Color(0xFF12163A);
  static const Color darkCard         = Color(0xFF1E2451);

  static const Color cyanAccent       = Color(0xFF00D4FF);
  static const Color purpleAccent     = Color(0xFF7C3AED);
  static const Color bluePrimary      = Color(0xFF3B82F6);
  static const Color blueLight        = Color(0xFF60A5FA);
  static const Color indigo           = Color(0xFF4F46E5);

  static const Color darkTextPrimary   = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0BAD3);
  static const Color darkTextHint      = Color(0xFF6B7A99);

  static const Color darkBorder        = Color(0x2EFFFFFF); 
  static const Color darkDivider       = Color(0x1AFFFFFF);

  static const Color darkGlassCard     = Color(0x1FFFFFFF); 
  static const Color darkGlassCardHover= Color(0x26FFFFFF); 

  
  static const Color lightBackground   = Color(0xFFF0F4FF);
  static const Color lightSurface      = Color(0xFFFFFFFF);
  static const Color lightSurface2     = Color(0xFFE8EEFF);
  static const Color lightCard         = Color(0xFFFFFFFF);

  static const Color lightTextPrimary   = Color(0xFF0A0E27);
  static const Color lightTextSecondary = Color(0xFF4A5568);
  static const Color lightTextHint      = Color(0xFF9AA5BE);

  static const Color lightBorder        = Color(0x2E000000);
  static const Color lightDivider       = Color(0x1A000000);

  static const Color lightGlassCard     = Color(0xD9FFFFFF); 
  static const Color lightGlassCardHover= Color(0xF0FFFFFF); 

  
  static const Color success    = Color(0xFF10B981);
  static const Color warning    = Color(0xFFF59E0B);
  static const Color error      = Color(0xFFEF4444);
  static const Color info       = Color(0xFF3B82F6);

  static const Color priorityLow       = Color(0xFF10B981);
  static const Color priorityMedium    = Color(0xFFF59E0B);
  static const Color priorityHigh      = Color(0xFFF97316);
  static const Color priorityEmergency = Color(0xFFEF4444);

  static const Color statusPending    = Color(0xFFF59E0B);
  static const Color statusAccepted   = Color(0xFF3B82F6);
  static const Color statusInProgress = Color(0xFF8B5CF6);
  static const Color statusCompleted  = Color(0xFF10B981);
  static const Color statusRejected   = Color(0xFFEF4444);

  
  static Color glassColor(Color base, double opacity) =>
      base.withOpacity(opacity);
}




class AppGradients {
  AppGradients._();

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0E27),
      Color(0xFF0D1333),
      Color(0xFF12163A),
      Color(0xFF0A0E27),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8EEFF),
      Color(0xFFF0F4FF),
      Color(0xFFEEF2FF),
      Color(0xFFF8FAFF),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x26FFFFFF), 
      Color(0x0DFFFFFF), 
    ],
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xF5FFFFFF),
      Color(0xD9FFFFFF),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF00D4FF),
    ],
  );

  static const LinearGradient purpleButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF4F46E5),
    ],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFEF4444),
      Color(0xFFDC2626),
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFD97706),
    ],
  );

  static const LinearGradient navBarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCC0A0E27),
      Color(0xFF0A0E27),
    ],
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x3300D4FF),
      Color(0x0000D4FF),
    ],
  );

  static const LinearGradient avatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF7C3AED),
    ],
  );
}




class AppTextStyles {
  AppTextStyles._();

  
  static TextStyle heading1({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle heading2({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle heading3({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -0.2,
        height: 1.3,
      );

  static TextStyle heading4({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  
  static TextStyle bodyLarge({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle body({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall({Color color = AppColors.darkTextSecondary}) =>
      GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  
  static TextStyle caption({Color color = AppColors.darkTextSecondary}) =>
      GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.2,
        height: 1.3,
      );

  static TextStyle label({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.1,
      );

  static TextStyle labelSmall({Color color = AppColors.darkTextSecondary}) =>
      GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.5,
      );

  
  static TextStyle button({Color color = Colors.white}) =>
      GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.3,
      );

  static TextStyle buttonSmall({Color color = Colors.white}) =>
      GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.2,
      );

  
  static TextStyle display({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -1.0,
        height: 1.1,
      );

  static TextStyle displaySmall({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  
  static TextStyle statNumber({Color color = AppColors.cyanAccent}) =>
      GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      );

  
  static TextStyle overline({Color color = AppColors.darkTextHint}) =>
      GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.2,
      );
}




class GlassConfig {
  GlassConfig._();

  static const double blurAmount       = 20.0;
  static const double cardOpacityDark  = 0.12;
  static const double cardOpacityLight = 0.85;
  static const double borderOpacity    = 0.18;
  static const double borderRadius     = 20.0;
  static const double borderRadiusSm   = 12.0;
  static const double borderRadiusLg   = 28.0;
  static const double borderWidth      = 1.0;

  
  static Color get darkGlass =>
      Colors.white.withOpacity(cardOpacityDark);

  
  static Color get lightGlass =>
      Colors.white.withOpacity(cardOpacityLight);

  
  static Color get darkBorder =>
      Colors.white.withOpacity(borderOpacity);

  
  static Color get lightBorder =>
      Colors.black.withOpacity(0.08);
}




class AppTheme {
  AppTheme._();

  
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary:   AppColors.bluePrimary,
        secondary: AppColors.cyanAccent,
        tertiary:  AppColors.purpleAccent,
        surface:   AppColors.darkSurface,
        error:     AppColors.error,
        onPrimary:   Colors.white,
        onSecondary: Colors.white,
        onSurface:   AppColors.darkTextPrimary,
        onError:     Colors.white,
      ),
      textTheme: _buildTextTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading3(),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkGlassCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadius),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button(),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.cyanAccent,
          side: const BorderSide(color: AppColors.cyanAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button(color: AppColors.cyanAccent),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.cyanAccent,
          textStyle: AppTextStyles.button(color: AppColors.cyanAccent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkGlassCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide:
              const BorderSide(color: AppColors.cyanAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle:
            AppTextStyles.label(color: AppColors.darkTextSecondary),
        hintStyle: AppTextStyles.body(color: AppColors.darkTextHint),
        prefixIconColor: AppColors.darkTextSecondary,
        suffixIconColor: AppColors.darkTextSecondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.cyanAccent,
        unselectedItemColor: AppColors.darkTextHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTextStyles.body(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkGlassCard,
        labelStyle: AppTextStyles.label(),
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkTextSecondary,
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.bluePrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadius),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.cyanAccent
                : AppColors.darkTextHint),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.cyanAccent.withOpacity(0.3)
                : AppColors.darkTextHint.withOpacity(0.2)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.cyanAccent
                : Colors.transparent),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.darkTextSecondary),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.cyanAccent,
        linearTrackColor: AppColors.darkBorder,
      ),
    );
  }

  
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary:   AppColors.bluePrimary,
        secondary: AppColors.cyanAccent,
        tertiary:  AppColors.purpleAccent,
        surface:   AppColors.lightSurface,
        error:     AppColors.error,
        onPrimary:   Colors.white,
        onSecondary: Colors.white,
        onSurface:   AppColors.lightTextPrimary,
        onError:     Colors.white,
      ),
      textTheme: _buildTextTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle:
            AppTextStyles.heading3(color: AppColors.lightTextPrimary),
        iconTheme:
            const IconThemeData(color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightGlassCard,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadius),
          side: BorderSide(
              color: Colors.black.withOpacity(0.06), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(GlassConfig.borderRadiusSm),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button(),
          elevation: 2,
          shadowColor: AppColors.bluePrimary.withOpacity(0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.bluePrimary,
          side: const BorderSide(color: AppColors.bluePrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(GlassConfig.borderRadiusSm),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button(color: AppColors.bluePrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.bluePrimary,
          textStyle: AppTextStyles.button(color: AppColors.bluePrimary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide:
              const BorderSide(color: AppColors.bluePrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle:
            AppTextStyles.label(color: AppColors.lightTextSecondary),
        hintStyle: AppTextStyles.body(color: AppColors.lightTextHint),
        prefixIconColor: AppColors.lightTextSecondary,
        suffixIconColor: AppColors.lightTextSecondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.bluePrimary,
        unselectedItemColor: AppColors.lightTextHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: AppTextStyles.body(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface2,
        labelStyle:
            AppTextStyles.label(color: AppColors.lightTextPrimary),
        side: BorderSide(color: Colors.black.withOpacity(0.08)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextSecondary,
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.bluePrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConfig.borderRadius),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 8,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.bluePrimary
                : AppColors.lightTextHint),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.bluePrimary.withOpacity(0.3)
                : AppColors.lightTextHint.withOpacity(0.2)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.bluePrimary
                : Colors.transparent),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.lightTextSecondary),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.bluePrimary,
        linearTrackColor: AppColors.lightDivider,
      ),
    );
  }

  
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge:   GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.25),
      displayMedium:  GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.w700, color: primary),
      displaySmall:   GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w600, color: primary),
      headlineLarge:  GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w600, color: primary),
      headlineSmall:  GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: primary),
      titleLarge:     GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
      titleMedium:    GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: primary),
      titleSmall:     GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      bodyLarge:      GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: primary, height: 1.5),
      bodyMedium:     GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: primary, height: 1.5),
      bodySmall:      GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: secondary, height: 1.4),
      labelLarge:     GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
      labelMedium:    GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
      labelSmall:     GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.5),
    );
  }
}
