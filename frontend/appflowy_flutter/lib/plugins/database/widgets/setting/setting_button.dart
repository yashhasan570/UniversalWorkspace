import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/plugins/database/widgets/setting/database_settings_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatefulWidget {
  const SettingButton({super.key, required this.databaseController});

  final DatabaseController databaseController;

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  final PopoverController _popoverController = PopoverController();

  @override
  Widget build(BuildContext context) {
    return UniversalWorkspacePopover(
      controller: _popoverController,
      constraints: BoxConstraints.loose(const Size(200, 400)),
      direction: PopoverDirection.bottomWithCenterAligned,
      offset: const Offset(0, 8),
      triggerActions: PopoverTriggerFlags.none,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: UniflowIconButton(
          tooltipText: LocaleKeys.settings_title.tr(),
          width: 24,
          height: 24,
          iconPadding: const EdgeInsets.all(3),
          hoverColor: AFThemeExtension.of(context).lightGreyHover,
          icon: const UniflowSvg(UniflowSvgs.settings_s),
          onPressed: _popoverController.show,
        ),
      ),
      popupBuilder: (_) =>
          DatabaseSettingsList(databaseController: widget.databaseController),
    );
  }
}
