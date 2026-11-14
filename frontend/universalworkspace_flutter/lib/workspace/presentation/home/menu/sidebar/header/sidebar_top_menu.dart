import 'dart:io' show Platform;

import 'package:universalworkspace/core/frameless_window.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/home/home_setting_bloc.dart';
import 'package:universalworkspace/workspace/application/menu/sidebar_sections_bloc.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/hover.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_platform/universal_platform.dart';

/// Sidebar top menu is the top bar of the sidebar.
///
/// in the top menu, we have:
///   - universalworkspace icon (Windows or Linux)
///   - close / expand sidebar button
class SidebarTopMenu extends StatelessWidget {
  const SidebarTopMenu({
    super.key,
    required this.isSidebarOnHover,
  });

  final ValueNotifier<bool> isSidebarOnHover;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SidebarSectionsBloc, SidebarSectionsState>(
      builder: (context, _) => SizedBox(
        height: !UniversalPlatform.isWindows ? HomeSizes.topBarHeight : 45,
        child: MoveWindowDetector(
          child: Row(
            children: [
              _buildLogoIcon(context),
              const Spacer(),
              _buildCollapseMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoIcon(BuildContext context) {
    if (Platform.isMacOS) {
      return const SizedBox.shrink();
    }

    final svgData = Theme.of(context).brightness == Brightness.dark
        ? UniflowSvgs.app_logo_with_text_dark_xl
        : UniflowSvgs.app_logo_with_text_light_xl;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 8),
      child: UniflowSvg(
        svgData,
        size: const Size(92, 17),
        blendMode: null,
      ),
    );
  }

  Widget _buildCollapseMenuButton(BuildContext context) {
    final settingState = context.read<HomeSettingBloc?>()?.state;
    final isNotificationPanelCollapsed =
        settingState?.isNotificationPanelCollapsed ?? true;

    final textSpan = TextSpan(
      children: [
        TextSpan(
          text: LocaleKeys.sideBar_closeSidebar.tr(),
          style: context.tooltipTextStyle(),
        ),
        if (isNotificationPanelCollapsed)
          TextSpan(
            text: '\n${Platform.isMacOS ? '⌘+.' : 'Ctrl+\\'}',
            style: context
                .tooltipTextStyle()
                ?.copyWith(color: Theme.of(context).hintColor),
          ),
      ],
    );
    final theme = UniversalWorkspaceTheme.of(context);

    return ValueListenableBuilder(
      valueListenable: isSidebarOnHover,
      builder: (_, value, ___) => Opacity(
        opacity: value ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, right: 6.0),
          child: UniflowTooltip(
            richMessage: textSpan,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) =>
                  context.read<HomeSettingBloc>().collapseMenu(),
              child: UniflowHover(
                child: SizedBox(
                  width: 24,
                  child: UniflowSvg(
                    UniflowSvgs.double_back_arrow_m,
                    color: theme.iconColorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
