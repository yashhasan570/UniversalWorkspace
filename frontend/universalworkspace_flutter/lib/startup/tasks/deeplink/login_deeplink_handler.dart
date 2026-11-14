import 'dart:async';

import 'package:universalworkspace/startup/tasks/deeplink/deeplink_handler.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/application/auth/device_id.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class LoginDeepLinkHandler extends DeepLinkHandler<UserProfilePB> {
  @override
  bool canHandle(Uri uri) {
    final containsAccessToken = uri.fragment.contains('access_token');
    if (!containsAccessToken) {
      return false;
    }

    return true;
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> handle({
    required Uri uri,
    required DeepLinkStateHandler onStateChange,
  }) async {
    final deviceId = await getDeviceId();
    final payload = OauthSignInPB(
      authType: AuthTypePB.Server,
      map: {
        AuthServiceMapKeys.signInURL: uri.toString(),
        AuthServiceMapKeys.deviceId: deviceId,
      },
    );

    onStateChange(this, DeepLinkState.loading);

    final result = await UserEventOauthSignIn(payload).send();

    onStateChange(this, DeepLinkState.finish);

    return result;
  }
}
