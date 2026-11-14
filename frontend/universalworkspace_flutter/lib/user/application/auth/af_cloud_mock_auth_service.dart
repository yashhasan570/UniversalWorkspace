import 'dart:async';

import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/application/auth/backend_auth_service.dart';
import 'package:universalworkspace/user/application/auth/device_id.dart';
import 'package:universalworkspace/user/application/user_service.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/uuid.dart';
import 'package:flutter/material.dart';

/// Only used for testing.
class UniversalWorkspaceCloudMockAuthService implements AuthService {
  UniversalWorkspaceCloudMockAuthService({String? email})
      : userEmail = email ?? "${uuid()}@universalworkspace.io";

  final String userEmail;

  final BackendAuthService _appUniflowAuthService =
      BackendAuthService(AuthTypePB.Server);

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUp({
    required String name,
    required String email,
    required String password,
    Map<String, String> params = const {},
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<UniflowResult<GotrueTokenResponsePB, UniflowError>>
      signInWithEmailPassword({
    required String email,
    required String password,
    Map<String, String> params = const {},
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUpWithOAuth({
    required String platform,
    Map<String, String> params = const {},
  }) async {
    final payload = SignInUrlPayloadPB.create()
      ..authenticator = AuthTypePB.Server
      // don't use nanoid here, the gotrue server will transform the email
      ..email = userEmail;

    final deviceId = await getDeviceId();
    final getSignInURLResult = await UserEventGenerateSignInURL(payload).send();

    return getSignInURLResult.fold(
      (urlPB) async {
        final payload = OauthSignInPB(
          authType: AuthTypePB.Server,
          map: {
            AuthServiceMapKeys.signInURL: urlPB.signInUrl,
            AuthServiceMapKeys.deviceId: deviceId,
          },
        );
        Log.info("UserEventOauthSignIn with payload: $payload");
        return UserEventOauthSignIn(payload).send().then((value) {
          value.fold(
            (l) => null,
            (err) {
              debugPrint("mock auth service Error: $err");
              Log.error(err);
            },
          );
          return value;
        });
      },
      (r) {
        debugPrint("mock auth service error: $r");
        return UniflowResult.failure(r);
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _appUniflowAuthService.signOut();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUpAsGuest({
    Map<String, String> params = const {},
  }) async {
    return _appUniflowAuthService.signUpAsGuest();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signInWithMagicLink({
    required String email,
    Map<String, String> params = const {},
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> getUser() async {
    return UserBackendService.getCurrentUserProfile();
  }

  @override
  Future<UniflowResult<GotrueTokenResponsePB, UniflowError>> signInWithPasscode({
    required String email,
    required String passcode,
  }) async {
    throw UnimplementedError();
  }
}
