import 'package:universalworkspace/startup/launch_configuration.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class UniversalWorkspaceApplication implements EntryPoint {
  @override
  Widget create(LaunchConfiguration config) {
    return SplashScreen(isAnon: config.isAnon);
  }
}
