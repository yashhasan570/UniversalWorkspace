import 'package:universalworkspace/core/config/kv.dart';
import 'package:universalworkspace/core/config/kv_keys.dart';
import 'package:universalworkspace/env/backend_env.dart';
import 'package:universalworkspace/env/env.dart';
import 'package:universalworkspace/plugins/shared/share/constants.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace_backend/log.dart';

/// Sets the cloud type for the application.
///
/// This method updates the cloud type setting in the key-value storage
/// using the [KeyValueStorage] service. The cloud type is identified
/// by the [AuthenticatorType] enum.
///
/// [ty] - The type of cloud to be set. It must be one of the values from
/// [AuthenticatorType] enum. The corresponding integer value of the enum is stored:
/// - `CloudType.local` is stored as "0".
/// - `CloudType.universalworkspaceCloud` is stored as "2".
///
/// The gap between [AuthenticatorType.local] and [AuthenticatorType.universalworkspaceCloud] is
/// due to previously supporting Supabase, this has been deprecated since and removed.
/// To not cause conflicts with older clients, we keep the gap.
///
Future<void> _setAuthenticatorType(AuthenticatorType ty) async {
  switch (ty) {
    case AuthenticatorType.local:
      await getIt<KeyValueStorage>().set(KVKeys.kCloudType, 0.toString());
      break;
    case AuthenticatorType.universalworkspaceCloud:
      await getIt<KeyValueStorage>().set(KVKeys.kCloudType, 2.toString());
      break;
    case AuthenticatorType.universalworkspaceCloudSelfHost:
      await getIt<KeyValueStorage>().set(KVKeys.kCloudType, 3.toString());
      break;
    case AuthenticatorType.universalworkspaceCloudDevelop:
      await getIt<KeyValueStorage>().set(KVKeys.kCloudType, 4.toString());
      break;
  }
}

const String kUniversalWorkspaceCloudUrl = "https://beta.universalworkspace.cloud";

/// Retrieves the currently set cloud type.
///
/// This method fetches the cloud type setting from the key-value storage
/// using the [KeyValueStorage] service and returns the corresponding
/// [AuthenticatorType] enum value.
///
/// Returns:
/// A Future that resolves to a [AuthenticatorType] enum value representing the
/// currently set cloud type. The default return value is `CloudType.local`
/// if no valid setting is found.
///
Future<AuthenticatorType> getAuthenticatorType() async {
  final value = await getIt<KeyValueStorage>().get(KVKeys.kCloudType);
  if (value == null && !integrationMode().isUnitTest) {
    // if the cloud type is not set, then set it to UniversalWorkspace Cloud as default.
    await useUniversalWorkspaceBetaCloudWithURL(
      kUniversalWorkspaceCloudUrl,
      AuthenticatorType.universalworkspaceCloud,
    );
    return AuthenticatorType.universalworkspaceCloud;
  }

  switch (value ?? "0") {
    case "0":
      return AuthenticatorType.local;
    case "2":
      return AuthenticatorType.universalworkspaceCloud;
    case "3":
      return AuthenticatorType.universalworkspaceCloudSelfHost;
    case "4":
      return AuthenticatorType.universalworkspaceCloudDevelop;
    default:
      await useUniversalWorkspaceBetaCloudWithURL(
        kUniversalWorkspaceCloudUrl,
        AuthenticatorType.universalworkspaceCloud,
      );
      return AuthenticatorType.universalworkspaceCloud;
  }
}

/// Determines whether authentication is enabled.
///
/// This getter evaluates if authentication should be enabled based on the
/// current integration mode and cloud type settings.
///
/// Returns:
/// A boolean value indicating whether authentication is enabled. It returns
/// `true` if the application is in release or develop mode, and the cloud type
/// is not set to `CloudType.local`. Additionally, it checks if either the
/// UniversalWorkspace Cloud configuration is valid.
/// Returns `false` otherwise.
bool get isAuthEnabled {
  final env = getIt<UniversalWorkspaceCloudSharedEnv>();
  if (env.authenticatorType.isUniversalWorkspaceCloudEnabled) {
    return env.universalworkspaceCloudConfig.isValid;
  }

  return false;
}

bool get isLocalAuthEnabled {
  return currentCloudType().isLocal;
}

/// Determines if UniversalWorkspace Cloud is enabled.
bool get isUniversalWorkspaceCloudEnabled {
  return currentCloudType().isUniversalWorkspaceCloudEnabled;
}

enum AuthenticatorType {
  local,
  universalworkspaceCloud,
  universalworkspaceCloudSelfHost,
  // The 'universalworkspaceCloudDevelop' type is used for develop purposes only.
  universalworkspaceCloudDevelop;

