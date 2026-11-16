import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/application/notification/notification_reminder_bloc.dart';
import 'package:universalworkspace/mobile/application/page_style/document_page_style_bloc.dart';
import 'package:universalworkspace/mobile/presentation/notifications/widgets/shared.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/reminder.pb.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationItemContentV2 extends StatelessWidget {
  const NotificationItemContentV2({super.key, required this.reminder});
  final ReminderPB reminder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationReminderBloc, NotificationReminderState>(
      builder: (context, state) {
        final view = state.view;
        if (view == null) {
          return const SizedBox.shrink();
        }
        final theme = UniversalWorkspaceTheme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(state.scheduledAt, theme),
            _buildPageName(context, state.isLocked, state.pageTitle, theme),
            _buildContent(view, state.nodes, theme),
          ],
        );
      },
    );
  }

  Widget _buildHeader(String createAt, UniversalWorkspaceThemeData theme) {
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          UniflowText.medium(
            LocaleKeys.settings_notifications_titles_reminder.tr(),
            fontSize: 14,
            figmaLineHeight: 22,
            color: theme.textColorScheme.primary,
          ),
          Spacer(),
          if (createAt.isNotEmpty)
            UniflowText.regular(
              createAt,
              fontSize: 12,
              figmaLineHeight: 16,
              color: theme.textColorScheme.secondary,
            ),
          if (!reminder.isRead) ...[
            HSpace(4),
            const UnreadRedDot(),
          ],
        ],
      ),
    );
  }

  Widget _buildPageName(
    BuildContext context,
    bool isLocked,
    String pageTitle,
    UniversalWorkspaceThemeData theme,
  ) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          UniflowText.regular(
            LocaleKeys.notificationHub_mentionedYou.tr(),
            fontSize: 12,
            figmaLineHeight: 18,
            color: theme.textColorScheme.secondary,
          ),
          const NotificationEllipse(),
          if (isLocked)
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: UniflowSvg(
                UniflowSvgs.notification_lock_s,
                color: theme.iconColorScheme.secondary,
              ),
            ),
          Flexible(
            child: UniflowText.regular(
              pageTitle,
              fontSize: 12,
              figmaLineHeight: 18,
              color: theme.textColorScheme.secondary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    ViewPB view,
    List<Node>? nodes,
    UniversalWorkspaceThemeData theme,
  ) {
    if (view.layout.isDocumentView && nodes != null) {
      return IntrinsicHeight(
        child: BlocProvider(
          create: (context) => DocumentPageStyleBloc(view: view),
          child: NotificationDocumentContent(reminder: reminder, nodes: nodes),
        ),
      );
    } else if (view.layout.isDatabaseView) {
      return UniflowText(
        reminder.message,
        fontSize: 14,
        figmaLineHeight: 22,
        color: theme.textColorScheme.primary,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }
    return const SizedBox.shrink();
  }
}
