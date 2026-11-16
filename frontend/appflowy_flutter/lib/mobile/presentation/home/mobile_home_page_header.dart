import 'package:universalworkspace/features/workspace/logic/workspace_bloc.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/animated_gesture.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/home/workspaces/workspace_menu_bottom_sheet.dart';
import 'package:universalworkspace/plugins/base/emoji/emoji_picker_screen.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/uniflow_icon_emoji_picker.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/tab.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/util/built_in_svgs.dart';
import 'package:universalworkspace/workspace/application/user/settings_user_bloc.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/workspace/_sidebar_workspace_icon.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'setting/settings_popup_menu.dart';

class MobileHomePageHeader extends StatelessWidget {
  const MobileHomePageHeader({
    super.key,
    required this.userProfile,
  });

  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsUserViewBloc>(param1: userProfile)
        ..add(const SettingsUserEvent.initial()),
      child: BlocBuilder<SettingsUserViewBloc, SettingsUserState>(
        builder: (context, state) {
          final isCollaborativeWorkspace =
              context.read<UserWorkspaceBloc>().state.isCollabWorkspaceOn;
          return ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: isCollaborativeWorkspace
                      ? _MobileWorkspace(userProfile: userProfile)
                      : _MobileUser(userProfile: userProfile),
                ),
                HomePageSettingsPopupMenu(
                  userProfile: userProfile,
                ),
                const HSpace(8.0),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MobileUser extends StatelessWidget {
  const _MobileUser({
    required this.userProfile,
  });

  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    final userIcon = userProfile.iconUrl;
    return Row(
      children: [
        _UserIcon(userIcon: userIcon),
        const HSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UniflowText.medium('UniversalWorkspace', fontSize: 18),
              const VSpace(4),
              UniflowText.regular(
                userProfile.email.isNotEmpty
                    ? userProfile.email
                    : userProfile.name,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileWorkspace extends StatelessWidget {
  const _MobileWorkspace({
    required this.userProfile,
  });

  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserWorkspaceBloc, UserWorkspaceState>(
      builder: (context, state) {
        final currentWorkspace = state.currentWorkspace;
        if (currentWorkspace == null) {
          return const SizedBox.shrink();
        }
        return AnimatedGestureDetector(
          scaleFactor: 0.99,
          alignment: Alignment.centerLeft,
          onTapUp: () {
            context.read<UserWorkspaceBloc>().add(
                  UserWorkspaceEvent.fetchWorkspaces(),
                );
            _showSwitchWorkspacesBottomSheet(context);
          },
          child: Row(
            children: [
              WorkspaceIcon(
                workspaceIcon: currentWorkspace.icon,
                workspaceName: currentWorkspace.name,
                iconSize: 36,
                fontSize: 18.0,
                isEditable: true,
                figmaLineHeight: 26.0,
                emojiSize: 24.0,
                borderRadius: 12.0,
                onSelected: (result) => context.read<UserWorkspaceBloc>().add(
                      UserWorkspaceEvent.updateWorkspaceIcon(
                        workspaceId: currentWorkspace.workspaceId,
                        icon: result.emoji,
                      ),
                    ),
              ),
              currentWorkspace.icon.isNotEmpty
                  ? const HSpace(2)
                  : const HSpace(8),
              Flexible(
                child: UniflowText.semibold(
                  currentWorkspace.name,
                  fontSize: 20.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSwitchWorkspacesBottomSheet(
    BuildContext context,
  ) {
    showMobileBottomSheet(
      context,
      showDivider: false,
      showHeader: true,
      showDragHandle: true,
      showCloseButton: true,
      useRootNavigator: true,
      enableScrollable: true,
      bottomSheetPadding: context.bottomSheetPadding(),
      title: LocaleKeys.workspace_menuTitle.tr(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<UserWorkspaceBloc>(),
          child: BlocBuilder<UserWorkspaceBloc, UserWorkspaceState>(
            builder: (context, state) {
              final currentWorkspace = state.currentWorkspace;
              final workspaces = state.workspaces;
              if (currentWorkspace == null || workspaces.isEmpty) {
                return const SizedBox.shrink();
              }
              return MobileWorkspaceMenu(
                userProfile: userProfile,
                currentWorkspace: currentWorkspace,
                workspaces: workspaces,
                onWorkspaceSelected: (workspace) {
                  Navigator.of(sheetContext).pop();

                  if (workspace == currentWorkspace) {
                    return;
                  }

                  context.read<UserWorkspaceBloc>().add(
                        UserWorkspaceEvent.openWorkspace(
                          workspaceId: workspace.workspaceId,
                          workspaceType: workspace.workspaceType,
                        ),
                      );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _UserIcon extends StatelessWidget {
  const _UserIcon({
    required this.userIcon,
  });

  final String userIcon;

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      useIntrinsicWidth: true,
      text: builtInSVGIcons.contains(userIcon)
          // to be compatible with old user icon
          ? UniflowSvg(
              UniflowSvgData('emoji/$userIcon'),
              size: const Size.square(32),
              blendMode: null,
            )
          : UniflowText(
              userIcon.isNotEmpty ? userIcon : '🐻',
              fontSize: 26,
            ),
      onTap: () async {
        final icon = await context.push<EmojiIconData>(
          Uri(
            path: MobileEmojiPickerScreen.routeName,
            queryParameters: {
              MobileEmojiPickerScreen.pageTitle:
                  LocaleKeys.titleBar_userIcon.tr(),
              MobileEmojiPickerScreen.selectTabs: [PickerTabType.emoji.name],
            },
          ).toString(),
        );
        if (icon != null) {
          if (context.mounted) {
            context.read<SettingsUserViewBloc>().add(
                  SettingsUserEvent.updateUserIcon(
                    iconUrl: icon.emoji,
                  ),
                );
          }
        }
      },
    );
  }
}
