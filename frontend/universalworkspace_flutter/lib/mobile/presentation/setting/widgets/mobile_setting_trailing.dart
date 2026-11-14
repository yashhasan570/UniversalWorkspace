import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';

class MobileSettingTrailing extends StatelessWidget {
  const MobileSettingTrailing({
    super.key,
    required this.text,
    this.showArrow = true,
  });

  final String text;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            style: theme.textStyle.heading4.standard(
              color: theme.textColorScheme.secondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showArrow) ...[
          const HSpace(8),
          UniflowSvg(
            UniflowSvgs.toolbar_arrow_right_m,
            size: Size.square(24),
            color: theme.iconColorScheme.tertiary,
          ),
        ],
      ],
    );
  }
}
