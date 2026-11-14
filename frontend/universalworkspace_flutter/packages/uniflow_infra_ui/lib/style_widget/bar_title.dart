import 'package:flutter/material.dart';

class UniflowBarTitle extends StatelessWidget {
  final String title;

  const UniflowBarTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24),
    );
  }
}
