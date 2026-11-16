import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

import 'theme_upload_view.dart';

class ThemeConfirmDeleteDialog extends StatelessWidget {
  const ThemeConfirmDeleteDialog({
    super.key,
    required this.theme,
  });

  final AppTheme theme;

  void onConfirm(BuildContext context) => Navigator.of(context).pop(true);
  void onCancel(BuildContext context) => Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    return UniflowDialog(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: 300,
        height: 100,
      ),
      title: UniflowText.regular(
        LocaleKeys.document_plugins_cover_alertDialogConfirmation.tr(),
        textAlign: TextAlign.center,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: ThemeUploadWidget.buttonSize.width,
            child: UniflowButton(
              text: UniflowText.semibold(
                LocaleKeys.button_ok.tr(),
                fontSize: ThemeUploadWidget.buttonFontSize,
              ),
              onTap: () => onConfirm(context),
            ),
          ),
          SizedBox(
            width: ThemeUploadWidget.buttonSize.width,
            child: UniflowButton(
              text: UniflowText.semibold(
                LocaleKeys.button_cancel.tr(),
                fontSize: ThemeUploadWidget.buttonFontSize,
              ),
              onTap: () => onCancel(context),
            ),
          ),
        ],
      ),
    );
  }
}
