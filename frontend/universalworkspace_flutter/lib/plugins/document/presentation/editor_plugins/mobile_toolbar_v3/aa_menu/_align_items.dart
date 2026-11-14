import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_menu_item.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_popup_menu.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_toolbar_theme.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/util.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

const _left = 'left';
const _center = 'center';
const _right = 'right';

class AlignItems extends StatelessWidget {
  AlignItems({
    super.key,
    required this.editorState,
  });

  final EditorState editorState;
  final List<(String, UniflowSvgData)> _alignMenuItems = [
    (_left, UniflowSvgs.m_aa_align_left_m),
    (_center, UniflowSvgs.m_aa_align_center_m),
    (_right, UniflowSvgs.m_aa_align_right_m),
  ];

  @override
  Widget build(BuildContext context) {
    final currentAlignItem = _getCurrentAlignItem();
    final theme = ToolbarColorExtension.of(context);
    return PopupMenu(
      itemLength: _alignMenuItems.length,
      onSelected: (index) {
        editorState.alignBlock(
          _alignMenuItems[index].$1,
          selectionExtraInfo: {
            selectionExtraInfoDoNotAttachTextService: true,
            selectionExtraInfoDisableFloatingToolbar: true,
          },
        );
      },
      menuBuilder: (context, keys, currentIndex) {
        final children = _alignMenuItems
            .mapIndexed(
              (index, e) => [
                PopupMenuItemWrapper(
                  key: keys[index],
                  isSelected: currentIndex == index,
                  icon: e.$2,
                ),
                if (index != 0 && index != _alignMenuItems.length - 1)
                  const HSpace(12),
              ],
            )
            .flattened
            .toList();
        return PopupMenuWrapper(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      },
      builder: (context, key) => MobileToolbarMenuItemWrapper(
        key: key,
        size: const Size(82, 52),
        onTap: () async {
          await editorState.alignBlock(
            currentAlignItem.$1,
            selectionExtraInfo: {
              selectionExtraInfoDoNotAttachTextService: true,
              selectionExtraInfoDisableFloatingToolbar: true,
            },
          );
        },
        icon: currentAlignItem.$2,
        isSelected: false,
        iconPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
        ),
        showDownArrow: true,
        backgroundColor: theme.toolbarMenuItemBackgroundColor,
      ),
    );
  }

  (String, UniflowSvgData) _getCurrentAlignItem() {
    final align = _getCurrentBlockAlign();
    if (align == _center) {
      return (_right, UniflowSvgs.m_aa_align_right_s);
    } else if (align == _right) {
      return (_left, UniflowSvgs.m_aa_align_left_s);
    } else {
      return (_center, UniflowSvgs.m_aa_align_center_s);
    }
  }

  String _getCurrentBlockAlign() {
    final selection = editorState.selection;
    if (selection == null) {
      return _left;
    }
    final nodes = editorState.getNodesInSelection(selection);
    String? alignString;
    for (final node in nodes) {
      final align = node.attributes[blockComponentAlign];
      if (alignString == null) {
        alignString = align;
      } else if (alignString != align) {
        return _left;
      }
    }
    return alignString ?? _left;
  }
}
