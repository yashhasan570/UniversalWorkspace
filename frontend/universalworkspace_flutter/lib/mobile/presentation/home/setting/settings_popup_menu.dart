import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/presentation.dart';
import 'package:universalworkspace/mobile/presentation/setting/workspace/invite_members_screen.dart';
import 'package:universalworkspace/shared/popup_menu/universalworkspace_popup_menu.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart'
    hide PopupMenuButton, PopupMenuDivider, PopupMenuItem, PopupMenuEntry;
import 'package:go_router/go_router.dart';

enum _MobileSettingsPopupMenuItem {
  settings,
  members,
  trash,
  help,
  helpAndDocumentation,
}

class HomePageSettingsPopupMenu extends StatelessWidget {
  const HomePageSettingsPopupMenu({
    super.key,
    required this.userProfile,
  });

  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MobileSettingsPopupMenuItem>(
      offset: const Offset(0, 36),
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      shadowColor: const Color(0x68000000),
      elevation: 10,
      color: context.popupMenuBackgroundColor,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<_MobileSettingsPopupMenuItem>>[
        _buildItem(
          value: _MobileSettingsPopupMenuItem.settings,
          svg: UniflowSvgs.m_notification_settings_s,
          text: LocaleKeys.settings_popupMenuItem_settings.tr(),
        ),
        // only show the member items in cloud mode
        if (userProfile.workspaceType == WorkspaceTypePB.ServerW) ...[
          const PopupMenuDivider(height: 0.5),
          _buildItem(
            value: _MobileSettingsPopupMenuItem.members,
            svg: UniflowSvgs.m_settings_member_s,
            text: LocaleKeys.settings_popupMenuItem_members.tr(),
          ),
        ],
        const PopupMenuDivider(height: 0.5),
        _buildItem(
          value: _MobileSettingsPopupMenuItem.trash,
          svg: UniflowSvgs.trash_s,
          text: LocaleKeys.settings_popupMenuItem_trash.tr(),
        ),
        const PopupMenuDivider(height: 0.5),
        _buildItem(
          value: _MobileSettingsPopupMenuItem.helpAndDocumentation,
          svg: UniflowSvgs.help_and_documentation_s,
          text: LocaleKeys.settings_popupMenuItem_helpAndDocumentation.tr(),
        ),
        const PopupMenuDivider(height: 0.5),
        _buildItem(
          value: _MobileSettingsPopupMenuItem.help,
          svg: UniflowSvgs.message_support_s,
          text: LocaleKeys.settings_popupMenuItem_getSupport.tr(),
        ),
      ],
      onSelected: (_MobileSettingsPopupMenuItem value) {
        switch (value) {
          case _MobileSettingsPopupMenuItem.members:
            _openMembersPage(context);
            break;
          case _MobileSettingsPopupMenuItem.trash:
            _openTrashPage(context);
            break;
          case _MobileSettingsPopupMenuItem.settings:
            _openSettingsPage(context);
            break;
          case _MobileSettingsPopupMenuItem.help:
            _openHelpPage(context);
            break;
          case _MobileSettingsPopupMenuItem.helpAndDocumentation:
            _openHelpAndDocumentationPage(context);
            break;
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: UniflowSvg(
          UniflowSvgs.m_settings_more_s,
        ),
      ),
    );
  }

  PopupMenuItem<T> _buildItem<T>({
    required T value,
    required UniflowSvgData svg,
    required String text,
  }) {
    return PopupMenuItem<T>(
      value: value,
      padding: EdgeInsets.zero,
      child: _PopupButton(
        svg: svg,
        text: text,
      ),
    );
  }

  void _openMembersPage(BuildContext context) {
    context.push(InviteMembersScreen.routeName);
  }

  void _openTrashPage(BuildContext context) {
    context.push(MobileHomeTrashPage.routeName);
  }

  void _openHelpPage(BuildContext context) {
    afLaunchUrlString('https://discord.com/invite/9Q2xaN37tV');
  }

  void _openSettingsPage(BuildContext context) {
    context.push(MobileHomeSettingPage.routeName);
  }

  void _openHelpAndDocumentationPage(BuildContext context) {
    afLaunchUrlString('https://universalworkspace.com/guide');
  }
}

class _PopupButton extends StatelessWidget {
  const _PopupButton({
    required this.svg,
    required this.text,
  });

  final UniflowSvgData svg;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          UniflowSvg(svg, size: const Size.square(20)),
          const HSpace(12),
          UniflowText.regular(
            text,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
