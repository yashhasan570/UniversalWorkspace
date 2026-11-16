import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:flutter/material.dart';

class AnonymousSignInButton extends StatelessWidget {
  const AnonymousSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AFGhostButton.normal(
      onTap: () {},
      builder: (context, isHovering, disabled) {
        return const Placeholder();
      },
    );
  }
}
