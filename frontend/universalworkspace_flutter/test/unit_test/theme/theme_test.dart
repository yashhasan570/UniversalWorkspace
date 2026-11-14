import 'package:uniflow_infra/colorscheme/colorscheme.dart';
import 'package:uniflow_infra/plugins/service/location_service.dart';
import 'package:uniflow_infra/plugins/service/models/uniflow_dynamic_plugin.dart';
import 'package:uniflow_infra/plugins/service/plugin_service.dart';
import 'package:uniflow_infra/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPluginService implements UniflowPluginService {
  @override
  Future<void> addPlugin(UniflowDynamicPlugin plugin) =>
      throw UnimplementedError();

  @override
  Future<UniflowDynamicPlugin?> lookup({required String name}) =>
      throw UnimplementedError();

  @override
  Future<DynamicPluginLibrary> get plugins async => const Iterable.empty();

  @override
  void setLocation(PluginLocationService locationService) =>
      throw UnimplementedError();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('AppTheme', () {
    test('fallback theme', () {
      const theme = AppTheme.fallback;

      expect(theme.builtIn, true);
      expect(theme.themeName, BuiltInTheme.defaultTheme);
      expect(theme.lightTheme, isA<UniflowColorScheme>());
      expect(theme.darkTheme, isA<UniflowColorScheme>());
    });

    test('built-in themes', () {
      final themes = AppTheme.builtins;

      expect(themes, isNotEmpty);
      for (final theme in themes) {
        expect(theme.builtIn, true);
        expect(
          theme.themeName,
          anyOf([
            BuiltInTheme.defaultTheme,
            BuiltInTheme.dandelion,
            BuiltInTheme.lavender,
            BuiltInTheme.lemonade,
          ]),
        );
        expect(theme.lightTheme, isA<UniflowColorScheme>());
        expect(theme.darkTheme, isA<UniflowColorScheme>());
      }
    });

    test('fromName returns existing theme', () async {
      final theme = await AppTheme.fromName(
        BuiltInTheme.defaultTheme,
        pluginService: MockPluginService(),
      );

      expect(theme, isNotNull);
      expect(theme.builtIn, true);
      expect(theme.themeName, BuiltInTheme.defaultTheme);
      expect(theme.lightTheme, isA<UniflowColorScheme>());
      expect(theme.darkTheme, isA<UniflowColorScheme>());
    });

    test('fromName throws error for non-existent theme', () async {
      expect(
        () async => AppTheme.fromName(
          'bogus',
          pluginService: MockPluginService(),
        ),
        throwsArgumentError,
      );
    });
  });
}
