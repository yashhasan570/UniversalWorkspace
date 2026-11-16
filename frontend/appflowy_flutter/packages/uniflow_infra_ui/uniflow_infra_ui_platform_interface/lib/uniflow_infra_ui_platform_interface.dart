library uniflow_infra_ui_platform_interface;

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'src/method_channel_uniflow_infra_ui.dart';

abstract class UniflowInfraUIPlatform extends PlatformInterface {
  UniflowInfraUIPlatform() : super(token: _token);

  static final Object _token = Object();

  static UniflowInfraUIPlatform _instance = MethodChannelUniflowInfraUI();

  static UniflowInfraUIPlatform get instance => _instance;

  static set instance(UniflowInfraUIPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<bool> get onKeyboardVisibilityChange {
    throw UnimplementedError(
        '`onKeyboardChange` should be overridden by subclass.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError(
        '`getPlatformVersion` should be overridden by subclass.');
  }
}
