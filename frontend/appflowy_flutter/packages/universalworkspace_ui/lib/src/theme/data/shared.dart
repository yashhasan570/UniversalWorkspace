import 'package:universalworkspace_ui/src/theme/definition/border_radius/border_radius.dart';
import 'package:universalworkspace_ui/src/theme/definition/shadow/shadow.dart';
import 'package:universalworkspace_ui/src/theme/definition/spacing/spacing.dart';
import 'package:flutter/material.dart';

class UniversalWorkspaceSpacingConstant {
  static const double spacing100 = 4;
  static const double spacing200 = 6;
  static const double spacing300 = 8;
  static const double spacing400 = 12;
  static const double spacing500 = 16;
  static const double spacing600 = 20;
}

class UniversalWorkspaceBorderRadiusConstant {
  static const double radius100 = 4;
  static const double radius200 = 6;
  static const double radius300 = 8;
  static const double radius400 = 12;
  static const double radius500 = 16;
  static const double radius600 = 20;
}

class UniversalWorkspaceSharedTokens {
  const UniversalWorkspaceSharedTokens();

  static UniversalWorkspaceBorderRadius buildBorderRadius() {
    return UniversalWorkspaceBorderRadius(
      xs: UniversalWorkspaceBorderRadiusConstant.radius100,
      s: UniversalWorkspaceBorderRadiusConstant.radius200,
      m: UniversalWorkspaceBorderRadiusConstant.radius300,
      l: UniversalWorkspaceBorderRadiusConstant.radius400,
      xl: UniversalWorkspaceBorderRadiusConstant.radius500,
      xxl: UniversalWorkspaceBorderRadiusConstant.radius600,
    );
  }

  static UniversalWorkspaceSpacing buildSpacing() {
    return UniversalWorkspaceSpacing(
      xs: UniversalWorkspaceSpacingConstant.spacing100,
      s: UniversalWorkspaceSpacingConstant.spacing200,
      m: UniversalWorkspaceSpacingConstant.spacing300,
      l: UniversalWorkspaceSpacingConstant.spacing400,
      xl: UniversalWorkspaceSpacingConstant.spacing500,
      xxl: UniversalWorkspaceSpacingConstant.spacing600,
    );
  }

  static UniversalWorkspaceShadow buildShadow(
    Brightness brightness,
  ) {
    return switch (brightness) {
      Brightness.light => UniversalWorkspaceShadow(
          small: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 16,
              color: Color(0x1F000000),
            ),
          ],
          medium: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 32,
              color: Color(0x1F000000),
            ),
          ],
        ),
      Brightness.dark => UniversalWorkspaceShadow(
          small: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 16,
              color: Color(0x7A000000),
            ),
          ],
          medium: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 32,
              color: Color(0x7A000000),
            ),
          ],
        ),
    };
  }
}
