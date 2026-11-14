import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddNewPageWidgetBottomSheet extends StatelessWidget {
  const AddNewPageWidgetBottomSheet({
    super.key,
    required this.view,
    required this.onAction,
  });

  final ViewPB view;
  final void Function(ViewLayoutPB layout) onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UniflowOptionTile.text(
          text: LocaleKeys.document_menuName.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.icon_document_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(ViewLayoutPB.Document),
        ),
        UniflowOptionTile.text(
          text: LocaleKeys.grid_menuName.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.icon_grid_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(ViewLayoutPB.Grid),
        ),
        UniflowOptionTile.text(
          text: LocaleKeys.board_menuName.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.icon_board_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(ViewLayoutPB.Board),
        ),
        UniflowOptionTile.text(
          text: LocaleKeys.calendar_menuName.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.icon_calendar_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(ViewLayoutPB.Calendar),
        ),
        UniflowOptionTile.text(
          text: LocaleKeys.chat_newChat.tr(),
          height: 52.0,
          leftIcon: const UniflowSvg(
            UniflowSvgs.chat_ai_page_s,
            size: Size.square(20),
          ),
          showTopBorder: false,
          showBottomBorder: false,
          onTap: () => onAction(ViewLayoutPB.Chat),
        ),
      ],
    );
  }
}
