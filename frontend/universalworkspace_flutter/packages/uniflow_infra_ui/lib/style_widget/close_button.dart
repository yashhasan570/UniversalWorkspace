import 'package:flutter/material.dart';

class UniflowCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const UniflowCloseButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: const Icon(Icons.close));
  }
}
