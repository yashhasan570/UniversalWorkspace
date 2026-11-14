import 'dart:async';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/show_mobile_bottom_sheet.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/simple_table/simple_table.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

enum SimpleTableMoreActionType {
  column,
  row;

  List<SimpleTableMoreAction> buildDesktopActions({
    required int index,
    required int columnLength,
    required int rowLength,
  }) {
    // there're two special cases:
    // 1. if the table only contains one row or one column, remove the delete action
    // 2. if the index is 0, add the enable header action
    switch (this) {
      case SimpleTableMoreActionType.row:
        return [
          SimpleTableMoreAction.insertAbove,
          SimpleTableMoreAction.insertBelow,
          SimpleTableMoreAction.divider,
          if (index == 0) SimpleTableMoreAction.enableHeaderRow,
          SimpleTableMoreAction.backgroundColor,
          SimpleTableMoreAction.align,
          SimpleTableMoreAction.divider,
          SimpleTableMoreAction.setToPageWidth,
          SimpleTableMoreAction.distributeColumnsEvenly,
          SimpleTableMoreAction.divider,
          SimpleTableMoreAction.duplicate,
          SimpleTableMoreAction.clearContents,
          if (rowLength > 1) SimpleTableMoreAction.delete,
        ];
      case SimpleTableMoreActionType.column:
        return [
          SimpleTableMoreAction.insertLeft,
          SimpleTableMoreAction.insertRight,
          SimpleTableMoreAction.divider,
          if (index == 0) SimpleTableMoreAction.enableHeaderColumn,
          SimpleTableMoreAction.backgroundColor,
          SimpleTableMoreAction.align,
          SimpleTableMoreAction.divider,
          SimpleTableMoreAction.setToPageWidth,
          SimpleTableMoreAction.distributeColumnsEvenly,
          SimpleTableMoreAction.divider,
          SimpleTableMoreAction.duplicate,
          SimpleTableMoreAction.clearContents,
          if (columnLength > 1) SimpleTableMoreAction.delete,
        ];
    }
  }

  List<List<SimpleTableMoreAction>> buildMobileActions({
    required int index,
    required int columnLength,
    required int rowLength,
  }) {
    // the actions on mobile are not the same as the desktop ones
    // the mobile actions are grouped into different sections
    switch (this) {
      case SimpleTableMoreActionType.row:
        return [
          if (index == 0) [SimpleTableMoreAction.enableHeaderRow],
          [
            SimpleTableMoreAction.setToPageWidth,
            SimpleTableMoreAction.distributeColumnsEvenly,
          ],
          [
            SimpleTableMoreAction.duplicateRow,
            SimpleTableMoreAction.clearContents,
          ],
        ];
      case SimpleTableMoreActionType.column:
        return [
          if (index == 0) [SimpleTableMoreAction.enableHeaderColumn],
          [
            SimpleTableMoreAction.setToPageWidth,
            SimpleTableMoreAction.distributeColumnsEvenly,
          ],
          [
            SimpleTableMoreAction.duplicateColumn,
            SimpleTableMoreAction.clearContents,
          ],
        ];
    }
  }

  UniflowSvgData get reorderIconSvg {
    switch (this) {
      case SimpleTableMoreActionType.column:
        return UniflowSvgs.table_reorder_column_s;
      case SimpleTableMoreActionType.row:
        return UniflowSvgs.table_reorder_row_s;
    }
  }

  @override
  String toString() {
    return switch (this) {
      SimpleTableMoreActionType.column => 'column',
      SimpleTableMoreActionType.row => 'row',
    };
  }
}

enum SimpleTableMoreAction {
  insertLeft,
  insertRight,
  insertAbove,
  insertBelow,
  duplicate,
  clearContents,
  delete,
  align,
  backgroundColor,
  enableHeaderColumn,
  enableHeaderRow,
  setToPageWidth,
  distributeColumnsEvenly,
  divider,

  // these actions are only available on mobile
  duplicateRow,
  duplicateColumn,
  cut,
  copy,
  paste,
  bold,
  textColor,
  textBackgroundColor,
  duplicateTable,
  copyLinkToBlock;

