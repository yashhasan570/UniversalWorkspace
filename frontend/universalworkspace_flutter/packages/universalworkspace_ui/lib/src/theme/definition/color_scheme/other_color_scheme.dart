import 'dart:ui';

class UniversalWorkspaceOtherColorsColorScheme {
  const UniversalWorkspaceOtherColorsColorScheme({
    required this.textHighlight,
  });

  final Color textHighlight;

  UniversalWorkspaceOtherColorsColorScheme lerp(
    UniversalWorkspaceOtherColorsColorScheme other,
    double t,
  ) {
    return UniversalWorkspaceOtherColorsColorScheme(
      textHighlight: Color.lerp(textHighlight, other.textHighlight, t)!,
    );
  }
}
