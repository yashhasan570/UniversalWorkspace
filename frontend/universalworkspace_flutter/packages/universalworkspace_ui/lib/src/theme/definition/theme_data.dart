import 'border_radius/border_radius.dart';
import 'color_scheme/color_scheme.dart';
import 'shadow/shadow.dart';
import 'spacing/spacing.dart';
import 'text_style/text_style.dart';

/// [UniversalWorkspaceThemeData] defines the structure of the design system, and contains
/// the data that all child widgets will have access to.
class UniversalWorkspaceThemeData {
  const UniversalWorkspaceThemeData({
    required this.textColorScheme,
    required this.textStyle,
    required this.iconColorScheme,
    required this.borderColorScheme,
    required this.backgroundColorScheme,
    required this.fillColorScheme,
    required this.surfaceColorScheme,
    required this.borderRadius,
    required this.spacing,
    required this.shadow,
    required this.brandColorScheme,
    required this.surfaceContainerColorScheme,
    required this.badgeColorScheme,
    required this.otherColorsColorScheme,
  });

  final UniversalWorkspaceTextColorScheme textColorScheme;

  final UniversalWorkspaceBaseTextStyle textStyle;

  final UniversalWorkspaceIconColorScheme iconColorScheme;

  final UniversalWorkspaceBorderColorScheme borderColorScheme;

  final UniversalWorkspaceBackgroundColorScheme backgroundColorScheme;

  final UniversalWorkspaceFillColorScheme fillColorScheme;

  final UniversalWorkspaceSurfaceColorScheme surfaceColorScheme;

  final UniversalWorkspaceBorderRadius borderRadius;

  final UniversalWorkspaceSpacing spacing;

  final UniversalWorkspaceShadow shadow;

  final UniversalWorkspaceBrandColorScheme brandColorScheme;

  final UniversalWorkspaceSurfaceContainerColorScheme surfaceContainerColorScheme;

  final UniversalWorkspaceBadgeColorScheme badgeColorScheme;

  final UniversalWorkspaceOtherColorsColorScheme otherColorsColorScheme;

  static UniversalWorkspaceThemeData lerp(
    UniversalWorkspaceThemeData begin,
    UniversalWorkspaceThemeData end,
    double t,
  ) {
    return UniversalWorkspaceThemeData(
      textColorScheme: begin.textColorScheme.lerp(
        end.textColorScheme,
        t,
      ),
      textStyle: end.textStyle,
      iconColorScheme: begin.iconColorScheme.lerp(
        end.iconColorScheme,
        t,
      ),
      borderColorScheme: begin.borderColorScheme.lerp(
        end.borderColorScheme,
        t,
      ),
      backgroundColorScheme: begin.backgroundColorScheme.lerp(
        end.backgroundColorScheme,
        t,
      ),
      fillColorScheme: begin.fillColorScheme.lerp(
        end.fillColorScheme,
        t,
      ),
      surfaceColorScheme: begin.surfaceColorScheme.lerp(
        end.surfaceColorScheme,
        t,
      ),
      borderRadius: end.borderRadius,
      spacing: end.spacing,
      shadow: end.shadow,
      brandColorScheme: begin.brandColorScheme.lerp(
        end.brandColorScheme,
        t,
      ),
      otherColorsColorScheme: begin.otherColorsColorScheme.lerp(
        end.otherColorsColorScheme,
        t,
      ),
      surfaceContainerColorScheme: begin.surfaceContainerColorScheme.lerp(
        end.surfaceContainerColorScheme,
        t,
      ),
      badgeColorScheme: begin.badgeColorScheme.lerp(
        end.badgeColorScheme,
        t,
      ),
    );
  }
}

/// [UniversalWorkspaceThemeBuilder] is used to build the light and dark themes. Extend
/// this class to create a built-in theme, or use the [CustomTheme] class to
/// create a custom theme from JSON data.
///
/// See also:
///
/// - [UniversalWorkspaceThemeData] for the main theme data class.
abstract class UniversalWorkspaceThemeBuilder {
  const UniversalWorkspaceThemeBuilder();

  UniversalWorkspaceThemeData light({
    String? fontFamily,
  });

  UniversalWorkspaceThemeData dark({
    String? fontFamily,
  });
}
