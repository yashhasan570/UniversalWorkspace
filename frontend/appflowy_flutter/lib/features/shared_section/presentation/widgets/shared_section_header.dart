import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SharedSectionHeader extends StatelessWidget {
  const SharedSectionHeader({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return AFGhostIconTextButton.primary(
      text: LocaleKeys.shareSection_shared.tr(),
      mainAxisAlignment: MainAxisAlignment.start,
      size: AFButtonSize.l,
      onTap: onTap,
      // todo: ask the designer to provide the token.
      padding: EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
      borderRadius: theme.borderRadius.s,
      iconBuilder: (context, isHover, disabled) => UniflowSvg(
        UniflowSvgs.shared_with_me_m,
        color: theme.badgeColorScheme.color13Thick2,
      ),
    );
  }
}