  bool get isLocal => this == AuthenticatorType.local;

  bool get isUniversalWorkspaceCloudEnabled =>
      this == AuthenticatorType.universalworkspaceCloudSelfHost ||
      this == AuthenticatorType.universalworkspaceCloudDevelop ||
      this == AuthenticatorType.universalworkspaceCloud;

  int get value {
    switch (this) {
      case AuthenticatorType.local:
        return 0;
      case AuthenticatorType.universalworkspaceCloud:
        return 2;
      case AuthenticatorType.universalworkspaceCloudSelfHost:
        return 3;
      case AuthenticatorType.universalworkspaceCloudDevelop:
        return 4;
    }
  }

  static AuthenticatorType fromValue(int value) {
    switch (value) {
      case 0:
        return AuthenticatorType.local;
      case 2:
        return AuthenticatorType.universalworkspaceCloud;
      case 3:
        return AuthenticatorType.universalworkspaceCloudSelfHost;
      case 4:
        return AuthenticatorType.universalworkspaceCloudDevelop;
      default:
        return AuthenticatorType.local;
    }
  }
}

AuthenticatorType currentCloudType() {
  return getIt<UniversalWorkspaceCloudSharedEnv>().authenticatorType;
}

Future<void> _setUniversalWorkspaceCloudUrl(String? url) async {
  await getIt<KeyValueStorage>().set(KVKeys.kUniversalWorkspaceCloudBaseURL, url ?? '');
}

Future<void> useBaseWebDomain(String? url) async {
  await getIt<KeyValueStorage>().set(
    KVKeys.kUniversalWorkspaceBaseShareDomain,
    url ?? ShareConstants.defaultBaseWebDomain,
  );
}

Future<void> useSelfHostedUniversalWorkspaceCloud(String url) async {
  await _setAuthenticatorType(AuthenticatorType.universalworkspaceCloudSelfHost);
  await _setUniversalWorkspaceCloudUrl(url);
}

Future<void> useUniversalWorkspaceCloudDevelop(String url) async {
  await _setAuthenticatorType(AuthenticatorType.universalworkspaceCloudDevelop);
  await _setUniversalWorkspaceCloudUrl(url);
}

Future<void> useUniversalWorkspaceBetaCloudWithURL(
  String url,
  AuthenticatorType authenticatorType,
) async {
  await _setAuthenticatorType(authenticatorType);
  await _setUniversalWorkspaceCloudUrl(url);
}

Future<void> useLocalServer() async {
  await _setAuthenticatorType(AuthenticatorType.local);
}

// Use getIt<UniversalWorkspaceCloudSharedEnv>() to get the shared environment.
class UniversalWorkspaceCloudSharedEnv {
  UniversalWorkspaceCloudSharedEnv({
    required AuthenticatorType authenticatorType,
    required this.universalworkspaceCloudConfig,
  }) : _authenticatorType = authenticatorType;

  final AuthenticatorType _authenticatorType;
  final UniversalWorkspaceCloudConfiguration universalworkspaceCloudConfig;

  AuthenticatorType get authenticatorType => _authenticatorType;

  static Future<UniversalWorkspaceCloudSharedEnv> fromEnv() async {
    // If [Env.enableCustomCloud] is true, then use the custom cloud configuration.
    if (Env.enableCustomCloud) {
      // Use the custom cloud configuration.
      var authenticatorType = await getAuthenticatorType();

      final universalworkspaceCloudConfig = authenticatorType.isUniversalWorkspaceCloudEnabled
          ? await getUniversalWorkspaceCloudConfig(authenticatorType)
          : UniversalWorkspaceCloudConfiguration.defaultConfig();

      // In the backend, the value '2' represents the use of UniversalWorkspace Cloud. However, in the frontend,
      // we distinguish between [AuthenticatorType.universalworkspaceCloudSelfHost] and [AuthenticatorType.universalworkspaceCloud].
      // When the cloud type is [AuthenticatorType.universalworkspaceCloudSelfHost] in the frontend, it should be
      // converted to [AuthenticatorType.universalworkspaceCloud] to align with the backend representation,
      // where both types are indicated by the value '2'.
      if (authenticatorType.isUniversalWorkspaceCloudEnabled) {
        authenticatorType = AuthenticatorType.universalworkspaceCloud;
      }
      return UniversalWorkspaceCloudSharedEnv(
        authenticatorType: authenticatorType,
        universalworkspaceCloudConfig: universalworkspaceCloudConfig,
      );
    } else {
      // Using the cloud settings from the .env file.
      final universalworkspaceCloudConfig = UniversalWorkspaceCloudConfiguration(
        base_url: Env.afCloudUrl,
        ws_base_url: await _getUniversalWorkspaceCloudWSUrl(Env.afCloudUrl),
        gotrue_url: await _getUniversalWorkspaceCloudGotrueUrl(Env.afCloudUrl),
        enable_sync_trace: false,
        base_web_domain: Env.baseWebDomain,
      );

      return UniversalWorkspaceCloudSharedEnv(
        authenticatorType: AuthenticatorType.fromValue(Env.authenticatorType),
        universalworkspaceCloudConfig: universalworkspaceCloudConfig,
      );
    }
  }

