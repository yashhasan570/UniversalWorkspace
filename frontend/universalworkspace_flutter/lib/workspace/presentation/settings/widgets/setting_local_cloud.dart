import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/_restart_app_button.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingLocalCloud extends StatelessWidget {
  const SettingLocalCloud({super.key, required this.restartUniversalWorkspace});

  final VoidCallback restartUniversalWorkspace;

  @override
  Widget build(BuildContext context) {
    return RestartButton(
      onClick: () => onPressed(context),
      showRestartHint: true,
    );
  }

  void onPressed(BuildContext context) {
    NavigatorAlertDialog(
      title: LocaleKeys.settings_menu_restartAppTip.tr(),
      confirm: () async {
        await useLocalServer();
        restartUniversalWorkspace();
      },
    ).show(context);
  }
}
