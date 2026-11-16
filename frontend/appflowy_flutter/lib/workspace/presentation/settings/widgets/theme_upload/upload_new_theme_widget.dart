import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/theme_upload/theme_upload.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class UploadNewThemeWidget extends StatelessWidget {
  const UploadNewThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .surface
          .withValues(alpha: ThemeUploadWidget.fadeOpacity),
      padding: ThemeUploadWidget.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          UniflowSvg(
            UniflowSvgs.folder_m,
            size: ThemeUploadWidget.iconSize,
            color: AFThemeExtension.of(context).onBackground,
          ),
          UniflowText.medium(
            LocaleKeys.settings_appearance_themeUpload_description.tr(),
            overflow: TextOverflow.ellipsis,
          ),
          ThemeUploadWidget.elementSpacer,
          const ThemeUploadLearnMoreButton(),
          ThemeUploadWidget.elementSpacer,
          const Divider(),
          ThemeUploadWidget.elementSpacer,
          const ThemeUploadButton(),
          ThemeUploadWidget.elementSpacer,
        ],
      ),
    );
  }
}
