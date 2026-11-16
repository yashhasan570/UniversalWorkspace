import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'universalworkspace_backend_platform_interface.dart';

/// An implementation of [UniversalWorkspaceBackendPlatform] that uses method channels.
class MethodChannelUniflowSdk extends UniversalWorkspaceBackendPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('universalworkspace_backend');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
