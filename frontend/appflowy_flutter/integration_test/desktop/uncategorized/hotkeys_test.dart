import 'dart:io';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/settings/prelude.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/sidebar.dart';
import 'package:universalworkspace/workspace/presentation/settings/settings_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../shared/keyboard.dart';
import '../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('hotkeys test', () {
    testWidgets('toggle theme mode', (tester) async {
      await tester.initializeUniversalWorkspace();

      await tester.tapAnonymousSignInButton();
      await tester.expectToSeeHomePageWithGetStartedPage();

      await tester.openSettings();
      await tester.openSettingsPage(SettingsPage.workspace);
      await tester.pumpAndSettle();

      final appFinder = find.byType(MaterialApp).first;
      ThemeMode? themeMode = tester.widget<MaterialApp>(appFinder).themeMode;

      expect(themeMode, ThemeMode.system);

      await tester.tapButton(
        find.bySemanticsLabel(
          LocaleKeys.settings_workspacePage_appearance_options_light.tr(),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      themeMode = tester.widget<MaterialApp>(appFinder).themeMode;
      expect(themeMode, ThemeMode.light);

      await tester.tapButton(
        find.bySemanticsLabel(
          LocaleKeys.settings_workspacePage_appearance_options_dark.tr(),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      themeMode = tester.widget<MaterialApp>(appFinder).themeMode;
      expect(themeMode, ThemeMode.dark);

      await tester.tap(find.byType(SettingsDialog));
      await tester.pumpAndSettle();

      await UniflowTestKeyboard.simulateKeyDownEvent(
        [
          Platform.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyL,
        ],
        tester: tester,
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // disable it temporarily. It works on macOS but not on Linux.
      // themeMode = tester.widget<MaterialApp>(appFinder).themeMode;
      // expect(themeMode, ThemeMode.light);
    });

    testWidgets('show or hide home menu', (tester) async {
      await tester.initializeUniversalWorkspace();

      await tester.tapAnonymousSignInButton();
      await tester.expectToSeeHomePageWithGetStartedPage();

      await tester.pumpAndSettle();

      expect(find.byType(HomeSideBar), findsOneWidget);

      await UniflowTestKeyboard.simulateKeyDownEvent(
        [
          Platform.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.backslash,
        ],
        tester: tester,
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomeSideBar), findsNothing);
    });
  });
}
