import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_svg/uniflow_svg.dart';
import 'package:flutter/material.dart';

class UniflowColorOption {
  const UniflowColorOption({
    required this.color,
    required this.i18n,
    required this.id,
  });

  final Color color;
  final String i18n;
  final String id;
}

class UniflowColorPicker extends StatelessWidget {
  final List<UniflowColorOption> colors;
  final Color? selected;
  final Function(UniflowColorOption option, int index)? onTap;
  final double separatorSize;
  final double iconSize;
  final double itemHeight;
  final Border? border;

  const UniflowColorPicker({
    super.key,
    required this.colors,
    this.selected,
    this.onTap,
    this.separatorSize = 4,
    this.iconSize = 16,
    this.itemHeight = 32,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return VSpace(separatorSize);
      },
      itemCount: colors.length,
      physics: StyledScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _buildColorOption(colors[index], index);
      },
    );
  }

  Widget _buildColorOption(
    UniflowColorOption option,
    int i,
  ) {
    Widget? checkmark;
    if (selected == option.color) {
      checkmark = const UniflowSvg(UniflowSvgData("grid/checkmark"));
    }

    final colorIcon = ColorOptionIcon(
      color: option.color,
      iconSize: iconSize,
    );

    return SizedBox(
      height: itemHeight,
      child: UniflowButton(
        text: UniflowText(option.i18n),
        leftIcon: colorIcon,
        rightIcon: checkmark,
        iconPadding: 10,
        onTap: () {
          onTap?.call(option, i);
        },
      ),
    );
  }
}

class ColorOptionIcon extends StatelessWidget {
  const ColorOptionIcon({
    super.key,
    required this.color,
    this.iconSize = 16.0,
  });

  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: iconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: color == Colors.transparent
              ? Border.all(color: const Color(0xFFCFD3D9))
              : null,
        ),
      ),
    );
  }
}
