import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_infra_ui/style_widget/hover.dart';

class UnsupportedImageWidget extends StatelessWidget {
  const UnsupportedImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: UniflowHover(
        style: HoverStyle(borderRadius: BorderRadius.circular(4)),
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              const HSpace(10),
              const UniflowSvg(
                UniflowSvgs.image_placeholder_s,
                size: Size.square(24),
              ),
              const HSpace(10),
              UniflowText(LocaleKeys.document_imageBlock_unableToLoadImage.tr()),
            ],
          ),
        ),
      ),
    );
  }
}
