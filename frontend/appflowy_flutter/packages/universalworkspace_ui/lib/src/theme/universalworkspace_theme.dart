import 'package:universalworkspace_ui/src/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UniversalWorkspaceTheme extends StatelessWidget {
  const UniversalWorkspaceTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final UniversalWorkspaceThemeData data;
  final Widget child;

  static UniversalWorkspaceThemeData of(BuildContext context, {bool listen = true}) {
    final provider = maybeOf(context, listen: listen);
    if (provider == null) {
      throw FlutterError(
        '''
        UniversalWorkspaceTheme.of() called with a context that does not contain a UniversalWorkspaceTheme.\n
        No UniversalWorkspaceTheme ancestor could be found starting from the context that was passed to UniversalWorkspaceTheme.of().
        This can happen because you do not have a UniversalWorkspaceTheme widget (which introduces a UniversalWorkspaceTheme),
        or it can happen if the context you use comes from a widget above this widget.\n
        The context used was: $context''',
      );
    }
    return provider;
  }

  static UniversalWorkspaceThemeData? maybeOf(
    BuildContext context, {
    bool listen = true,
  }) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<UniversalWorkspaceInheritedTheme>()
          ?.themeData;
    }
    final provider = context
        .getElementForInheritedWidgetOfExactType<UniversalWorkspaceInheritedTheme>()
        ?.widget;

    return (provider as UniversalWorkspaceInheritedTheme?)?.themeData;
  }

  @override
  Widget build(BuildContext context) {
    return UniversalWorkspaceInheritedTheme(
      themeData: data,
      child: child,
    );
  }
}

class UniversalWorkspaceInheritedTheme extends InheritedTheme {
  const UniversalWorkspaceInheritedTheme({
    super.key,
    required this.themeData,
    required super.child,
  });

  final UniversalWorkspaceThemeData themeData;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return UniversalWorkspaceTheme(data: themeData, child: child);
  }

  @override
  bool updateShouldNotify(UniversalWorkspaceInheritedTheme oldWidget) =>
      themeData != oldWidget.themeData;
}

/// An interpolation between two [UniversalWorkspaceThemeData]s.
///
/// This class specializes the interpolation of [Tween<UniversalWorkspaceThemeData>] to
/// call the [UniversalWorkspaceThemeData.lerp] method.
///
/// See [Tween] for a discussion on how to use interpolation objects.
class UniversalWorkspaceThemeDataTween extends Tween<UniversalWorkspaceThemeData> {
  /// Creates a [UniversalWorkspaceThemeData] tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  UniversalWorkspaceThemeDataTween({super.begin, super.end});

  @override
  UniversalWorkspaceThemeData lerp(double t) => UniversalWorkspaceThemeData.lerp(begin!, end!, t);
}

class AnimatedUniversalWorkspaceTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated theme.
  ///
  /// By default, the theme transition uses a linear curve.
  const AnimatedUniversalWorkspaceTheme({
    super.key,
    required this.data,
    super.curve,
    super.duration = kThemeAnimationDuration,
    super.onEnd,
    required this.child,
  });

  /// Specifies the color and typography values for descendant widgets.
  final UniversalWorkspaceThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedUniversalWorkspaceTheme> createState() =>
      _AnimatedThemeState();
}

class _AnimatedThemeState
    extends AnimatedWidgetBaseState<AnimatedUniversalWorkspaceTheme> {
  UniversalWorkspaceThemeDataTween? data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    data = visitor(
      data,
      widget.data,
      (dynamic value) =>
          UniversalWorkspaceThemeDataTween(begin: value as UniversalWorkspaceThemeData),
    )! as UniversalWorkspaceThemeDataTween;
  }

  @override
  Widget build(BuildContext context) {
    return UniversalWorkspaceTheme(
      data: data!.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      DiagnosticsProperty<UniversalWorkspaceThemeDataTween>(
        'data',
        data,
        showName: false,
        defaultValue: null,
      ),
    );
  }
}
