import 'dart:io';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/emoji/emoji_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> prepare(WidgetTester tester) async {
    await tester.initializeUniversalWorkspace();
    await tester.tapAnonymousSignInButton();
    await tester.createNewPageWithNameUnderParent();
    await tester.editor.tapLineOfEditorAt(0);
  }

  // May be better to move this to an existing test but unsure what it fits with
  group('Keyboard shortcuts related to emojis', () {
    testWidgets('cmd/ctrl+alt+e shortcut opens the emoji picker',
        (tester) async {
      await prepare(tester);

      expect(find.byType(EmojiHandler), findsNothing);

      await tester.simulateKeyEvent(
        LogicalKeyboardKey.keyE,
        isAltPressed: true,
        isMetaPressed: Platform.isMacOS,
        isControlPressed: !Platform.isMacOS,
      );
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byType(EmojiHandler), findsOneWidget);

      /// press backspace to hide the emoji picker
      await tester.simulateKeyEvent(LogicalKeyboardKey.backspace);
      expect(find.byType(EmojiHandler), findsNothing);
    });

    testWidgets('insert emoji by slash menu', (tester) async {
      await prepare(tester);
      await tester.editor.showSlashMenu();

      /// show emoji picler
      await tester.editor.tapSlashMenuItemWithName(
        LocaleKeys.document_slashMenu_name_emoji.tr(),
        offset: 100,
      );
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byType(EmojiHandler), findsOneWidget);
      await tester.simulateKeyEvent(LogicalKeyboardKey.enter);
      final firstNode =
          tester.editor.getCurrentEditorState().getNodeAtPath([0])!;

      /// except the emoji is in document
      expect(firstNode.delta!.toPlainText().contains('😀'), true);
    });
  });

  group('insert emoji by colon', () {
    Future<void> createNewDocumentAndShowEmojiList(
      WidgetTester tester, {
      String? search,
    }) async {
      await prepare(tester);
      await tester.ime.insertText(':${search ?? 'a'}');
      await tester.pumpAndSettle(Duration(seconds: 1));
    }

    testWidgets('insert with click', (tester) async {
      await createNewDocumentAndShowEmojiList(tester);

      /// emoji list is showing
      final emojiHandler = find.byType(EmojiHandler);
      expect(emojiHandler, findsOneWidget);
      final emojiButtons =
          find.descendant(of: emojiHandler, matching: find.byType(UniflowButton));
      final firstTextFinder = find.descendant(
        of: emojiButtons.first,
        matching: find.byType(UniflowText),
      );
      final emojiText =
          (firstTextFinder.evaluate().first.widget as UniflowText).text;

      /// click first emoji item
      await tester.tapButton(emojiButtons.first);
      final firstNode =
          tester.editor.getCurrentEditorState().getNodeAtPath([0])!;

      /// except the emoji is in document
      expect(emojiText.contains(firstNode.delta!.toPlainText()), true);
    });

    testWidgets('insert with arrow and enter', (tester) async {
      await createNewDocumentAndShowEmojiList(tester);

      /// emoji list is showing
      final emojiHandler = find.byType(EmojiHandler);
      expect(emojiHandler, findsOneWidget);
      final emojiButtons =
          find.descendant(of: emojiHandler, matching: find.byType(UniflowButton));

      /// tap arrow down and arrow up
      await tester.simulateKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.simulateKeyEvent(LogicalKeyboardKey.arrowDown);

      final firstTextFinder = find.descendant(
        of: emojiButtons.first,
        matching: find.byType(UniflowText),
      );
      final emojiText =
          (firstTextFinder.evaluate().first.widget as UniflowText).text;

      /// tap enter
      await tester.simulateKeyEvent(LogicalKeyboardKey.enter);
      final firstNode =
          tester.editor.getCurrentEditorState().getNodeAtPath([0])!;

      /// except the emoji is in document
      expect(emojiText.contains(firstNode.delta!.toPlainText()), true);
    });

    testWidgets('insert with searching', (tester) async {
      await createNewDocumentAndShowEmojiList(tester, search: 's');

      /// search for `smiling eyes`, IME is not working, use keyboard input
      final searchText = [
        LogicalKeyboardKey.keyM,
        LogicalKeyboardKey.keyI,
        LogicalKeyboardKey.keyL,
        LogicalKeyboardKey.keyI,
        LogicalKeyboardKey.keyN,
        LogicalKeyboardKey.keyG,
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.keyE,
        LogicalKeyboardKey.keyY,
        LogicalKeyboardKey.keyE,
        LogicalKeyboardKey.keyS,
      ];

      for (final key in searchText) {
        await tester.simulateKeyEvent(key);
      }

      /// tap enter
      await tester.simulateKeyEvent(LogicalKeyboardKey.enter);
      final firstNode =
          tester.editor.getCurrentEditorState().getNodeAtPath([0])!;

      /// except the emoji is in document
      expect(firstNode.delta!.toPlainText().contains('😄'), true);
    });

    testWidgets('start searching with sapce', (tester) async {
      await createNewDocumentAndShowEmojiList(tester, search: ' ');

      /// emoji list is showing
      final emojiHandler = find.byType(EmojiHandler);
      expect(emojiHandler, findsNothing);
    });
  });
}
