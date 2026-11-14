import 'package:universalworkspace/startup/tasks/deeplink/deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/invitation_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/login_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/open_app_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/payment_deeplink_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deep link handler: ', () {
    final deepLinkHandlerRegistry = DeepLinkHandlerRegistry.instance
      ..register(LoginDeepLinkHandler())
      ..register(PaymentDeepLinkHandler())
      ..register(InvitationDeepLinkHandler())
      ..register(OpenAppDeepLinkHandler());

    test('invitation deep link handler', () {
      final uri = Uri.parse(
        'universalworkspace-flutter://invitation-callback?email=lucas@universalworkspace.com&workspace_id=123',
      );
      deepLinkHandlerRegistry.processDeepLink(
        uri: uri,
        onStateChange: (handler, state) {
          expect(handler, isA<InvitationDeepLinkHandler>());
        },
        onResult: (handler, result) {
          expect(handler, isA<InvitationDeepLinkHandler>());
          expect(result.isSuccess, true);
        },
        onError: (error) {
          expect(error, isNull);
        },
      );
    });

    test('login deep link handler', () {
      final uri =
          Uri.parse('universalworkspace-flutter://login-callback#access_token=123');
      expect(LoginDeepLinkHandler().canHandle(uri), true);
    });

    test('payment deep link handler', () {
      final uri = Uri.parse('universalworkspace-flutter://payment-success');
      expect(PaymentDeepLinkHandler().canHandle(uri), true);
    });

    test('unknown deep link handler', () {
      final uri =
          Uri.parse('universalworkspace-flutter://unknown-callback?workspace_id=123');
      deepLinkHandlerRegistry.processDeepLink(
        uri: uri,
        onStateChange: (handler, state) {},
        onResult: (handler, result) {},
        onError: (error) {
          expect(error, isNotNull);
        },
      );
    });

    test('open app deep link handler', () {
      final uri = Uri.parse('universalworkspace-flutter://');
      expect(OpenAppDeepLinkHandler().canHandle(uri), true);
    });
  });
}
