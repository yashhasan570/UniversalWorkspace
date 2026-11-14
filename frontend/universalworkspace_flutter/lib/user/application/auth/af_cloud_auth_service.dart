import 'dart:async';

import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/startup/tasks/universalworkspace_cloud_task.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/application/auth/backend_auth_service.dart';
import 'package:universalworkspace/user/application/user_service.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth_error.dart';

class UniversalWorkspaceCloudAuthService implements AuthService {
  UniversalWorkspaceCloudAuthService();

  final BackendAuthService _backendAuthService = BackendAuthService(
    AuthTypePB.Server,
  );

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
    return _backendAuthService.signInWithEmailPassword(
      email: email,
      password: password,
      params: params,
    );
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUpWithOAuth({
    required String platform,
    Map<String, String> params = const {},
  }) async {
    final provider = ProviderTypePBExtension.fromPlatform(platform);

    // Get the oauth url from the backend
    final result = await UserEventGetOauthURLWithProvider(
      OauthProviderPB.create()..provider = provider,
    ).send();

    return result.fold(
      (data) async {
        // Open the webview with oauth url
        final uri = Uri.parse(data.oauthUrl);
        final isSuccess = await afLaunchUri(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_self',
        );

        final completer = Completer<UniflowResult<UserProfilePB, UniflowError>>();
        if (isSuccess) {
          // The [UniversalWorkspaceCloudDeepLink] must be registered before using the
          // [UniversalWorkspaceCloudAuthService].
          if (getIt.isRegistered<UniversalWorkspaceCloudDeepLink>()) {
            getIt<UniversalWorkspaceCloudDeepLink>().registerCompleter(completer);
          } else {
            throw Exception('UniversalWorkspaceCloudDeepLink is not registered');
          }
        } else {
          completer.complete(
            UniflowResult.failure(AuthError.unableToGetDeepLink),
          );
        }

        return completer.future;
      },
      (r) => UniflowResult.failure(r),
    );
  }

  @override
  Future<void> signOut() async {
    await _backendAuthService.signOut();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signUpAsGuest({
    Map<String, String> params = const {},
  }) async {
    return _backendAuthService.signUpAsGuest();
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> signInWithMagicLink({
    required String email,
    Map<String, String> params = const {},
  }) async {
    return _backendAuthService.signInWithMagicLink(
      email: email,
      params: params,
    );
  }

  @override
  Future<UniflowResult<GotrueTokenResponsePB, UniflowError>> signInWithPasscode({
    required String email,
    required String passcode,
  }) async {
    return _backendAuthService.signInWithPasscode(
      email: email,
      passcode: passcode,
    );
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> getUser() async {
    return UserBackendService.getCurrentUserProfile();
  }
}

extension ProviderTypePBExtension on ProviderTypePB {
  static ProviderTypePB fromPlatform(String platform) {
    switch (platform) {
      case 'github':
        return ProviderTypePB.Github;
      case 'google':
        return ProviderTypePB.Google;
      case 'discord':
        return ProviderTypePB.Discord;
      case 'apple':
        return ProviderTypePB.Apple;
      default:
        throw UnimplementedError();
    }
  }
}
