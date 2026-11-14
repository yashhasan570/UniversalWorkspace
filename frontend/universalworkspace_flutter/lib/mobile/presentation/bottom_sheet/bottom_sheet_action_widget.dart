import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class BottomSheetActionWidget extends StatelessWidget {
  const BottomSheetActionWidget({
    super.key,
    this.svg,
    required this.text,
    required this.onTap,
    this.iconColor,
  });

  final UniflowSvgData? svg;
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        this.iconColor ?? AFThemeExtension.of(context).onBackground;

    if (svg == null) {
      return OutlinedButton(
        style: Theme.of(context)
            .outlinedButtonTheme
            .style
            ?.copyWith(alignment: Alignment.center),
        onPressed: onTap,
        child: UniflowText(
          text,
          textAlign: TextAlign.center,
        ),
      );
    }

    return OutlinedButton.icon(
      icon: UniflowSvg(
        svg!,
        size: const Size.square(22.0),
        color: iconColor,
      ),
      label: UniflowText(
        text,
        overflow: TextOverflow.ellipsis,
      ),
      style: Theme.of(context)
          .outlinedButtonTheme
          .style
          ?.copyWith(alignment: Alignment.centerLeft),
      onPressed: onTap,
    );
  }
}
