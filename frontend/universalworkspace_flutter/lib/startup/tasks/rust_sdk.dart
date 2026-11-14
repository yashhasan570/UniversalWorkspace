import 'dart:convert';
import 'dart:io';

import 'package:universalworkspace/env/backend_env.dart';
import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/user/application/auth/device_id.dart';
import 'package:universalworkspace_backend/universalworkspace_backend.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../startup.dart';

class InitRustSDKTask extends LaunchTask {
  const InitRustSDKTask({
    this.customApplicationPath,
  });

  // Customize the RustSDK initialization path
  final Directory? customApplicationPath;

  @override
  LaunchTaskType get type => LaunchTaskType.dataProcessing;

  @override
  Future<void> initialize(LaunchContext context) async {
    await super.initialize(context);

    final root = await getApplicationSupportDirectory();
    final applicationPath = await appUniflowApplicationDataDirectory();
    final dir = customApplicationPath ?? applicationPath;
    final deviceId = await getDeviceId();

    // Pass the environment variables to the Rust SDK
    final env = _makeUniversalWorkspaceConfiguration(
      root.path,
      context.config.version,
      dir.path,
      applicationPath.path,
      deviceId,
      rustEnvs: context.config.rustEnvs,
    );
    await context.getIt<UniflowSDK>().init(jsonEncode(env.toJson()));
  }
}

UniversalWorkspaceConfiguration _makeUniversalWorkspaceConfiguration(
  String root,
  String appVersion,
  String customAppPath,
  String originAppPath,
  String deviceId, {
  required Map<String, String> rustEnvs,
}) {
  final env = getIt<UniversalWorkspaceCloudSharedEnv>();
  return UniversalWorkspaceConfiguration(
    root: root,
    app_version: appVersion,
    custom_app_path: customAppPath,
    origin_app_path: originAppPath,
    device_id: deviceId,
    platform: Platform.operatingSystem,
    authenticator_type: env.authenticatorType.value,
    universalworkspace_cloud_config: env.universalworkspaceCloudConfig,
    envs: rustEnvs,
  );
}

/// The default directory to store the user data. The directory can be
/// customized by the user via the [ApplicationDataStorage]
Future<Directory> appUniflowApplicationDataDirectory() async {
  switch (integrationMode()) {
    case IntegrationMode.develop:
      final Directory documentsDir = await getApplicationSupportDirectory()
          .then((directory) => directory.create());
      return Directory(path.join(documentsDir.path, 'data_dev'));
    case IntegrationMode.release:
      final Directory documentsDir = await getApplicationSupportDirectory();
      return Directory(path.join(documentsDir.path, 'data'));
    case IntegrationMode.unitTest:
    case IntegrationMode.integrationTest:
      return Directory(path.join(Directory.current.path, '.sandbox'));
  }
}
