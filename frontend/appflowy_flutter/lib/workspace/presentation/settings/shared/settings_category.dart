import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

/// Renders a simple category taking a title and the list
/// of children (settings) to be rendered.
///
class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    super.key,
    required this.title,
    this.description,
    this.descriptionColor,
    this.tooltip,
    this.actions,
    required this.children,
  });

  final String title;
  final String? description;
  final Color? descriptionColor;
  final String? tooltip;
  final List<Widget>? actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: theme.textStyle.heading4.enhanced(
                color: theme.textColorScheme.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (tooltip != null) ...[
              const HSpace(4),
              UniflowTooltip(
                message: tooltip,
                child: const UniflowSvg(UniflowSvgs.information_s),
              ),
            ],
            const Spacer(),
            if (actions != null) ...actions!,
          ],
        ),
        const VSpace(16),
        if (description?.isNotEmpty ?? false) ...[
          UniflowText.regular(
            description!,
            maxLines: 4,
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
            color: descriptionColor,
          ),
          const VSpace(8),
        ],
        SeparatedColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          separatorBuilder: () =>
              children.length > 1 ? const VSpace(16) : const SizedBox.shrink(),
          children: children,
        ),
      ],
    );
  }
}
