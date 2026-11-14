library uniflow_infra_ui_web;

import 'dart:html' as html show window;
import 'package:uniflow_infra_ui_platform_interface/uniflow_infra_ui_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class UniflowInfraUIPlugin extends UniflowInfraUIPlatform {
  static void registerWith(Registrar registrar) {
    UniflowInfraUIPlatform.instance = UniflowInfraUIPlugin();
  }

  // MARK: - Keyboard

  @override
  Stream<bool> get onKeyboardVisibilityChange async* {
    // suppose that keyboard won't show in web side
    yield false;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}
