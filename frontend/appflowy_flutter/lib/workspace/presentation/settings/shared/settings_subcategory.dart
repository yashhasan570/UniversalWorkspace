import 'package:flutter/material.dart';

import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';

/// Renders a simple category taking a title and the list
/// of children (settings) to be rendered.
///
class SettingsSubcategory extends StatelessWidget {
  const SettingsSubcategory({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UniflowText.medium(
          title,
          color: AFThemeExtension.of(context).secondaryTextColor,
          maxLines: 2,
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
        ),
        const VSpace(8),
        SeparatedColumn(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: () =>
              children.length > 1 ? const VSpace(16) : const SizedBox.shrink(),
          children: children,
        ),
      ],
    );
  }
}
