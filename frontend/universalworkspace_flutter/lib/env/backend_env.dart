// ignore_for_file: non_constant_identifier_names

import 'package:universalworkspace/plugins/shared/share/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'backend_env.g.dart';

@JsonSerializable()
class UniversalWorkspaceConfiguration {
  UniversalWorkspaceConfiguration({
    required this.root,
    required this.app_version,
    required this.custom_app_path,
    required this.origin_app_path,
    required this.device_id,
    required this.platform,
    required this.authenticator_type,
    required this.universalworkspace_cloud_config,
    required this.envs,
  });

  factory UniversalWorkspaceConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UniversalWorkspaceConfigurationFromJson(json);

  final String root;
  final String app_version;
  final String custom_app_path;
  final String origin_app_path;
  final String device_id;
  final String platform;
  final int authenticator_type;
  final UniversalWorkspaceCloudConfiguration universalworkspace_cloud_config;
  final Map<String, String> envs;

  Map<String, dynamic> toJson() => _$UniversalWorkspaceConfigurationToJson(this);
}

@JsonSerializable()
class UniversalWorkspaceCloudConfiguration {
  UniversalWorkspaceCloudConfiguration({
    required this.base_url,
    required this.ws_base_url,
    required this.gotrue_url,
    required this.enable_sync_trace,
    required this.base_web_domain,
  });

  factory UniversalWorkspaceCloudConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UniversalWorkspaceCloudConfigurationFromJson(json);

  final String base_url;
  final String ws_base_url;
  final String gotrue_url;
  final bool enable_sync_trace;

  /// The base domain is used in
  ///
  /// - Share URL
  /// - Publish URL
  /// - Copy Link To Block
  final String base_web_domain;

  Map<String, dynamic> toJson() => _$UniversalWorkspaceCloudConfigurationToJson(this);

  static UniversalWorkspaceCloudConfiguration defaultConfig() {
    return UniversalWorkspaceCloudConfiguration(
      base_url: '',
      ws_base_url: '',
      gotrue_url: '',
      enable_sync_trace: false,
      base_web_domain: ShareConstants.defaultBaseWebDomain,
    );
  }

  bool get isValid {
    return base_url.isNotEmpty &&
        ws_base_url.isNotEmpty &&
        gotrue_url.isNotEmpty;
  }
}
