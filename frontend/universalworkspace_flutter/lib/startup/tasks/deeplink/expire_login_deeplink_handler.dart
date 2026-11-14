import 'dart:async';

import 'package:universalworkspace/startup/tasks/deeplink/deeplink_handler.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// Expire login deeplink example:
/// universalworkspace-flutter:%23error=access_denied&error_code=403&error_description=Email+link+is+invalid+or+has+expired
class ExpireLoginDeepLinkHandler extends DeepLinkHandler<void> {
  @override
  bool canHandle(Uri uri) {
    final isExpireLogin = uri.toString().contains('error=access_denied');
    if (!isExpireLogin) {
      return false;
    }

    return true;
  }

  @override
  Future<UniflowResult<void, UniflowError>> handle({
    required Uri uri,
    required DeepLinkStateHandler onStateChange,
  }) async {
    return UniflowResult.failure(
      UniflowError(
        msg: 'Magic link is invalid or has expired',
      ),
    );
  }
}
