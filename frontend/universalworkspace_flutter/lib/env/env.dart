// lib/env/env.dart
import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/plugins/shared/share/constants.dart';
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  // This flag is used to decide if users can dynamically configure cloud settings. It turns true when a .env file exists containing the UNIVERSALWORKSPACE_CLOUD_URL variable. By default, this is set to false.
  static bool get enableCustomCloud {
    return Env.authenticatorType ==
            AuthenticatorType.universalworkspaceCloudSelfHost.value ||
        Env.authenticatorType == AuthenticatorType.universalworkspaceCloud.value ||
        Env.authenticatorType == AuthenticatorType.universalworkspaceCloudDevelop.value &&
            _Env.afCloudUrl.isEmpty;
  }

  @EnviedField(
    obfuscate: false,
    varName: 'AUTHENTICATOR_TYPE',
    defaultValue: 2,
  )
  static const int authenticatorType = _Env.authenticatorType;

  /// UniversalWorkspace Cloud Configuration
  @EnviedField(
    obfuscate: false,
    varName: 'UNIVERSALWORKSPACE_CLOUD_URL',
    defaultValue: '',
  )
  static const String afCloudUrl = _Env.afCloudUrl;

  @EnviedField(
    obfuscate: false,
    varName: 'INTERNAL_BUILD',
    defaultValue: '',
  )
  static const String internalBuild = _Env.internalBuild;

  @EnviedField(
    obfuscate: false,
    varName: 'SENTRY_DSN',
    defaultValue: '',
  )
  static const String sentryDsn = _Env.sentryDsn;

  @EnviedField(
    obfuscate: false,
    varName: 'BASE_WEB_DOMAIN',
    defaultValue: ShareConstants.defaultBaseWebDomain,
  )
  static const String baseWebDomain = _Env.baseWebDomain;
}
