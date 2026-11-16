import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/setting_cloud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UniversalWorkspaceCloudPage extends StatelessWidget {
  const UniversalWorkspaceCloudPage({super.key});

  static const routeName = '/UniversalWorkspaceCloudPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniflowAppBar(
        titleText: LocaleKeys.settings_menu_cloudSettings.tr(),
      ),
      body: SettingCloud(
        restartUniversalWorkspace: () async {
          await getIt<AuthService>().signOut();
          await runUniversalWorkspace();
        },
      ),
    );
  }
}
