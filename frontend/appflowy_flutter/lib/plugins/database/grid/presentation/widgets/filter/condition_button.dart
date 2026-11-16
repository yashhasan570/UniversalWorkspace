import 'dart:math' as math;
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:uniflow_infra/size.dart';
import 'package:uniflow_infra/theme_extension.dart';

import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';

class ConditionButton extends StatelessWidget {
  const ConditionButton({
    super.key,
    required this.conditionName,
    required this.onTap,
  });

  final String conditionName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final arrow = Transform.rotate(
      angle: -math.pi / 2,
      child: UniflowSvg(
        UniflowSvgs.arrow_left_s,
        color: AFThemeExtension.of(context).textColor,
      ),
    );

    return SizedBox(
      height: 20,
      child: UniflowButton(
        useIntrinsicWidth: true,
        text: UniflowText(
          lineHeight: 1.0,
          conditionName,
          fontSize: 10,
          color: AFThemeExtension.of(context).textColor,
          overflow: TextOverflow.ellipsis,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        radius: Corners.s6Border,
        rightIcon: arrow,
        hoverColor: AFThemeExtension.of(context).lightGreyHover,
        onTap: onTap,
      ),
    );
  }
}