  String get name {
    return switch (this) {
      SimpleTableMoreAction.align =>
        LocaleKeys.document_plugins_simpleTable_moreActions_align.tr(),
      SimpleTableMoreAction.backgroundColor =>
        LocaleKeys.document_plugins_simpleTable_moreActions_color.tr(),
      SimpleTableMoreAction.enableHeaderColumn =>
        LocaleKeys.document_plugins_simpleTable_moreActions_headerColumn.tr(),
      SimpleTableMoreAction.enableHeaderRow =>
        LocaleKeys.document_plugins_simpleTable_moreActions_headerRow.tr(),
      SimpleTableMoreAction.insertLeft =>
        LocaleKeys.document_plugins_simpleTable_moreActions_insertLeft.tr(),
      SimpleTableMoreAction.insertRight =>
        LocaleKeys.document_plugins_simpleTable_moreActions_insertRight.tr(),
      SimpleTableMoreAction.insertBelow =>
        LocaleKeys.document_plugins_simpleTable_moreActions_insertBelow.tr(),
      SimpleTableMoreAction.insertAbove =>
        LocaleKeys.document_plugins_simpleTable_moreActions_insertAbove.tr(),
      SimpleTableMoreAction.clearContents =>
        LocaleKeys.document_plugins_simpleTable_moreActions_clearContents.tr(),
      SimpleTableMoreAction.delete =>
        LocaleKeys.document_plugins_simpleTable_moreActions_delete.tr(),
      SimpleTableMoreAction.duplicate =>
        LocaleKeys.document_plugins_simpleTable_moreActions_duplicate.tr(),
      SimpleTableMoreAction.setToPageWidth =>
        LocaleKeys.document_plugins_simpleTable_moreActions_setToPageWidth.tr(),
      SimpleTableMoreAction.distributeColumnsEvenly => LocaleKeys
          .document_plugins_simpleTable_moreActions_distributeColumnsWidth
          .tr(),
      SimpleTableMoreAction.duplicateRow =>
        LocaleKeys.document_plugins_simpleTable_moreActions_duplicateRow.tr(),
      SimpleTableMoreAction.duplicateColumn => LocaleKeys
          .document_plugins_simpleTable_moreActions_duplicateColumn
          .tr(),
      SimpleTableMoreAction.duplicateTable =>
        LocaleKeys.document_plugins_simpleTable_moreActions_duplicateTable.tr(),
      SimpleTableMoreAction.copyLinkToBlock =>
        LocaleKeys.document_plugins_optionAction_copyLinkToBlock.tr(),
      SimpleTableMoreAction.bold ||
      SimpleTableMoreAction.textColor ||
      SimpleTableMoreAction.textBackgroundColor ||
      SimpleTableMoreAction.cut ||
      SimpleTableMoreAction.copy ||
      SimpleTableMoreAction.paste =>
        throw UnimplementedError(),
      SimpleTableMoreAction.divider => throw UnimplementedError(),
    };
  }

  UniflowSvgData get leftIconSvg {
    return switch (this) {
      SimpleTableMoreAction.insertLeft => UniflowSvgs.table_insert_left_s,
      SimpleTableMoreAction.insertRight => UniflowSvgs.table_insert_right_s,
      SimpleTableMoreAction.insertAbove => UniflowSvgs.table_insert_above_s,
      SimpleTableMoreAction.insertBelow => UniflowSvgs.table_insert_below_s,
      SimpleTableMoreAction.duplicate => UniflowSvgs.duplicate_s,
      SimpleTableMoreAction.clearContents => UniflowSvgs.table_clear_content_s,
      SimpleTableMoreAction.delete => UniflowSvgs.trash_s,
      SimpleTableMoreAction.setToPageWidth =>
        UniflowSvgs.table_set_to_page_width_s,
      SimpleTableMoreAction.distributeColumnsEvenly =>
        UniflowSvgs.table_distribute_columns_evenly_s,
      SimpleTableMoreAction.enableHeaderColumn =>
        UniflowSvgs.table_header_column_s,
      SimpleTableMoreAction.enableHeaderRow => UniflowSvgs.table_header_row_s,
      SimpleTableMoreAction.duplicateRow => UniflowSvgs.m_table_duplicate_s,
      SimpleTableMoreAction.duplicateColumn => UniflowSvgs.m_table_duplicate_s,
      SimpleTableMoreAction.cut => UniflowSvgs.m_table_quick_action_cut_s,
      SimpleTableMoreAction.copy => UniflowSvgs.m_table_quick_action_copy_s,
      SimpleTableMoreAction.paste => UniflowSvgs.m_table_quick_action_paste_s,
      SimpleTableMoreAction.bold => UniflowSvgs.m_aa_bold_s,
      SimpleTableMoreAction.duplicateTable => UniflowSvgs.m_table_duplicate_s,
      SimpleTableMoreAction.copyLinkToBlock => UniflowSvgs.m_copy_link_s,
      SimpleTableMoreAction.align => UniflowSvgs.m_aa_align_left_s,
      SimpleTableMoreAction.textColor =>
        throw UnsupportedError('text color icon is not supported'),
      SimpleTableMoreAction.textBackgroundColor =>
        throw UnsupportedError('text background color icon is not supported'),
      SimpleTableMoreAction.divider =>
        throw UnsupportedError('divider icon is not supported'),
      SimpleTableMoreAction.backgroundColor =>
        throw UnsupportedError('background color icon is not supported'),
    };
  }
}

