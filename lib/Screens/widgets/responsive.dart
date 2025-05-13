import 'package:flutter/material.dart';

class ResponsiveSize {
  final double xs;
  double? sm;
  double? md;
  double? lg;
  double? xl;

  ResponsiveSize({
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  double? build(context) {
    makeSureSizes();
    Size size = MediaQuery.of(context).size;

    if (size.width < 576) {
      return xs;
    } else if (size.width >= 576 && size.width < 768) {
      return sm;
    } else if (size.width >= 768 && size.width < 992) {
      return md;
    } else if (size.width >= 992 && size.width < 1200) {
      return lg; 
    } else if (size.width >= 1200) {
      return xl; 
    }

    return xs;
  }

  void makeSureSizes() {
    sm ??= xs;
    md ??= sm;
    lg ??= md;
    xl ??= lg;
  }
}
