import 'package:universalworkspace/features/page_access_level/logic/page_access_level_bloc.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MobileViewItemBottomSheetBodyAction {
  rename,
  duplicate,
  share,
  delete,
  addToFavorites,
  removeFromFavorites,
  divider,
  removeFromRecent,
}

class MobileViewItemBottomSheetBody extends StatelessWidget {
  const MobileViewItemBottomSheetBody({
    super.key,
    this.isFavorite = false,
    required this.onAction,
    required this.actions,
  });

  final bool isFavorite;
  final void Function(MobileViewItemBottomSheetBodyAction action) onAction;
  final List<MobileViewItemBottomSheetBodyAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          actions.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    MobileViewItemBottomSheetBodyAction action,
  ) {
    final isLocked =
        context.read<PageAccessLevelBloc?>()?.state.isLocked ?? false;
    switch (action) {
      case MobileViewItemBottomSheetBodyAction.rename:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_rename.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.view_item_rename_s,
            size: Size.square(18),
          ),
          enable: !isLocked,
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.rename,
          ),
        );
      case MobileViewItemBottomSheetBodyAction.duplicate:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_duplicate.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.duplicate_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.duplicate,
          ),
        );

      case MobileViewItemBottomSheetBodyAction.share:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_share.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.share_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.share,
          ),
        );
      case MobileViewItemBottomSheetBodyAction.delete:
        return UniflowOptionTile.text(
          text: LocaleKeys.button_delete.tr(),
          height: 52.0,
          textColor: Theme.of(context).colorScheme.error,
          leftIcon: UniflowSvg(
            UniflowSvgs.trash_s,
            size: const Size.square(18),
            color: Theme.of(context).colorScheme.error,
          ),
          enable: !isLocked,
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.delete,
          ),
        );
      case MobileViewItemBottomSheetBodyAction.addToFavorites:
        return UniflowOptionTile.text(
          height: 52.0,
          text: LocaleKeys.button_addToFavorites.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.favorite_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.addToFavorites,
          ),
        );
      case MobileViewItemBottomSheetBodyAction.removeFromFavorites:
        return UniflowOptionTile.text(
          height: 52.0,
          text: LocaleKeys.button_removeFromFavorites.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.favorite_section_remove_from_favorite_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.removeFromFavorites,
          ),
        );
      case MobileViewItemBottomSheetBodyAction.removeFromRecent:
        return UniflowOptionTile.text(
          height: 52.0,
          text: LocaleKeys.button_removeFromRecent.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.remove_from_recent_s,
            size: Size.square(18),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(
            MobileViewItemBottomSheetBodyAction.removeFromRecent,
          ),
        );

      case MobileViewItemBottomSheetBodyAction.divider:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Divider(height: 0.5),
        );
    }
  }
}
