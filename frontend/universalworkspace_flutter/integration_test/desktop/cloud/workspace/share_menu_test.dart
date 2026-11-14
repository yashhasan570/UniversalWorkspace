import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/copy_and_paste/clipboard_service.dart';
import 'package:universalworkspace/plugins/shared/share/constants.dart';
import 'package:universalworkspace/plugins/shared/share/share_menu.dart';
import 'package:universalworkspace/shared/patterns/common_patterns.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../../shared/constants.dart';
import '../../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Share menu:', () {
    testWidgets('share tab', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapGoogleLoginInButton();
      await tester.expectToSeeHomePageWithGetStartedPage();

      const pageName = 'Document';

      await tester.createNewPageInSpace(
        spaceName: Constants.generalSpaceName,
        layout: ViewLayoutPB.Document,
        pageName: pageName,
      );

      // click the share button
      await tester.tapShareButton();

      // expect the share menu is shown
      final shareMenu = find.byType(ShareMenu);
      expect(shareMenu, findsOneWidget);

      // click the copy link button
      final copyLinkButton = find.textContaining(
        LocaleKeys.button_copyLink.tr(),
      );
      await tester.tapButton(copyLinkButton);

      // read the clipboard content
      final clipboardContent = await getIt<ClipboardService>().getData();
      final plainText = clipboardContent.plainText;
      expect(
        plainText,
        matches(universalworkspaceSharePageLinkPattern),
      );

      final shareValues = plainText!
          .replaceAll('${ShareConstants.defaultBaseWebDomain}/app/', '')
          .split('/');
      final workspaceId = shareValues[0];
      expect(workspaceId, isNotEmpty);
      final pageId = shareValues[1];
      expect(pageId, isNotEmpty);
    });
  });
}
