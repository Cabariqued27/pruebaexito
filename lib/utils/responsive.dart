import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isMobile => width < 650;
  bool get isTablet => width >= 650 && width < 1100;
  bool get isDesktop => width >= 1100;

  double wp(double percent) => width * percent / 100;

  double hp(double percent) => height * percent / 100;

  double sp(double size) => size * (width / 390);
}
