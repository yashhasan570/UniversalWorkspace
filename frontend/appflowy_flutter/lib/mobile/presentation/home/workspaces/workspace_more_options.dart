import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum WorkspaceMenuMoreOption {
  rename,
  invite,
  delete,
  leave,
}

class WorkspaceMenuMoreOptions extends StatelessWidget {
  const WorkspaceMenuMoreOptions({
    super.key,
    this.isFavorite = false,
    required this.onAction,
    required this.actions,
  });

  final bool isFavorite;
  final void Function(WorkspaceMenuMoreOption action) onAction;
  final List<WorkspaceMenuMoreOption> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions
          .map(
            (action) => _buildActionButton(context, action),
          )
          .toList(),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WorkspaceMenuMoreOption action,
  ) {
    switch (action) {
      case WorkspaceMenuMoreOption.rename:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_rename.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.view_item_rename_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            WorkspaceMenuMoreOption.rename,
          ),
        );
      case WorkspaceMenuMoreOption.delete:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_delete.tr(),
          height: 52.0,
          textColor: Theme.of(context).colorScheme.error,
          leftIcon: UniflowSvg(
            UniflowSvgs.trash_s,
            size: const Size.square(18),
            color: Theme.of(context).colorScheme.error,
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            WorkspaceMenuMoreOption.delete,
          ),
        );
      case WorkspaceMenuMoreOption.invite:
        return UniflowOptionTile.text(
          // i18n
          text: 'Invite',
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.workspace_add_member_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            WorkspaceMenuMoreOption.invite,
          ),
        );
      case WorkspaceMenuMoreOption.leave:
        return UniflowOptionTile.text(
          text: LocaleKeys.workspace_leaveCurrentWorkspace.tr(),
          height: 52.0,
          textColor: Theme.of(context).colorScheme.error,
          leftIcon: UniflowSvg(
            UniflowSvgs.leave_workspace_s,
            size: const Size.square(18),
            color: Theme.of(context).colorScheme.error,
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            WorkspaceMenuMoreOption.leave,
          ),
        );
    }
  }
}
