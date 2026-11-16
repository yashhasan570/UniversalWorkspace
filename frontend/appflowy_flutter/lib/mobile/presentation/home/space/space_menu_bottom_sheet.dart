import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/space_action_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SpaceMenuMoreOptions extends StatelessWidget {
  const SpaceMenuMoreOptions({
    super.key,
    required this.onAction,
    required this.actions,
  });

  final void Function(SpaceMoreActionType action) onAction;
  final List<SpaceMoreActionType> actions;

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
    SpaceMoreActionType action,
  ) {
    switch (action) {
      case SpaceMoreActionType.rename:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_rename.tr(),
          height: SpaceUIConstants.itemHeight,
          leftIcon: const UniflowSvg(
            UniflowSvgs.view_item_rename_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            SpaceMoreActionType.rename,
          ),
        );
      case SpaceMoreActionType.delete:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_delete.tr(),
          height: SpaceUIConstants.itemHeight,
          textColor: Theme.of(context).colorScheme.error,
          leftIcon: UniflowSvg(
            UniflowSvgs.trash_s,
            size: const Size.square(18),
            color: Theme.of(context).colorScheme.error,
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            SpaceMoreActionType.delete,
          ),
        );
      case SpaceMoreActionType.manage:
        return UniflowOptionTile.text(
          text: LocaleKeys.space_manage.tr(),
          height: SpaceUIConstants.itemHeight,
          leftIcon: const UniflowSvg(
            UniflowSvgs.settings_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            SpaceMoreActionType.manage,
          ),
        );
      case SpaceMoreActionType.duplicate:
        return UniflowOptionTile.text(
          text: SpaceMoreActionType.duplicate.name,
          height: SpaceUIConstants.itemHeight,
          leftIcon: const UniflowSvg(
            UniflowSvgs.duplicate_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            SpaceMoreActionType.duplicate,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
