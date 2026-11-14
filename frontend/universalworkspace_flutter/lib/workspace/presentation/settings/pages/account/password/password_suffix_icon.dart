import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:flutter/material.dart';

class PasswordSuffixIcon extends StatelessWidget {
  const PasswordSuffixIcon({
    super.key,
    required this.isObscured,
    required this.onTap,
  });

  final bool isObscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(right: theme.spacing.m),
          child: UniflowSvg(
            isObscured ? UniflowSvgs.show_s : UniflowSvgs.hide_s,
            color: theme.textColorScheme.secondary,
            size: const Size.square(20),
          ),
        ),
      ),
    );
  }
}
