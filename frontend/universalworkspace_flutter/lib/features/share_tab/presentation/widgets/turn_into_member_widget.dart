import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:flutter/material.dart';

class TurnIntoMemberWidget extends StatelessWidget {
  const TurnIntoMemberWidget({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return UniflowTooltip(
      message: LocaleKeys.shareTab_turnIntoMember.tr(),
      child: AFGhostButton.normal(
        onTap: onTap,
        padding: EdgeInsets.all(theme.spacing.s),
        builder: (context, isHovering, disabled) {
          return UniflowSvg(UniflowSvgs.turn_into_member_m);
        },
      ),
    );
  }
}
