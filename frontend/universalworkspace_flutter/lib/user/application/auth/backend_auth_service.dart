import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/application/user_service.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/code.pbenum.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/auth.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart'
    show SignInPayloadPB, SignUpPayloadPB, UserProfilePB;
import 'package:universalworkspace_backend/protobuf/uniflow-user/workspace.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../generated/locale_keys.g.dart';
import 'device_id.dart';

class BackendAuthService implements AuthService {
  BackendAuthService(this.authType);

  final AuthTypePB authType;

  @override
  Future<UniflowResult<GotrueTokenResponsePB, UniflowError>>
      signInWithEmailPassword({
    required String email,
    required String password,
    Map<String, String> params = const {},
  }) async {
    final request = SignInPayloadPB.create()
      ..email = email
      ..password = password
      ..authType = authType
      ..deviceId = await getDeviceId();
    return UserEventSignInWithEmailPassword(request).send();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUp({
    required String name,
    required String email,
    required String password,
    Map<String, String> params = const {},
  }) async {
    final request = SignUpPayloadPB.create()
      ..name = name
      ..email = email
      ..password = password
      ..authType = authType
      ..deviceId = await getDeviceId();
    final response = await UserEventSignUp(request).send().then(
          (value) => value,
        );
    return response;
  }

  @override
  Future<void> signOut({
    Map<String, String> params = const {},
  }) async {
    await UserEventSignOut().send();
    return;
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUpAsGuest({
    Map<String, String> params = const {},
  }) async {
    const password = "Guest!@123456";
    final userEmail = "anon@universalworkspace.io";

    final request = SignUpPayloadPB.create()
      ..name = LocaleKeys.defaultUsername.tr()
      ..email = userEmail
      ..password = password
      // When sign up as guest, the auth type is always local.
      ..authType = AuthTypePB.Local
      ..deviceId = await getDeviceId();
    final response = await UserEventSignUp(request).send().then(
          (value) => value,
        );
    return response;
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUpWithOAuth({
    required String platform,
    AuthTypePB authType = AuthTypePB.Local,
    Map<String, String> params = const {},
  }) async {
    return UniflowResult.failure(
      UniflowError.create()
        ..code = ErrorCode.Internal
        ..msg = "Unsupported sign up action",
    );
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> getUser() async {
    return UserBackendService.getCurrentUserProfile();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signInWithMagicLink({
    required String email,
    Map<String, String> params = const {},
  }) async {
    // No need to pass the redirect URL.
    return UserBackendService.signInWithMagicLink(email, '');
  }

  @override
  Future<UniflowResult<GotrueTokenResponsePB, UniflowError>> signInWithPasscode({
    required String email,
    required String passcode,
  }) async {
    return UserBackendService.signInWithPasscode(email, passcode);
  }
}
