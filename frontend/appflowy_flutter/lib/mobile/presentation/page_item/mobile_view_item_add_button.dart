import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class MobileViewAddButton extends StatelessWidget {
  const MobileViewAddButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return UniflowIconButton(
      width: HomeSpaceViewSizes.mViewButtonDimension,
      height: HomeSpaceViewSizes.mViewButtonDimension,
      icon: const UniflowSvg(
        UniflowSvgs.m_space_add_s,
      ),
      onPressed: onPressed,
    );
  }
}

class MobileViewMoreButton extends StatelessWidget {
  const MobileViewMoreButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return UniflowIconButton(
      width: HomeSpaceViewSizes.mViewButtonDimension,
      height: HomeSpaceViewSizes.mViewButtonDimension,
      icon: const UniflowSvg(
        UniflowSvgs.m_space_more_s,
      ),
      onPressed: onPressed,
    );
  }
}
