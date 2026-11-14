import 'dart:io';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/user/application/reminder/reminder_bloc.dart';
import 'package:universalworkspace/workspace/application/home/home_setting_bloc.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/notification_tab.dart';
import 'widgets/notification_tab_bar.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final PopoverController moreActionController = PopoverController();

  final tabs = [
    NotificationTabType.inbox,
    NotificationTabType.unread,
    NotificationTabType.archive,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    moreActionController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<HomeSettingBloc>();
    final theme = UniversalWorkspaceTheme.of(context);
    return GestureDetector(
      onTap: () =>
          settingBloc.add(HomeSettingEvent.collapseNotificationPanel()),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 380,
              decoration: BoxDecoration(
                color: theme.backgroundColorScheme.primary,
                boxShadow: theme.shadow.small,
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(
                    context: context,
                    onHide: () => settingBloc
                        .add(HomeSettingEvent.collapseNotificationPanel()),
                  ),
                  const VSpace(12),
                  NotificationTabBar(
                    tabController: tabController,
                    tabs: tabs,
                  ),
                  const VSpace(14),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children:
                          tabs.map((e) => NotificationTab(tabType: e)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle({
    required BuildContext context,
    required VoidCallback onHide,
  }) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 24,
      child: Row(
        children: [
          UniflowText.medium(
            LocaleKeys.notificationHub_title.tr(),
            fontSize: 16,
            figmaLineHeight: 24,
          ),
          Spacer(),
          UniflowIconButton(
            width: 24,
            icon: UniflowSvg(
              UniflowSvgs.double_back_arrow_m,
              color: theme.iconColorScheme.secondary,
            ),
            richTooltipText: colappsedButtonTooltip(context),
            onPressed: onHide,
          ),
          HSpace(8),
          buildMoreActionButton(context),
        ],
      ),
    );
  }

  Widget buildMoreActionButton(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return UniversalWorkspacePopover(
      constraints: BoxConstraints.loose(const Size(240, 78)),
      offset: const Offset(-24, 24),
      margin: EdgeInsets.zero,
      controller: moreActionController,
      onOpen: () => keepEditorFocusNotifier.increase(),
      onClose: () => keepEditorFocusNotifier.decrease(),
      popupBuilder: (_) => buildMoreActions(),
      child: UniflowIconButton(
        width: 24,
        icon: UniflowSvg(
          UniflowSvgs.three_dots_m,
          color: theme.iconColorScheme.secondary,
        ),
        onPressed: () {
          keepEditorFocusNotifier.increase();
          moreActionController.show();
        },
      ),
    );
  }

  Widget buildMoreActions() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 24,
            color: Color(0x0000001F),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: UniflowButton(
              text: UniflowText.regular(
                LocaleKeys.settings_notifications_settings_markAllAsRead.tr(),
              ),
              leftIcon: UniflowSvg(UniflowSvgs.m_notification_mark_as_read_s),
              onTap: () {
                showToastNotification(
                  message:
                      LocaleKeys.notificationHub_markAllAsReadSucceedToast.tr(),
                );
                context
                    .read<ReminderBloc>()
                    .add(const ReminderEvent.markAllRead());
                moreActionController.close();
              },
            ),
          ),
          VSpace(2),
          SizedBox(
            height: 30,
            child: UniflowButton(
              text: UniflowText.regular(
                LocaleKeys.settings_notifications_settings_archiveAll.tr(),
              ),
              leftIcon: UniflowSvg(UniflowSvgs.m_notification_archived_s),
              onTap: () {
                showToastNotification(
                  message: LocaleKeys
                      .notificationHub_markAllAsArchivedSucceedToast
                      .tr(),
                );
                context
                    .read<ReminderBloc>()
                    .add(const ReminderEvent.archiveAll());
                moreActionController.close();
              },
            ),
          ),
        ],
      ),
    );
  }

  TextSpan colappsedButtonTooltip(BuildContext context) {
    return TextSpan(
      children: [
        TextSpan(
          text: '${LocaleKeys.notificationHub_closeNotification.tr()}\n',
          style: context.tooltipTextStyle(),
        ),
        TextSpan(
          text: Platform.isMacOS ? '⌘+.' : 'Ctrl+\\',
          style: context
              .tooltipTextStyle()
              ?.copyWith(color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}
