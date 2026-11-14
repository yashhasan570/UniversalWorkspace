import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'universalworkspace_backend_method_channel.dart';

abstract class UniversalWorkspaceBackendPlatform extends PlatformInterface {
  /// Constructs a UniflowSdkPlatform.
  UniversalWorkspaceBackendPlatform() : super(token: _token);

  static final Object _token = Object();

  static UniversalWorkspaceBackendPlatform _instance = MethodChannelUniflowSdk();

  /// The default instance of [UniversalWorkspaceBackendPlatform] to use.
  ///
  /// Defaults to [MethodChannelUniflowSdk].
  static UniversalWorkspaceBackendPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UniversalWorkspaceBackendPlatform] when
  /// they register themselves.
  static set instance(UniversalWorkspaceBackendPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
