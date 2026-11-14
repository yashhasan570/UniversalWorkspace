import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/theme_upload/theme_upload.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';

class ThemeUploadFailureWidget extends StatelessWidget {
  const ThemeUploadFailureWidget({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .error
          .withValues(alpha: ThemeUploadWidget.fadeOpacity),
      constraints: const BoxConstraints.expand(),
      padding: ThemeUploadWidget.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          UniflowSvg(
            UniflowSvgs.close_m,
            size: ThemeUploadWidget.iconSize,
            color: AFThemeExtension.of(context).onBackground,
          ),
          UniflowText.medium(
            errorMessage,
            overflow: TextOverflow.ellipsis,
          ),
          ThemeUploadWidget.elementSpacer,
          const ThemeUploadLearnMoreButton(),
          ThemeUploadWidget.elementSpacer,
          ThemeUploadButton(color: Theme.of(context).colorScheme.error),
          ThemeUploadWidget.elementSpacer,
        ],
      ),
    );
  }
}
