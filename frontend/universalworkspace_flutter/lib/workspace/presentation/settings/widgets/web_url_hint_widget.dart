import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/icon_button.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:flutter/material.dart';

class WebUrlHintWidget extends StatelessWidget {
  const WebUrlHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: UniflowTooltip(
        message: LocaleKeys.workspace_learnMore.tr(),
        preferBelow: false,
        child: UniflowIconButton(
          width: 24,
          height: 24,
          icon: const UniflowSvg(
            UniflowSvgs.information_s,
          ),
          onPressed: () {
            afLaunchUrlString(
              'https://universalworkspace.com/docs/self-host-universalworkspace-run-universalworkspace-web',
            );
          },
        ),
      ),
    );
  }
}
