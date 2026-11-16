import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/feature_flags.dart';
import 'package:universalworkspace/startup/plugin/plugin.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/application/tabs/tabs_bloc.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/menu_shared_state.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/footer/sidebar_toast.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/setting_universalworkspace_cloud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:flutter/material.dart';

import 'sidebar_footer_button.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (FeatureFlag.planBilling.isOn)
          BillingGateGuard(
            builder: (context) {
              return const SidebarToast();
            },
          ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: SidebarTemplateButton()),
            _buildVerticalDivider(context),
            const Expanded(child: SidebarTrashButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      width: 1.0,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AFThemeExtension.of(context).borderColor,
    );
  }
}

class SidebarTemplateButton extends StatelessWidget {
  const SidebarTemplateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SidebarFooterButton(
      leftIconSize: const Size.square(16.0),
      leftIcon: const UniflowSvg(
        UniflowSvgs.icon_template_s,
      ),
      text: LocaleKeys.template_label.tr(),
      onTap: () => afLaunchUrlString('https://universalworkspace.com/templates'),
    );
  }
}

class SidebarTrashButton extends StatelessWidget {
  const SidebarTrashButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: getIt<MenuSharedState>().notifier,
      builder: (context, value, child) {
        return SidebarFooterButton(
          leftIconSize: const Size.square(18.0),
          leftIcon: const UniflowSvg(
            UniflowSvgs.icon_delete_s,
          ),
          text: LocaleKeys.trash_text.tr(),
          onTap: () {
            getIt<MenuSharedState>().latestOpenView = null;
            getIt<TabsBloc>().add(
              TabsEvent.openPlugin(
                plugin: makePlugin(pluginType: PluginType.trash),
              ),
            );
          },
        );
      },
    );
  }
}

class SidebarWidgetButton extends StatelessWidget {
  const SidebarWidgetButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: const UniflowSvg(UniflowSvgs.sidebar_footer_widget_s),
      ),
    );
  }
}
