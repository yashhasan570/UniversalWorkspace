import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/settings/settings_dialog_bloc.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/settings_shortcuts_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../shared/keyboard.dart';
import '../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('shortcuts:', () {
    testWidgets('change and overwrite shortcut', (tester) async {
      await tester.initializeUniversalWorkspace();
      await tester.tapAnonymousSignInButton();

      await tester.openSettings();
      await tester.openSettingsPage(SettingsPage.shortcuts);
      await tester.pumpAndSettle();

      final backspaceCmd =
          LocaleKeys.settings_shortcutsPage_keybindings_backspace.tr();

      // Input "Delete" into the search field
      final inputField = find.descendant(
        of: find.byType(SettingsShortcutsView),
        matching: find.byType(TextField),
      );
      await tester.enterText(inputField, backspaceCmd);
      await tester.pumpAndSettle();

      await tester.hoverOnWidget(
        find
            .descendant(
              of: find.byType(ShortcutSettingTile),
              matching: find.text(backspaceCmd),
            )
            .first,
        onHover: () async {
          await tester.tap(find.byUniflowSvg(UniflowSvgs.edit_s));
          await tester.pumpAndSettle();

          await UniflowTestKeyboard.simulateKeyDownEvent(
            [
              LogicalKeyboardKey.delete,
              LogicalKeyboardKey.enter,
            ],
            tester: tester,
          );
          await tester.pumpAndSettle();
        },
      );

      // We expect to see conflict dialog
      expect(
        find.text(
          LocaleKeys.settings_shortcutsPage_conflictDialog_confirmLabel.tr(),
        ),
        findsOneWidget,
      );

      // Press on confirm label
      await tester.tap(
        find.text(
          LocaleKeys.settings_shortcutsPage_conflictDialog_confirmLabel.tr(),
        ),
      );
      await tester.pumpAndSettle();

      // We expect the first ShortcutSettingTile to have one
      // [KeyBadge] with `delete` label
      final first = tester.widget(find.byType(ShortcutSettingTile).first)
          as ShortcutSettingTile;
      expect(
        first.command.command,
        'delete',
      );

      // And the second one which is `Delete left character` to have none
      // as it will have been overwritten
      final second = tester.widget(find.byType(ShortcutSettingTile).at(1))
          as ShortcutSettingTile;
      expect(
        second.command.command,
        '',
      );
    });
  });
}
