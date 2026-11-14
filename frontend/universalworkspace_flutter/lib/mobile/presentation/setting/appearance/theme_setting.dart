import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/setting/widgets/mobile_setting_trailing.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/util/theme_mode_extension.dart';
import 'package:universalworkspace/workspace/application/settings/appearance/appearance_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../setting.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<AppearanceSettingsCubit>().state.themeMode;
    return MobileSettingItem(
      name: LocaleKeys.settings_appearance_themeMode_label.tr(),
      trailing: MobileSettingTrailing(
        text: themeMode.labelText,
      ),
      onTap: () {
        showMobileBottomSheet(
          context,
          showHeader: true,
          showDragHandle: true,
          showDivider: false,
          title: LocaleKeys.settings_appearance_themeMode_label.tr(),
          builder: (context) {
            final themeMode =
                context.read<AppearanceSettingsCubit>().state.themeMode;
            return Column(
              children: [
                UniflowOptionTile.checkbox(
                  text: LocaleKeys.settings_appearance_themeMode_system.tr(),
                  leftIcon: const UniflowSvg(
                    UniflowSvgs.m_theme_mode_system_s,
                  ),
                  isSelected: themeMode == ThemeMode.system,
                  onTap: () {
                    context
                        .read<AppearanceSettingsCubit>()
                        .setThemeMode(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
                UniflowOptionTile.checkbox(
                  showTopBorder: false,
                  text: LocaleKeys.settings_appearance_themeMode_light.tr(),
                  leftIcon: const UniflowSvg(
                    UniflowSvgs.m_theme_mode_light_s,
                  ),
                  isSelected: themeMode == ThemeMode.light,
                  onTap: () {
                    context
                        .read<AppearanceSettingsCubit>()
                        .setThemeMode(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                UniflowOptionTile.checkbox(
                  showTopBorder: false,
                  text: LocaleKeys.settings_appearance_themeMode_dark.tr(),
                  leftIcon: const UniflowSvg(
                    UniflowSvgs.m_theme_mode_dark_s,
                  ),
                  isSelected: themeMode == ThemeMode.dark,
                  onTap: () {
                    context
                        .read<AppearanceSettingsCubit>()
                        .setThemeMode(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
