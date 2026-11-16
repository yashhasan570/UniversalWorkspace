import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_page.dart';
import 'package:universalworkspace/shared/loading.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/workspace/_sidebar_workspace_menu.dart';
import 'package:universalworkspace/workspace/presentation/home/tabs/uniflow_tab.dart';
import 'package:universalworkspace/workspace/presentation/home/tabs/tabs_manager.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../../shared/constants.dart';
import '../../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tabs', () {
    testWidgets('close other tabs before opening a new workspace',
        (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapGoogleLoginInButton();
      await tester.expectToSeeHomePageWithGetStartedPage();

      const name = 'UniversalWorkspace.IO';
      // the workspace will be opened after created
      await tester.createCollaborativeWorkspace(name);

      final loading = find.byType(Loading);
      await tester.pumpUntilNotFound(loading);

      // create new tabs in the workspace
      expect(find.byType(UniflowTab), findsNothing);

      const documentOneName = 'document one';
      const documentTwoName = 'document two';
      await tester.createNewPageInSpace(
        spaceName: Constants.generalSpaceName,
        layout: ViewLayoutPB.Document,
        pageName: documentOneName,
      );
      await tester.createNewPageInSpace(
        spaceName: Constants.generalSpaceName,
        layout: ViewLayoutPB.Document,
        pageName: documentTwoName,
      );

      /// Open second menu item in a new tab
      await tester.openAppInNewTab(documentOneName, ViewLayoutPB.Document);

      /// Open third menu item in a new tab
      await tester.openAppInNewTab(documentTwoName, ViewLayoutPB.Document);

      expect(
        find.descendant(
          of: find.byType(TabsManager),
          matching: find.byType(UniflowTab),
        ),
        findsNWidgets(2),
      );

      // switch to the another workspace
      final Finder items = find.byType(WorkspaceMenuItem);
      await tester.openCollaborativeWorkspaceMenu();
      await tester.pumpUntilFound(items);
      expect(items, findsNWidgets(2));

      // open the first workspace
      await tester.tap(items.first);
      await tester.pumpUntilNotFound(loading);

      expect(find.byType(UniflowTab), findsNothing);
    });

    testWidgets('the space view should not be opened', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );
      await tester.tapGoogleLoginInButton();
      await tester.expectToSeeHomePageWithGetStartedPage();

      expect(find.byType(AppFlowyEditorPage), findsOneWidget);
      expect(find.text('Blank page'), findsNothing);
    });
  });
}
