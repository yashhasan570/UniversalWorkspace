import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/plugins/database/calendar/presentation/toolbar/calendar_layout_setting.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/plugins/database/widgets/group/database_group.dart';
import 'package:universalworkspace/plugins/database/widgets/setting/database_layout_selector.dart';
import 'package:universalworkspace/plugins/database/widgets/setting/setting_property_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

enum DatabaseSettingAction {
  showProperties,
  showLayout,
  showGroup,
  showCalendarLayout,
}

extension DatabaseSettingActionExtension on DatabaseSettingAction {
  UniflowSvgData iconData() {
    switch (this) {
      case DatabaseSettingAction.showProperties:
        return UniflowSvgs.multiselect_s;
      case DatabaseSettingAction.showLayout:
        return UniflowSvgs.database_layout_s;
      case DatabaseSettingAction.showGroup:
        return UniflowSvgs.group_s;
      case DatabaseSettingAction.showCalendarLayout:
        return UniflowSvgs.calendar_layout_s;
    }
  }

  String title() {
    switch (this) {
      case DatabaseSettingAction.showProperties:
        return LocaleKeys.grid_settings_properties.tr();
      case DatabaseSettingAction.showLayout:
        return LocaleKeys.grid_settings_databaseLayout.tr();
      case DatabaseSettingAction.showGroup:
        return LocaleKeys.grid_settings_group.tr();
      case DatabaseSettingAction.showCalendarLayout:
        return LocaleKeys.calendar_settings_name.tr();
    }
  }

  Widget build(
    BuildContext context,
    DatabaseController databaseController,
    PopoverMutex popoverMutex,
  ) {
    final popover = switch (this) {
      DatabaseSettingAction.showLayout => DatabaseLayoutSelector(
          viewId: databaseController.viewId,
          databaseController: databaseController,
        ),
      DatabaseSettingAction.showGroup => DatabaseGroupList(
          viewId: databaseController.viewId,
          databaseController: databaseController,
          onDismissed: () {},
        ),
      DatabaseSettingAction.showProperties => DatabasePropertyList(
          viewId: databaseController.viewId,
          fieldController: databaseController.fieldController,
        ),
      DatabaseSettingAction.showCalendarLayout => CalendarLayoutSetting(
          databaseController: databaseController,
        ),
    };

    return UniversalWorkspacePopover(
      triggerActions: PopoverTriggerFlags.hover | PopoverTriggerFlags.click,
      direction: PopoverDirection.leftWithTopAligned,
      mutex: popoverMutex,
      margin: EdgeInsets.zero,
      offset: const Offset(-14, 0),
      child: SizedBox(
        height: GridSize.popoverItemHeight,
        child: UniflowButton(
          hoverColor: AFThemeExtension.of(context).lightGreyHover,
          text: UniflowText(
            title(),
            lineHeight: 1.0,
            color: AFThemeExtension.of(context).textColor,
          ),
          leftIcon: UniflowSvg(
            iconData(),
            color: Theme.of(context).iconTheme.color,
          ),
          rightIcon: UniflowSvg(UniflowSvgs.database_settings_arrow_right_s),
        ),
      ),
      popupBuilder: (context) => popover,
    );
  }
}