  @override
  String toString() {
    return 'authenticator: $_authenticatorType\n'
        'universalworkspace: ${universalworkspaceCloudConfig.toJson()}\n';
  }
}

Future<UniversalWorkspaceCloudConfiguration> configurationFromUri(
  Uri baseUri,
  String baseUrl,
  AuthenticatorType authenticatorType,
  String baseShareDomain,
) async {
  // In development mode, the app is configured to access the UniversalWorkspace cloud server directly through specific ports.
  // This setup bypasses the need for Nginx, meaning that the UniversalWorkspace cloud should be running without an Nginx server
  // in the development environment.
  // If you modify following code, please update the corresponding documentation in the universalworkspace billing.
  if (authenticatorType == AuthenticatorType.universalworkspaceCloudDevelop) {
    return UniversalWorkspaceCloudConfiguration(
      base_url: "$baseUrl:8000",
      ws_base_url: "ws://${baseUri.host}:8000/ws/v1",
      gotrue_url: "$baseUrl:9999",
      enable_sync_trace: true,
      base_web_domain: ShareConstants.testBaseWebDomain,
    );
  } else {
    return UniversalWorkspaceCloudConfiguration(
      base_url: baseUrl,
      ws_base_url: await _getUniversalWorkspaceCloudWSUrl(baseUrl),
      gotrue_url: await _getUniversalWorkspaceCloudGotrueUrl(baseUrl),
      enable_sync_trace: await getSyncLogEnabled(),
      base_web_domain: authenticatorType == AuthenticatorType.universalworkspaceCloud
          ? ShareConstants.defaultBaseWebDomain
          : baseShareDomain,
    );
  }
}

Future<UniversalWorkspaceCloudConfiguration> getUniversalWorkspaceCloudConfig(
  AuthenticatorType authenticatorType,
) async {
  final baseURL = await getUniversalWorkspaceCloudUrl();
  final baseShareDomain = await getUniversalWorkspaceShareDomain();

  try {
    final uri = Uri.parse(baseURL);
    return await configurationFromUri(
      uri,
      baseURL,
      authenticatorType,
      baseShareDomain,
    );
  } catch (e) {
    Log.error("Failed to parse UniversalWorkspace Cloud URL: $e");
    return UniversalWorkspaceCloudConfiguration.defaultConfig();
  }
}

Future<String> getUniversalWorkspaceCloudUrl() async {
  final result =
      await getIt<KeyValueStorage>().get(KVKeys.kUniversalWorkspaceCloudBaseURL);
  return result ?? kUniversalWorkspaceCloudUrl;
}

Future<String> getUniversalWorkspaceShareDomain() async {
  final result =
      await getIt<KeyValueStorage>().get(KVKeys.kUniversalWorkspaceBaseShareDomain);
  return result ?? ShareConstants.defaultBaseWebDomain;
}

Future<bool> getSyncLogEnabled() async {
  final result =
      await getIt<KeyValueStorage>().get(KVKeys.kUniversalWorkspaceEnableSyncTrace);

  if (result == null) {
    return false;
  }

  return result.toLowerCase() == "true";
}

Future<void> setSyncLogEnabled(bool enable) async {
  await getIt<KeyValueStorage>().set(
    KVKeys.kUniversalWorkspaceEnableSyncTrace,
    enable.toString().toLowerCase(),
  );
}

Future<String> _getUniversalWorkspaceCloudWSUrl(String baseURL) async {
  try {
    final uri = Uri.parse(baseURL);

    // Construct the WebSocket URL directly from the parsed URI.
    final wsScheme = uri.isScheme('HTTPS') ? 'wss' : 'ws';
    final wsUrl =
        Uri(scheme: wsScheme, host: uri.host, port: uri.port, path: '/ws/v1');

    return wsUrl.toString();
  } catch (e) {
    Log.error("Failed to get WebSocket URL: $e");
    return "";
  }
}

Future<String> _getUniversalWorkspaceCloudGotrueUrl(String baseURL) async {
  return "$baseURL/gotrue";
}
