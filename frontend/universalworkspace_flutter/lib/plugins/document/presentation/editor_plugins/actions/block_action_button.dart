import 'dart:io';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class BlockActionButton extends StatelessWidget {
  const BlockActionButton({
    super.key,
    required this.svg,
    required this.richMessage,
    required this.onTap,
    this.showTooltip = true,
    this.onPointerDown,
  });

  final UniflowSvgData svg;
  final bool showTooltip;
  final InlineSpan richMessage;
  final VoidCallback onTap;
  final VoidCallback? onPointerDown;

  @override
  Widget build(BuildContext context) {
    return UniflowTooltip(
      richMessage: showTooltip ? richMessage : null,
      child: UniflowIconButton(
        width: 18.0,
        hoverColor: Colors.transparent,
        iconColorOnHover: Theme.of(context).iconTheme.color,
        onPressed: onTap,
        icon: MouseRegion(
          cursor: Platform.isWindows
              ? SystemMouseCursors.click
              : SystemMouseCursors.grab,
          child: UniflowSvg(
            svg,
            size: const Size.square(18.0),
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
