import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:flutter/material.dart';

class RefreshSharedSectionButton extends StatelessWidget {
  const RefreshSharedSectionButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return AFTextMenuItem(
      leading: Icon(
        Icons.refresh,
        size: 20,
        color: theme.iconColorScheme.secondary,
      ),
      title: 'Refresh',
      onTap: onTap,
    );
  }
}