class SimpleTableMoreActionMenu extends StatefulWidget {
  const SimpleTableMoreActionMenu({
    super.key,
    required this.index,
    required this.type,
    required this.tableCellNode,
  });

  final int index;
  final SimpleTableMoreActionType type;
  final Node tableCellNode;

  @override
  State<SimpleTableMoreActionMenu> createState() =>
      _SimpleTableMoreActionMenuState();
}

class _SimpleTableMoreActionMenuState extends State<SimpleTableMoreActionMenu> {
  ValueNotifier<bool> isShowingMenu = ValueNotifier(false);
  ValueNotifier<bool> isEditingCellNotifier = ValueNotifier(false);

  late final editorState = context.read<EditorState>();
  late final simpleTableContext = context.read<SimpleTableContext>();

  @override
  void initState() {
    super.initState();

    editorState.selectionNotifier.addListener(_onSelectionChanged);
  }

  @override
  void dispose() {
    isShowingMenu.dispose();
    isEditingCellNotifier.dispose();

    editorState.selectionNotifier.removeListener(_onSelectionChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.type == SimpleTableMoreActionType.row
          ? UniversalPlatform.isDesktop
              ? Alignment.centerLeft
              : Alignment.centerRight
          : Alignment.topCenter,
      child: UniversalPlatform.isDesktop
          ? _buildDesktopMenu()
          : _buildMobileMenu(),
    );
  }

  // On desktop, the menu is a popup and only shows when hovering.
  Widget _buildDesktopMenu() {
    return ValueListenableBuilder<bool>(
      valueListenable: isShowingMenu,
      builder: (context, isShowingMenu, child) {
        return ValueListenableBuilder(
          valueListenable: simpleTableContext.hoveringTableCell,
          builder: (context, hoveringTableNode, child) {
            final reorderingIndex = switch (widget.type) {
              SimpleTableMoreActionType.column =>
                simpleTableContext.isReorderingColumn.value.$2,
              SimpleTableMoreActionType.row =>
                simpleTableContext.isReorderingRow.value.$2,
            };
            final isReordering = simpleTableContext.isReordering;
            if (isReordering) {
              // when reordering, hide the menu for another column or row that is not the current dragging one.
              if (reorderingIndex != widget.index) {
                return const SizedBox.shrink();
              } else {
                return child!;
              }
            }

            final hoveringIndex =
                widget.type == SimpleTableMoreActionType.column
                    ? hoveringTableNode?.columnIndex
                    : hoveringTableNode?.rowIndex;

            if (hoveringIndex != widget.index && !isShowingMenu) {
              return const SizedBox.shrink();
            }

            return child!;
          },
          child: SimpleTableMoreActionPopup(
            index: widget.index,
            isShowingMenu: this.isShowingMenu,
            type: widget.type,
          ),
        );
      },
    );
  }

