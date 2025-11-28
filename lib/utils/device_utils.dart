import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PlatformHelper {
  static bool isWeb() => kIsWeb;

  static bool isMobile(BuildContext context) {
    // Si NO es web → Android o iOS
    if (!kIsWeb) return true;

    // Si es web pero pantalla pequeña → tratar como móvil
    final width = MediaQuery.of(context).size.width;
    return width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1024;
  }
}
