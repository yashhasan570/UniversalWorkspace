import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MobileSlideActionButton extends StatelessWidget {
  const MobileSlideActionButton({
    super.key,
    required this.svg,
    this.size = 32.0,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = BorderRadius.zero,
    required this.onPressed,
  });

  final UniflowSvgData svg;
  final double size;
  final Color backgroundColor;
  final SlidableActionCallback onPressed;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      onPressed: (context) {
        HapticFeedback.mediumImpact();
        onPressed(context);
      },
      padding: EdgeInsets.zero,
      child: UniflowSvg(
        svg,
        size: Size.square(size),
        color: Colors.white,
      ),
    );
  }
}
