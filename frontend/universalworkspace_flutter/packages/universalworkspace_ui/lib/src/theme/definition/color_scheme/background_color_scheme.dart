import 'package:flutter/material.dart';

class UniversalWorkspaceBackgroundColorScheme {
  const UniversalWorkspaceBackgroundColorScheme({
    required this.primary,
  });

  final Color primary;

  UniversalWorkspaceBackgroundColorScheme lerp(
    UniversalWorkspaceBackgroundColorScheme other,
    double t,
  ) {
    return UniversalWorkspaceBackgroundColorScheme(
      primary: Color.lerp(
        primary,
        other.primary,
        t,
      )!,
    );
  }
}
