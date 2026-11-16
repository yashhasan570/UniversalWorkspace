import 'package:universalworkspace/features/share_tab/logic/share_tab_bloc.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpgradeToProWidget extends StatelessWidget {
  const UpgradeToProWidget({
    super.key,
    required this.onUpgrade,
    required this.onClose,
  });

  final VoidCallback onClose;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0x129327ff),
        borderRadius: BorderRadius.circular(theme.borderRadius.m),
      ),
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.m,
        horizontal: theme.spacing.l,
      ),
      margin: EdgeInsets.only(
        top: theme.spacing.l,
      ),
      child: Row(
        children: [
          UniflowSvg(
            UniflowSvgs.upgrade_pro_crown_m,
            blendMode: null,
          ),
          HSpace(
            theme.spacing.m,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.shareTab_upgrade.tr(),
                  style: theme.textStyle.caption.standard().copyWith(
                        color: theme.textColorScheme.featured,
                        decoration: TextDecoration.underline,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      onUpgrade();
                    },
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: LocaleKeys.shareTab_toProPlanToInviteGuests.tr(),
                  style: theme.textStyle.caption.standard().copyWith(
                        color: theme.textColorScheme.featured,
                      ),
                ),
              ],
            ),
          ),
          const Spacer(),
          AFGhostButton.normal(
            size: AFButtonSize.s,
            padding: EdgeInsets.all(theme.spacing.xs),
            onTap: () {
              context
                  .read<ShareTabBloc>()
                  .add(ShareTabEvent.upgradeToProClicked());
              onClose();
            },
            builder: (context, isHovering, disabled) => UniflowSvg(
              UniflowSvgs.upgrade_to_pro_close_m,
              size: const Size.square(20),
            ),
          ),
        ],
      ),
    );
  }
}
