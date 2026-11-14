import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/setting/widgets/mobile_setting_trailing.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/plugins/document/application/document_appearance_cubit.dart';
import 'package:universalworkspace/workspace/application/settings/appearance/appearance_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../setting.dart';

class RTLSetting extends StatelessWidget {
  const RTLSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection =
        context.watch<AppearanceSettingsCubit>().state.textDirection;
    return MobileSettingItem(
      name: LocaleKeys.settings_appearance_textDirection_label.tr(),
      trailing: MobileSettingTrailing(
        text: _textDirectionLabelText(textDirection),
      ),
      onTap: () {
        showMobileBottomSheet(
          context,
          showHeader: true,
          showDragHandle: true,
          showDivider: false,
          title: LocaleKeys.settings_appearance_textDirection_label.tr(),
          builder: (context) {
            return Column(
              children: [
                UniflowOptionTile.checkbox(
                  text: LocaleKeys.settings_appearance_textDirection_ltr.tr(),
                  isSelected: textDirection == UniversalWorkspaceTextDirection.ltr,
                  onTap: () => applyTextDirectionAndPop(
                    context,
                    UniversalWorkspaceTextDirection.ltr,
                  ),
                ),
                UniflowOptionTile.checkbox(
                  showTopBorder: false,
                  text: LocaleKeys.settings_appearance_textDirection_rtl.tr(),
                  isSelected: textDirection == UniversalWorkspaceTextDirection.rtl,
                  onTap: () => applyTextDirectionAndPop(
                    context,
                    UniversalWorkspaceTextDirection.rtl,
                  ),
                ),
                UniflowOptionTile.checkbox(
                  showTopBorder: false,
                  text: LocaleKeys.settings_appearance_textDirection_auto.tr(),
                  isSelected: textDirection == UniversalWorkspaceTextDirection.auto,
                  onTap: () => applyTextDirectionAndPop(
                    context,
                    UniversalWorkspaceTextDirection.auto,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _textDirectionLabelText(UniversalWorkspaceTextDirection textDirection) {
    switch (textDirection) {
      case UniversalWorkspaceTextDirection.auto:
        return LocaleKeys.settings_appearance_textDirection_auto.tr();
      case UniversalWorkspaceTextDirection.rtl:
        return LocaleKeys.settings_appearance_textDirection_rtl.tr();
      case UniversalWorkspaceTextDirection.ltr:
        return LocaleKeys.settings_appearance_textDirection_ltr.tr();
    }
  }

  void applyTextDirectionAndPop(
    BuildContext context,
    UniversalWorkspaceTextDirection textDirection,
  ) {
    context.read<AppearanceSettingsCubit>().setTextDirection(textDirection);
    context
        .read<DocumentAppearanceCubit>()
        .syncDefaultTextDirection(textDirection.name);
    Navigator.pop(context);
  }
}
