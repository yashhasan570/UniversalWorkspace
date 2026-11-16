import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart'
    hide QuoteBlockKeys, quoteNode;
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:easy_localization/easy_localization.dart';

export 'align_option_action.dart';
export 'color_option_action.dart';
export 'depth_option_action.dart';
export 'divider_option_action.dart';
export 'turn_into_option_action.dart';

enum EditorOptionActionType {
  turnInto,
  color,
  align,
  depth;

  Set<String> get supportTypes {
    switch (this) {
      case EditorOptionActionType.turnInto:
        return {
          ParagraphBlockKeys.type,
          HeadingBlockKeys.type,
          QuoteBlockKeys.type,
          CalloutBlockKeys.type,
          BulletedListBlockKeys.type,
          NumberedListBlockKeys.type,
          TodoListBlockKeys.type,
          ToggleListBlockKeys.type,
          SubPageBlockKeys.type,
        };
      case EditorOptionActionType.color:
        return {
          ParagraphBlockKeys.type,
          HeadingBlockKeys.type,
          BulletedListBlockKeys.type,
          NumberedListBlockKeys.type,
          QuoteBlockKeys.type,
          TodoListBlockKeys.type,
          CalloutBlockKeys.type,
          OutlineBlockKeys.type,
          ToggleListBlockKeys.type,
        };
      case EditorOptionActionType.align:
        return {
          ImageBlockKeys.type,
          SimpleTableBlockKeys.type,
        };
      case EditorOptionActionType.depth:
        return {
          OutlineBlockKeys.type,
        };
    }
  }
}

enum OptionAction {
  delete,
  duplicate,
  turnInto,
  moveUp,
  moveDown,
  copyLinkToBlock,

  /// callout background color
  color,
  divider,
  align,

  // Outline block
  depth,

  // Simple table
  setToPageWidth,
  distributeColumnsEvenly;

  UniflowSvgData get svg {
    switch (this) {
      case OptionAction.delete:
        return UniflowSvgs.trash_s;
      case OptionAction.duplicate:
        return UniflowSvgs.copy_s;
      case OptionAction.turnInto:
        return UniflowSvgs.turninto_s;
      case OptionAction.moveUp:
        return const UniflowSvgData('editor/move_up');
      case OptionAction.moveDown:
        return const UniflowSvgData('editor/move_down');
      case OptionAction.color:
        return const UniflowSvgData('editor/color');
      case OptionAction.divider:
        return const UniflowSvgData('editor/divider');
      case OptionAction.align:
        return UniflowSvgs.m_aa_bulleted_list_s;
      case OptionAction.depth:
        return UniflowSvgs.tag_s;
      case OptionAction.copyLinkToBlock:
        return UniflowSvgs.share_tab_copy_s;
      case OptionAction.setToPageWidth:
        return UniflowSvgs.table_set_to_page_width_s;
      case OptionAction.distributeColumnsEvenly:
        return UniflowSvgs.table_distribute_columns_evenly_s;
    }
  }

  String get description {
    switch (this) {
      case OptionAction.delete:
        return LocaleKeys.document_plugins_optionAction_delete.tr();
      case OptionAction.duplicate:
        return LocaleKeys.document_plugins_optionAction_duplicate.tr();
      case OptionAction.turnInto:
        return LocaleKeys.document_plugins_optionAction_turnInto.tr();
      case OptionAction.moveUp:
        return LocaleKeys.document_plugins_optionAction_moveUp.tr();
      case OptionAction.moveDown:
        return LocaleKeys.document_plugins_optionAction_moveDown.tr();
      case OptionAction.color:
        return LocaleKeys.document_plugins_optionAction_color.tr();
      case OptionAction.align:
        return LocaleKeys.document_plugins_optionAction_align.tr();
      case OptionAction.depth:
        return LocaleKeys.document_plugins_optionAction_depth.tr();
      case OptionAction.copyLinkToBlock:
        return LocaleKeys.document_plugins_optionAction_copyLinkToBlock.tr();
      case OptionAction.divider:
        throw UnsupportedError('Divider does not have description');
      case OptionAction.setToPageWidth:
        return LocaleKeys
            .document_plugins_simpleTable_moreActions_setToPageWidth
            .tr();
      case OptionAction.distributeColumnsEvenly:
        return LocaleKeys
            .document_plugins_simpleTable_moreActions_distributeColumnsWidth
            .tr();
    }
  }
}
