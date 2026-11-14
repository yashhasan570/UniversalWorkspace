import 'package:flutter/material.dart';

enum UniflowGradientColor {
  gradient1,
  gradient2,
  gradient3,
  gradient4,
  gradient5,
  gradient6,
  gradient7;

  static UniflowGradientColor fromId(String id) {
    return UniflowGradientColor.values.firstWhere(
      (element) => element.id == id,
      orElse: () => UniflowGradientColor.gradient1,
    );
  }

  String get id {
    // DON'T change this name because it's saved in the database!
    switch (this) {
      case UniflowGradientColor.gradient1:
        return 'universalworkspace_them_color_gradient1';
      case UniflowGradientColor.gradient2:
        return 'universalworkspace_them_color_gradient2';
      case UniflowGradientColor.gradient3:
        return 'universalworkspace_them_color_gradient3';
      case UniflowGradientColor.gradient4:
        return 'universalworkspace_them_color_gradient4';
      case UniflowGradientColor.gradient5:
        return 'universalworkspace_them_color_gradient5';
      case UniflowGradientColor.gradient6:
        return 'universalworkspace_them_color_gradient6';
      case UniflowGradientColor.gradient7:
        return 'universalworkspace_them_color_gradient7';
    }
  }

  LinearGradient get linear {
    switch (this) {
      case UniflowGradientColor.gradient1:
        return const LinearGradient(
          begin: Alignment(-0.35, -0.94),
          end: Alignment(0.35, 0.94),
          colors: [Color(0xFF34BDAF), Color(0xFFB682D4)],
        );
      case UniflowGradientColor.gradient2:
        return const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF4CC2CC), Color(0xFFE17570)],
        );
      case UniflowGradientColor.gradient3:
        return const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFAF70E0), Color(0xFFED7196)],
        );
      case UniflowGradientColor.gradient4:
        return const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFA348D6), Color(0xFF44A7DE)],
        );
      case UniflowGradientColor.gradient5:
        return const LinearGradient(
          begin: Alignment(0.38, -0.93),
          end: Alignment(-0.38, 0.93),
          colors: [Color(0xFF5749C9), Color(0xFFBB4997)],
        );
      case UniflowGradientColor.gradient6:
        return const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF036FFA), Color(0xFF00B8E5)],
        );
      case UniflowGradientColor.gradient7:
        return const LinearGradient(
          begin: Alignment(0.62, -0.79),
          end: Alignment(-0.62, 0.79),
          colors: [Color(0xFFF0C6CF), Color(0xFFDECCE2), Color(0xFFCAD3F9)],
        );
    }
  }
}
