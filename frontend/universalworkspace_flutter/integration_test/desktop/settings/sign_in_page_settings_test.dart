import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/user/presentation/screens/sign_in_screen/desktop_sign_in_screen.dart';
import 'package:universalworkspace/workspace/presentation/settings/settings_dialog.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder findServerType(AuthenticatorType type) {
    return find
        .descendant(
          of: find.byType(SettingsServerDropdownMenu),
          matching: find.findTextInUniflowText(
            type.label,
          ),
        )
        .last;
  }

  group('sign-in page settings:', () {
    testWidgets('change server type', (tester) async {
      await tester.initializeUniversalWorkspace();

      // reset the app to the default state
      await useUniversalWorkspaceBetaCloudWithURL(
        kUniversalWorkspaceCloudUrl,
        AuthenticatorType.universalworkspaceCloud,
      );

      // open the settings page
      final settingsButton = find.byType(DesktopSignInSettingsButton);
      await tester.tapButton(settingsButton);

      expect(find.byType(SimpleSettingsDialog), findsOneWidget);

      // the default type should be universalworkspace cloud
      final universalworkspaceCloudType = findServerType(AuthenticatorType.universalworkspaceCloud);
      expect(universalworkspaceCloudType, findsOneWidget);

      // change the server type to self-host
      await tester.tapButton(universalworkspaceCloudType);
      final selfHostedButton = findServerType(
        AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapButton(selfHostedButton);

      // update server url
      const serverUrl = 'https://self-hosted.universalworkspace.cloud';
      await tester.enterText(
        find.byKey(kSelfHostedTextInputFieldKey),
        serverUrl,
      );
      await tester.pumpAndSettle();
      // update the web url
      const webUrl = 'https://self-hosted.universalworkspace.com';
      await tester.enterText(
        find.byKey(kSelfHostedWebTextInputFieldKey),
        webUrl,
      );
      await tester.pumpAndSettle();
      await tester.tapButton(
        find.findTextInUniflowText(LocaleKeys.button_save.tr()),
      );

      // wait the app to restart, and the tooltip to disappear
      await tester.pumpUntilNotFound(find.byType(DesktopToast));
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      // open settings page to check the result
      await tester.tapButton(settingsButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      // check the server type
      expect(
        findServerType(AuthenticatorType.universalworkspaceCloudSelfHost),
        findsOneWidget,
      );
      // check the server url
      expect(
        find.text(serverUrl),
        findsOneWidget,
      );
      // check the web url
      expect(
        find.text(webUrl),
        findsOneWidget,
      );

      // reset to universalworkspace cloud
      await tester.tapButton(
        findServerType(AuthenticatorType.universalworkspaceCloudSelfHost),
      );
      // change the server type to universalworkspace cloud
      await tester.tapButton(
        findServerType(AuthenticatorType.universalworkspaceCloud),
      );

      // wait the app to restart, and the tooltip to disappear
      await tester.pumpUntilNotFound(find.byType(DesktopToast));
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      // check the server type
      await tester.tapButton(settingsButton);
      expect(
        findServerType(AuthenticatorType.universalworkspaceCloud),
        findsOneWidget,
      );
    });
  });
}
