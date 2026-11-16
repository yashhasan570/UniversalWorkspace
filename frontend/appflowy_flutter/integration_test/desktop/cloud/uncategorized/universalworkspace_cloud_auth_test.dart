import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/settings/prelude.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/account/account.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/setting_universalworkspace_cloud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('universalworkspace cloud auth', () {
    testWidgets('sign in', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapGoogleLoginInButton();
      await tester.expectToSeeHomePageWithGetStartedPage();
    });

    testWidgets('sign out', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapGoogleLoginInButton();

      // Open the setting page and sign out
      await tester.openSettings();
      await tester.openSettingsPage(SettingsPage.account);

      // Scroll to sign-out
      await tester.scrollUntilVisible(
        find.byType(AccountSignInOutButton),
        100,
        scrollable: find.findSettingsScrollable(),
      );
      await tester.tapButton(find.byType(AccountSignInOutButton));

      tester.expectToSeeText(LocaleKeys.button_yes.tr());
      await tester.tapButtonWithName(LocaleKeys.button_yes.tr());

      // Go to the sign in page again
      await tester.pumpAndSettle(const Duration(seconds: 5));
      tester.expectToSeeGoogleLoginButton();
    });

    testWidgets('sign in as anonymous', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapSignInAsGuest();

      // should not see the sync setting page when sign in as anonymous
      await tester.openSettings();
      await tester.openSettingsPage(SettingsPage.account);

      await tester.tapButton(find.byType(AccountSignInOutButton));

      tester.expectToSeeGoogleLoginButton();
    });

    testWidgets('enable sync', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );

      await tester.tapGoogleLoginInButton();
      // Open the setting page and sign out
      await tester.openSettings();
      await tester.openSettingsPage(SettingsPage.cloud);
      await tester.pumpAndSettle();

      // the switch should be on by default
      tester.assertUniversalWorkspaceCloudEnableSyncSwitchValue(true);
      await tester.toggleEnableSync(UniversalWorkspaceCloudEnableSync);
      // wait for the switch animation
      await tester.wait(250);

      // the switch should be off
      tester.assertUniversalWorkspaceCloudEnableSyncSwitchValue(false);

      // the switch should be on after toggling
      await tester.toggleEnableSync(UniversalWorkspaceCloudEnableSync);
      tester.assertUniversalWorkspaceCloudEnableSyncSwitchValue(true);
      await tester.wait(250);
    });
  });
}
