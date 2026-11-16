import 'package:uniflow_infra/size.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:flutter/material.dart';

class UniflowToolbarButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final String? tooltip;

  const UniflowToolbarButton({
    super.key,
    this.onPressed,
    this.tooltip,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tooltipMessage = tooltip ?? '';

    return UniflowTooltip(
      message: tooltipMessage,
      padding: EdgeInsets.zero,
      child: RawMaterialButton(
        clipBehavior: Clip.antiAlias,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 32),
        hoverElevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Corners.s6Border),
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        elevation: 0,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
