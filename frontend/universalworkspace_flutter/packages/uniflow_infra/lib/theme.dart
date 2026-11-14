import 'package:uniflow_infra/colorscheme/colorscheme.dart';
import 'package:uniflow_infra/colorscheme/default_colorscheme.dart';
import 'plugins/service/plugin_service.dart';

class BuiltInTheme {
  static const String defaultTheme = 'Default';
  static const String dandelion = 'Dandelion';
  static const String lemonade = 'Lemonade';
  static const String lavender = 'Lavender';
}

class AppTheme {
  // metadata member
  final bool builtIn;
  final String themeName;
  final UniflowColorScheme lightTheme;
  final UniflowColorScheme darkTheme;
  // static final Map<String, dynamic> _cachedJsonData = {};

  const AppTheme({
    required this.builtIn,
    required this.themeName,
    required this.lightTheme,
    required this.darkTheme,
  });

  static const AppTheme fallback = AppTheme(
    builtIn: true,
    themeName: BuiltInTheme.defaultTheme,
    lightTheme: DefaultColorScheme.light(),
    darkTheme: DefaultColorScheme.dark(),
  );

  static Future<Iterable<AppTheme>> _plugins(UniflowPluginService service) async {
    final plugins = await service.plugins;
    return plugins.map((plugin) => plugin.theme).whereType<AppTheme>();
  }

  static Iterable<AppTheme> get builtins => themeMap.entries
      .map(
        (entry) => AppTheme(
          builtIn: true,
          themeName: entry.key,
          lightTheme: entry.value[0],
          darkTheme: entry.value[1],
        ),
      )
      .toList();

  static Future<Iterable<AppTheme>> themes(UniflowPluginService service) async =>
      [
        ...builtins,
        ...(await _plugins(service)),
      ];

  static Future<AppTheme> fromName(
    String themeName, {
    UniflowPluginService? pluginService,
  }) async {
    pluginService ??= UniflowPluginService.instance;
    for (final theme in await themes(pluginService)) {
      if (theme.themeName == themeName) {
        return theme;
      }
    }
    throw ArgumentError('The theme $themeName does not exist.');
  }
}
