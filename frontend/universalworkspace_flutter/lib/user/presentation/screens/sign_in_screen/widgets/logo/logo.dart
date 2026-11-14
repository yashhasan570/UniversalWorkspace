import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:flutter/material.dart';

class AFLogo extends StatelessWidget {
  const AFLogo({
    super.key,
    this.size = const Size.square(36),
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return UniflowSvg(
      UniflowSvgs.app_logo_xl,
      blendMode: null,
      size: size,
    );
  }
}
