import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/uniflow_icon_emoji_picker.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/workspace/_sidebar_workspace_actions.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/workspace/_sidebar_workspace_icon.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/workspace/_sidebar_workspace_menu.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/workspace/sidebar_workspace.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialog_v2.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

extension UniversalWorkspaceWorkspace on WidgetTester {
  /// Open workspace menu
  Future<void> openWorkspaceMenu() async {
    final workspaceWrapper = find.byType(SidebarSwitchWorkspaceButton);
    expect(workspaceWrapper, findsOneWidget);
    await tapButton(workspaceWrapper);
    final workspaceMenu = find.byType(WorkspacesMenu);
    expect(workspaceMenu, findsOneWidget);
  }

  /// Open a workspace
  Future<void> openWorkspace(String name) async {
    final workspace = find.descendant(
      of: find.byType(WorkspaceMenuItem),
      matching: find.findTextInUniflowText(name),
    );
    expect(workspace, findsOneWidget);
    await tapButton(workspace);
  }

  Future<void> changeWorkspaceName(String name) async {
    final menuItem = find.byType(WorkspaceMenuItem);
    expect(menuItem, findsOneWidget);
    await hoverOnWidget(
      menuItem,
      onHover: () async {
        await tapButton(
          find.descendant(
            of: menuItem,
            matching: find.byType(WorkspaceMoreActionList),
          ),
        );
        await tapButton(find.text(LocaleKeys.button_rename.tr()));
        final input = find.descendant(
          of: find.byType(AFTextFieldDialog),
          matching: find.byType(AFTextField),
        );
        await enterText(input, name);
        await tapButton(find.text(LocaleKeys.button_confirm.tr()));
      },
    );
  }

  Future<void> changeWorkspaceIcon(String icon) async {
    final iconButton = find.descendant(
      of: find.byType(WorkspaceMenuItem),
      matching: find.byType(WorkspaceIcon),
    );
    expect(iconButton, findsOneWidget);
    await tapButton(iconButton);
    final iconPicker = find.byType(UniflowIconEmojiPicker);
    expect(iconPicker, findsOneWidget);
    await tapButton(find.findTextInUniflowText(icon));
  }
}
