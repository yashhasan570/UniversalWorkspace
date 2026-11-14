import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:flutter/material.dart';

class SharedSectionLoading extends StatelessWidget {
  const SharedSectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Center(
      child: CircularProgressIndicator(
        color: theme.iconColorScheme.primary,
      ),
    );
  }
}
