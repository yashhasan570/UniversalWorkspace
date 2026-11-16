import 'package:universalworkspace/features/share_tab/logic/share_tab_bloc.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CopyLinkWidget extends StatelessWidget {
  const CopyLinkWidget({
    super.key,
    required this.shareLink,
  });

  final String shareLink;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.m,
        horizontal: theme.spacing.l,
      ),
      decoration: BoxDecoration(
        color: theme.surfaceContainerColorScheme.layer01,
        borderRadius: BorderRadius.circular(theme.spacing.m),
        border: Border.all(
          color: theme.borderColorScheme.primary,
        ),
      ),
      child: Row(
        children: [
          UniflowSvg(
            UniflowSvgs.toolbar_link_m,
          ),
          HSpace(theme.spacing.m),
          Expanded(
            child: Text(
              LocaleKeys.shareTab_peopleAboveCanAccessWithTheLink.tr(),
              style: theme.textStyle.caption.standard(
                color: theme.textColorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AFOutlinedTextButton.normal(
            text: LocaleKeys.shareTab_copyLink.tr(),
            size: AFButtonSize.l,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.l,
              vertical: theme.spacing.s,
            ),
            backgroundColor: (context, isHovering, disabled) {
              final theme = UniversalWorkspaceTheme.of(context);
              if (disabled) {
                return theme.fillColorScheme.content;
              }
              if (isHovering) {
                return theme.fillColorScheme.contentHover;
              }
              return theme.surfaceColorScheme.layer02;
            },
            onTap: () {
              context.read<ShareTabBloc>().add(
                    ShareTabEvent.copyShareLink(link: shareLink),
                  );

              if (UniflowRunner.currentMode.isUnitTest) {
                return;
              }

              showToastNotification(
                message: LocaleKeys.shareTab_copiedLinkToClipboard.tr(),
              );
            },
          ),
        ],
      ),
    );
  }
}
