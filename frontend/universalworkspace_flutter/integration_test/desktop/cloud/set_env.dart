import 'package:universalworkspace/env/cloud_env.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../shared/util.dart';

// This test is meaningless, just for preventing the CI from failing.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Preset cloud env', () {
    testWidgets('use self-hosted cloud', (tester) async {
      await tester.initializeUniversalWorkspace(
        cloudType: AuthenticatorType.universalworkspaceCloudSelfHost,
      );

      await tester.pumpAndSettle();
    });
  });
}
