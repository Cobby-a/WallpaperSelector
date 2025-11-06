import 'package:flutter/material.dart';

double responsiveFontSize(BuildContext context, {required double base, double min = 12, double max = 64}) {
  final width = MediaQuery.of(context).size.width;
  final scaled = base * (width / 1440);
  return scaled.clamp(min, max);
}

class AppTheme {
  static const Color backgroundColor = Color(0xFFF8F8F8);
  static const Color navBarBackground = Color(0xFFFFFFFF);
  static const Color primaryBlack = Color(0xFF000000);
  static const Color textGrey = Color(0xFF575757);
  static const Color iconGrey = Color(0xFF808080);
  static const Color borderGrey = Color(0xFFE5E5E5);
  static const Color buttonBg = Color(0xFFF5F5F5);
  static const Color iconButtonBg = Color(0x1A7C7C7C);
  static const Color orangeGradientStart = Color(0xFFFBB03B);
  static const Color orangeGradientEnd = Color(0xFFEC0C43);
  static const Color selectedOrange = Color(0xFFFFA821);
  static const Color seeAll = Color(0xFF808080);
  static const Color selectedOrangeBg = Color(0x1AEC9E0C);

  static const String clashDisplay = 'ClashDisplay';
  static const String poppins = 'Poppins';

  static TextStyle get displayHeadingDesktop => const TextStyle(
    fontFamily: clashDisplay,
    fontSize: 60,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get displayHeading => const TextStyle(
    fontFamily: clashDisplay,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get displayHeadingMobile => const TextStyle(
    fontFamily: clashDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get subtitleDesktop => const TextStyle(
    fontFamily: poppins,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    // height: 1.0,
    color: textGrey,
  );

  static TextStyle get subtitleMobile => const TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textGrey,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: poppins,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: primaryBlack,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: primaryBlack,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: poppins,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: primaryBlack,
  );

  static TextStyle get navText => const TextStyle(
    fontFamily: poppins,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: primaryBlack,
  );

  static TextStyle get categoryHeading => const TextStyle(
    fontFamily: poppins,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: primaryBlack,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orangeGradientStart, orangeGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius iconButtonRadius = BorderRadius.all(Radius.circular(11));
  static const BorderRadius smallCardRadius = BorderRadius.all(Radius.circular(16));

  static List<BoxShadow> get navBarShadow => [
    BoxShadow(
      color: primaryBlack.withValues(alpha: 0.1),
      blurRadius: 0,
      spreadRadius: 0,
      offset: const Offset(0, 1),
    ),
  ];

  static ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: buttonBg,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: buttonRadius,
      side: BorderSide(
        color: primaryBlack.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  );

  static BoxDecoration get iconButtonDecoration => BoxDecoration(
    color: iconButtonBg,
    borderRadius: iconButtonRadius,
    border: Border.all(
      color: const Color(0xFFE5E5E5),
      width: 0.5,
    ),
  );

  static BoxDecoration glassEffect = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      width: 0.5,
      color: Colors.white.withValues(alpha: 0.3),
    ),
  );
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static int getGridCrossAxisCount(BuildContext context) {
    final width = getWidth(context);
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    return 4;
  }
}