  // On mobile, the menu is a action sheet and always shows.
  Widget _buildMobileMenu() {
    return ValueListenableBuilder(
      valueListenable: isShowingMenu,
      builder: (context, isShowingMenu, child) {
        return ValueListenableBuilder(
          valueListenable: simpleTableContext.isEditingCell,
          builder: (context, isEditingCell, child) {
            if (isShowingMenu) {
              return child!;
            }

            if (isEditingCell == null) {
              return const SizedBox.shrink();
            }

            final columnIndex = isEditingCell.columnIndex;
            final rowIndex = isEditingCell.rowIndex;

            switch (widget.type) {
              case SimpleTableMoreActionType.column:
                if (columnIndex != widget.index) {
                  return const SizedBox.shrink();
                }
              case SimpleTableMoreActionType.row:
                if (rowIndex != widget.index) {
                  return const SizedBox.shrink();
                }
            }

            return child!;
          },
          child: SimpleTableMobileDraggableReorderButton(
            index: widget.index,
            type: widget.type,
            cellNode: widget.tableCellNode,
            isShowingMenu: this.isShowingMenu,
            editorState: editorState,
            simpleTableContext: simpleTableContext,
          ),
        );
      },
    );
  }

  void _onSelectionChanged() {
    final selection = editorState.selection;

    // check if the selection is in the cell
    if (selection != null &&
        widget.tableCellNode.path.isAncestorOf(selection.start.path) &&
        widget.tableCellNode.path.isAncestorOf(selection.end.path)) {
      isEditingCellNotifier.value = true;
    } else {
      isEditingCellNotifier.value = false;
    }
  }
}

/// This widget is only used on mobile
class SimpleTableActionMenu extends StatelessWidget {
  const SimpleTableActionMenu({
    super.key,
    required this.tableNode,
    required this.editorState,
  });

  final Node tableNode;
  final EditorState editorState;

  @override
  Widget build(BuildContext context) {
    final simpleTableContext = context.read<SimpleTableContext>();
    return ValueListenableBuilder<Node?>(
      valueListenable: simpleTableContext.isEditingCell,
      builder: (context, isEditingCell, child) {
        if (isEditingCell == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            editorState.service.keyboardService?.closeKeyboard();
            // delay the bottom sheet show to make sure the keyboard is closed
            Future.delayed(Durations.short3, () {
              if (context.mounted) {
                _showTableActionBottomSheet(context);
              }
            });
          },
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            child: const UniflowSvg(
              UniflowSvgs.drag_element_s,
              size: Size.square(18.0),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTableActionBottomSheet(BuildContext context) async {
    // check if the table node is a simple table
    assert(tableNode.type == SimpleTableBlockKeys.type);

    if (tableNode.type != SimpleTableBlockKeys.type) {
      Log.error('The table node is not a simple table');
      return;
    }

    final beforeSelection = editorState.selection;

    // increase the keep editor focus notifier to prevent the editor from losing focus
    keepEditorFocusNotifier.increase();

    unawaited(
      editorState.updateSelectionWithReason(
        Selection.collapsed(
          Position(
            path: tableNode.path,
          ),
        ),
        customSelectionType: SelectionType.block,
        extraInfo: {
          selectionExtraInfoDisableMobileToolbarKey: true,
          selectionExtraInfoDoNotAttachTextService: true,
        },
      ),
    );

    if (!context.mounted) {
      return;
    }

    final simpleTableContext = context.read<SimpleTableContext>();

    simpleTableContext.isSelectingTable.value = true;

    // show the bottom sheet
    await showMobileBottomSheet(
      context,
      showDragHandle: true,
      showDivider: false,
      useSafeArea: false,
      enablePadding: false,
      builder: (context) => Provider.value(
        value: simpleTableContext,
        child: SimpleTableBottomSheet(
          tableNode: tableNode,
          editorState: editorState,
        ),
      ),
    );

    simpleTableContext.isSelectingTable.value = false;
    keepEditorFocusNotifier.decrease();

    // remove the extra info
    if (beforeSelection != null) {
      await editorState.updateSelectionWithReason(
        beforeSelection,
        customSelectionType: SelectionType.inline,
        reason: SelectionUpdateReason.uiEvent,
        extraInfo: {},
      );
    }
  }
}
