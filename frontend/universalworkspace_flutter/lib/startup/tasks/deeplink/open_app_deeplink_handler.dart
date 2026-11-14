import 'dart:async';

import 'package:universalworkspace/startup/tasks/deeplink/deeplink_handler.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class OpenAppDeepLinkHandler extends DeepLinkHandler<void> {
  @override
  bool canHandle(Uri uri) {
    return uri.toString() == 'universalworkspace-flutter://';
  }

  @override
  Future<UniflowResult<void, UniflowError>> handle({
    required Uri uri,
    required DeepLinkStateHandler onStateChange,
  }) async {
    return UniflowResult.success(null);
  }
}
