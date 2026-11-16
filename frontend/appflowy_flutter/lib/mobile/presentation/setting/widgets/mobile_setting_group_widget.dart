import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class MobileSettingGroup extends StatelessWidget {
  const MobileSettingGroup({
    required this.groupTitle,
    required this.settingItemList,
    this.showDivider = true,
    super.key,
  });

  final String groupTitle;
  final List<Widget> settingItemList;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VSpace(theme.spacing.s),
        Text(
          groupTitle,
          style: theme.textStyle.heading4.enhanced(
            color: theme.textColorScheme.primary,
          ),
        ),
        VSpace(theme.spacing.s),
        ...settingItemList,
        showDivider
            ? AFDivider(spacing: theme.spacing.m)
            : const SizedBox.shrink(),
      ],
    );
  }
}
