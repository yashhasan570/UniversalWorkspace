import 'package:flutter/material.dart';

class UniversalWorkspaceSurfaceContainerColorScheme {
  const UniversalWorkspaceSurfaceContainerColorScheme({
    required this.layer01,
    required this.layer02,
    required this.layer03,
  });

  final Color layer01;
  final Color layer02;
  final Color layer03;

  UniversalWorkspaceSurfaceContainerColorScheme lerp(
    UniversalWorkspaceSurfaceContainerColorScheme other,
    double t,
  ) {
    return UniversalWorkspaceSurfaceContainerColorScheme(
      layer01: Color.lerp(
        layer01,
        other.layer01,
        t,
      )!,
      layer02: Color.lerp(
        layer02,
        other.layer02,
        t,
      )!,
      layer03: Color.lerp(
        layer03,
        other.layer03,
        t,
      )!,
    );
  }
}
