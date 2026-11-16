import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/application/notification/notification_reminder_bloc.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/page_item/mobile_slide_action_button.dart';
import 'package:universalworkspace/mobile/presentation/presentation.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/user/application/reminder/reminder_bloc.dart';
import 'package:universalworkspace/user/application/reminder/reminder_extension.dart';
import 'package:universalworkspace/workspace/presentation/notifications/widgets/notification_tab_bar.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NotificationPaneActionType {
  more,
  markAsRead,
  // only used in the debug mode.
  unArchive;

  MobileSlideActionButton actionButton(
    BuildContext context, {
    required NotificationTabType tabType,
  }) {
    switch (this) {
      case NotificationPaneActionType.markAsRead:
        return MobileSlideActionButton(
          backgroundColor: const Color(0xFF00C8FF),
          svg: UniflowSvgs.m_notification_action_mark_as_read_s,
          size: 24.0,
          onPressed: (context) {
            showToastNotification(
              message: LocaleKeys
                  .settings_notifications_markAsReadNotifications_success
                  .tr(),
            );

            context.read<ReminderBloc>().add(
                  ReminderEvent.update(
                    ReminderUpdate(
                      id: context.read<NotificationReminderBloc>().reminder.id,
                      isRead: true,
                    ),
                  ),
                );
          },
        );
      // this action is only used in the debug mode.
      case NotificationPaneActionType.unArchive:
        return MobileSlideActionButton(
          backgroundColor: const Color(0xFF00C8FF),
          svg: UniflowSvgs.m_notification_action_mark_as_read_s,
          size: 24.0,
          onPressed: (context) {
            showToastNotification(
              message: 'Unarchive notification success',
            );

            context.read<ReminderBloc>().add(
                  ReminderEvent.update(
                    ReminderUpdate(
                      id: context.read<NotificationReminderBloc>().reminder.id,
                      isArchived: false,
                    ),
                  ),
                );
          },
        );
      case NotificationPaneActionType.more:
        return MobileSlideActionButton(
          backgroundColor: const Color(0xE5515563),
          svg: UniflowSvgs.three_dots_s,
          size: 24.0,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          onPressed: (context) => context.onMoreAction(),
        );
    }
  }
}

extension NotificationPaneActionExtension on BuildContext {
  void onMoreAction() {
    final reminderBloc = read<ReminderBloc>();
    final notificationReminderBloc = read<NotificationReminderBloc>();

    showMobileBottomSheet(
      this,
      showDragHandle: true,
      showDivider: false,
      useRootNavigator: true,
      backgroundColor: Theme.of(this).colorScheme.surface,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: reminderBloc),
            BlocProvider.value(value: notificationReminderBloc),
          ],
          child: _NotificationMoreActions(
            onClickMultipleChoice: () {
              Future.delayed(const Duration(milliseconds: 250), () {
                bottomNavigationBarType.value =
                    BottomNavigationBarActionType.notificationMultiSelect;
              });
            },
          ),
        );
      },
    );
  }
}

class _NotificationMoreActions extends StatelessWidget {
  const _NotificationMoreActions({
    required this.onClickMultipleChoice,
  });

  final VoidCallback onClickMultipleChoice;

  @override
  Widget build(BuildContext context) {
    final reminder = context.read<NotificationReminderBloc>().reminder;
    return Column(
      children: [
        if (!reminder.isRead)
          UniflowOptionTile.text(
            height: 52.0,
            text: LocaleKeys.settings_notifications_action_markAsRead.tr(),
            leftIcon: const UniflowSvg(
              UniflowSvgs.m_notification_action_mark_as_read_s,
              size: Size.square(20),
            ),
            showTopBorder: false,
            showBottomBorder: false,
            onTap: () => _onMarkAsRead(context),
          ),
        UniflowOptionTile.text(
          height: 52.0,
          text: LocaleKeys.settings_notifications_action_multipleChoice.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.m_notification_action_multiple_choice_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => _onMultipleChoice(context),
        ),
        if (!reminder.isArchived)
          UniflowOptionTile.text(
            height: 52.0,
            text: LocaleKeys.settings_notifications_action_archive.tr(),
            leftIcon: const UniflowSvg(
              UniflowSvgs.m_notification_action_archive_s,
              size: Size.square(20),
            ),
            showTopBorder: false,
            showBottomBorder: false,
            onTap: () => _onArchive(context),
          ),
      ],
    );
  }

  void _onMarkAsRead(BuildContext context) {
    Navigator.of(context).pop();

    showToastNotification(
      message: LocaleKeys.settings_notifications_markAsReadNotifications_success
          .tr(),
    );

    context.read<ReminderBloc>().add(
          ReminderEvent.update(
            ReminderUpdate(
              id: context.read<NotificationReminderBloc>().reminder.id,
              isRead: true,
            ),
          ),
        );
  }

  void _onMultipleChoice(BuildContext context) {
    Navigator.of(context).pop();

    onClickMultipleChoice();
  }

  void _onArchive(BuildContext context) {
    showToastNotification(
      message: LocaleKeys.settings_notifications_archiveNotifications_success
          .tr()
          .tr(),
    );

    context.read<ReminderBloc>().add(
          ReminderEvent.update(
            ReminderUpdate(
              id: context.read<NotificationReminderBloc>().reminder.id,
              isRead: true,
              isArchived: true,
            ),
          ),
        );

    Navigator.of(context).pop();
  }
}
