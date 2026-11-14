import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum BlockActionBottomSheetType {
  delete,
  duplicate,
  insertAbove,
  insertBelow,
}

// Only works on mobile.
class BlockActionBottomSheet extends StatelessWidget {
  const BlockActionBottomSheet({
    super.key,
    required this.onAction,
    this.extendActionWidgets = const [],
  });

  final void Function(BlockActionBottomSheetType layout) onAction;
  final List<Widget> extendActionWidgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // insert above, insert below
        UniflowOptionTile.text(
          text: LocaleKeys.button_insertAbove.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.arrow_up_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          onTap: () => onAction(BlockActionBottomSheetType.insertAbove),
        ),
        UniflowOptionTile.text(
          showTopBorder: false,
          text: LocaleKeys.button_insertBelow.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.arrow_down_s,
            size: Size.square(20),
          ),
          onTap: () => onAction(BlockActionBottomSheetType.insertBelow),
        ),
        // duplicate, delete
        UniflowOptionTile.text(
          showTopBorder: false,
          text: LocaleKeys.button_duplicate.tr(),
          leftIcon: const Padding(
            padding: EdgeInsets.all(2),
            child: UniflowSvg(
              UniflowSvgs.copy_s,
              size: Size.square(16),
            ),
          ),
          onTap: () => onAction(BlockActionBottomSheetType.duplicate),
        ),

        ...extendActionWidgets,

        UniflowOptionTile.text(
          showTopBorder: false,
          text: LocaleKeys.button_delete.tr(),
          leftIcon: UniflowSvg(
            UniflowSvgs.trash_s,
            size: const Size.square(18),
            color: Theme.of(context).colorScheme.error,
          ),
          textColor: Theme.of(context).colorScheme.error,
          onTap: () => onAction(BlockActionBottomSheetType.delete),
        ),
      ],
    );
  }
}
