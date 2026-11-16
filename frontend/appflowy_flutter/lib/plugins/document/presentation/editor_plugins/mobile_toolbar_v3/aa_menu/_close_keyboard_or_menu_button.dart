import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class CloseKeyboardOrMenuButton extends StatelessWidget {
  const CloseKeyboardOrMenuButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 42,
      child: UniflowButton(
        text: const UniflowSvg(
          UniflowSvgs.m_toolbar_keyboard_m,
        ),
        onTap: onPressed,
      ),
    );
  }
}
