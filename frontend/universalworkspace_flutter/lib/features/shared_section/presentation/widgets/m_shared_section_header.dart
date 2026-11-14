import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';

class MSharedSectionHeader extends StatelessWidget {
  const MSharedSectionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const HSpace(HomeSpaceViewSizes.mHorizontalPadding),
          UniflowSvg(
            UniflowSvgs.shared_with_me_m,
            color: theme.badgeColorScheme.color13Thick2,
          ),
          const HSpace(10.0),
          UniflowText.medium(
            LocaleKeys.shareSection_shared.tr(),
            lineHeight: 1.15,
            fontSize: 16.0,
          ),
          const HSpace(HomeSpaceViewSizes.mHorizontalPadding),
        ],
      ),
    );
  }
}
