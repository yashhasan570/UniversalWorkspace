import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui_web.dart';
import 'package:flutter/material.dart';

import 'home/home_screen.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      builder: overlayManagerBuilder,
      title: "Uniflow Infra Title",
      home: HomeScreen(),
    );
  }
}
