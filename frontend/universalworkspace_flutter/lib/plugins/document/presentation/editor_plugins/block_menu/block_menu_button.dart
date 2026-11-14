import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class MenuBlockButton extends StatelessWidget {
  const MenuBlockButton({
    super.key,
    required this.tooltip,
    required this.iconData,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String tooltip;
  final UniflowSvgData iconData;

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      useIntrinsicWidth: true,
      onTap: onTap,
      text: UniflowTooltip(
        message: tooltip,
        child: UniflowSvg(
          iconData,
          size: const Size.square(16),
        ),
      ),
    );
  }
}
