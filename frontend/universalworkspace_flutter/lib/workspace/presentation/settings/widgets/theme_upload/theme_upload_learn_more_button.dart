import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/error_page/error_page.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/theme_upload/theme_upload_view.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_infra_ui/widget/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

class ThemeUploadLearnMoreButton extends StatelessWidget {
  const ThemeUploadLearnMoreButton({super.key});

  static const learnMoreURL =
      'https://docs.universalworkspace.io/docs/universalworkspace/product/themes';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ThemeUploadWidget.buttonSize.height,
      child: IntrinsicWidth(
        child: SecondaryButton(
          outlineColor: AFThemeExtension.of(context).onBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: UniflowText.medium(
              fontSize: ThemeUploadWidget.buttonFontSize,
              LocaleKeys.document_plugins_autoGeneratorLearnMore.tr(),
            ),
          ),
          onPressed: () async {
            final uri = Uri.parse(learnMoreURL);
            await afLaunchUri(
              uri,
              context: context,
              onFailure: (_) async {
                if (context.mounted) {
                  await Dialogs.show(
                    context,
                    child: UniflowDialog(
                      child: UniflowErrorPage.message(
                        LocaleKeys
                            .settings_appearance_themeUpload_urlUploadFailure
                            .tr()
                            .replaceAll(
                              '{}',
                              uri.toString(),
                            ),
                        howToFix: LocaleKeys.errorDialog_howToFixFallback.tr(),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
