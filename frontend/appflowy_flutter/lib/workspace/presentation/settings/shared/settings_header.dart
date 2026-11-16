import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

/// Renders a simple header for the settings view
///
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
    required this.title,
    this.description,
    this.descriptionBuilder,
  });

  final String title;
  final String? description;
  final WidgetBuilder? descriptionBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textStyle.heading2.enhanced(
            color: theme.textColorScheme.primary,
          ),
        ),
        if (descriptionBuilder != null) ...[
          VSpace(theme.spacing.xs),
          descriptionBuilder!(context),
        ] else if (description?.isNotEmpty == true) ...[
          VSpace(theme.spacing.xs),
          Text(
            description!,
            maxLines: 4,
            style: theme.textStyle.caption.standard(
              color: theme.textColorScheme.secondary,
            ),
          ),
        ],
      ],
    );
  }
}
