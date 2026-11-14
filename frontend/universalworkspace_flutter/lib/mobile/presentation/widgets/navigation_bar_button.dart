import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class NavigationBarButton extends StatelessWidget {
  const NavigationBarButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.enable = true,
  });

  final String text;
  final UniflowSvgData icon;
  final VoidCallback onTap;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enable ? 1.0 : 0.3,
      child: Container(
        height: 40,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0x3F1F2329)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: UniflowButton(
          useIntrinsicWidth: true,
          expandText: false,
          iconPadding: 8,
          leftIcon: UniflowSvg(icon),
          onTap: enable ? onTap : null,
          text: UniflowText(
            text,
            fontSize: 15.0,
            figmaLineHeight: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
