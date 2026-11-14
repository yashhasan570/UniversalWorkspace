import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/extensions/uniflow_tint_extension.dart';
import 'package:universalworkspace/workspace/presentation/widgets/pop_up_action.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_infra_ui/style_widget/extension.dart';
import 'package:flutter/material.dart';

const tableCellDefaultColor = 'universalworkspace_table_cell_default_color';

enum TableOptionAction {
  addAfter,
  addBefore,
  delete,
  duplicate,
  clear,

  /// row|cell background color
  bgColor;

  Widget icon(Color? color) {
    switch (this) {
      case TableOptionAction.addAfter:
        return const UniflowSvg(UniflowSvgs.add_s);
      case TableOptionAction.addBefore:
        return const UniflowSvg(UniflowSvgs.add_s);
      case TableOptionAction.delete:
        return const UniflowSvg(UniflowSvgs.delete_s);
      case TableOptionAction.duplicate:
        return const UniflowSvg(UniflowSvgs.copy_s);
      case TableOptionAction.clear:
        return const UniflowSvg(UniflowSvgs.close_s);
      case TableOptionAction.bgColor:
        return const UniflowSvg(
          UniflowSvgs.color_format_m,
          size: Size.square(12),
        ).padding(all: 2.0);
    }
  }

  String get description {
    switch (this) {
      case TableOptionAction.addAfter:
        return LocaleKeys.document_plugins_table_addAfter.tr();
      case TableOptionAction.addBefore:
        return LocaleKeys.document_plugins_table_addBefore.tr();
      case TableOptionAction.delete:
        return LocaleKeys.document_plugins_table_delete.tr();
      case TableOptionAction.duplicate:
        return LocaleKeys.document_plugins_table_duplicate.tr();
      case TableOptionAction.clear:
        return LocaleKeys.document_plugins_table_clear.tr();
      case TableOptionAction.bgColor:
        return LocaleKeys.document_plugins_table_bgColor.tr();
    }
  }
}

class TableOptionActionWrapper extends ActionCell {
  TableOptionActionWrapper(this.inner);

  final TableOptionAction inner;

  @override
  Widget? leftIcon(Color iconColor) => inner.icon(iconColor);

  @override
  String get name => inner.description;
}

class TableColorOptionAction extends PopoverActionCell {
  TableColorOptionAction({
    required this.node,
    required this.editorState,
    required this.position,
    required this.dir,
  });

  final Node node;
  final EditorState editorState;
  final int position;
  final TableDirection dir;

  @override
  Widget? leftIcon(Color iconColor) =>
      TableOptionAction.bgColor.icon(iconColor);

  @override
  String get name => TableOptionAction.bgColor.description;

  @override
  Widget Function(
    BuildContext context,
    PopoverController parentController,
    PopoverController controller,
  ) get builder => (context, parentController, controller) {
        int row = 0, col = position;
        if (dir == TableDirection.row) {
          col = 0;
          row = position;
        }

        final cell = node.children.firstWhereOrNull(
          (n) =>
              n.attributes[TableCellBlockKeys.colPosition] == col &&
              n.attributes[TableCellBlockKeys.rowPosition] == row,
        );
        final key = dir == TableDirection.col
            ? TableCellBlockKeys.colBackgroundColor
            : TableCellBlockKeys.rowBackgroundColor;
        final bgColor = cell?.attributes[key] as String?;
        final selectedColor = bgColor?.tryToColor();
        // get default background color from themeExtension
        final defaultColor = AFThemeExtension.of(context).tableCellBGColor;
        final colors = [
          // reset to default background color
          UniflowColorOption(
            color: defaultColor,
            i18n: LocaleKeys.document_plugins_optionAction_defaultColor.tr(),
            id: tableCellDefaultColor,
          ),
          ...UniflowTint.values.map(
            (e) => UniflowColorOption(
              color: e.color(context),
              i18n: e.tintName(AppFlowyEditorL10n.current),
              id: e.id,
            ),
          ),
        ];

        return UniflowColorPicker(
          colors: colors,
          selected: selectedColor,
          border: Border.all(
            color: AFThemeExtension.of(context).onBackground,
          ),
          onTap: (option, index) async {
            final backgroundColor =
                selectedColor != option.color ? option.id : '';
            TableActions.setBgColor(
              node,
              position,
              editorState,
              backgroundColor,
              dir,
            );

            controller.close();
            parentController.close();
          },
        );
      };
}
