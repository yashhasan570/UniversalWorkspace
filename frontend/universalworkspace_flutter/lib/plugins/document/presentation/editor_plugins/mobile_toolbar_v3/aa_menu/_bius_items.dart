import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_toolbar_theme.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/util.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class BIUSItems extends StatelessWidget {
  BIUSItems({
    super.key,
    required this.editorState,
  });

  final EditorState editorState;

  final List<(UniflowSvgData, String)> _bius = [
    (UniflowSvgs.m_toolbar_bold_m, UniversalWorkspaceRichTextKeys.bold),
    (UniflowSvgs.m_toolbar_italic_m, UniversalWorkspaceRichTextKeys.italic),
    (UniflowSvgs.m_toolbar_underline_m, UniversalWorkspaceRichTextKeys.underline),
    (UniflowSvgs.m_toolbar_strike_m, UniversalWorkspaceRichTextKeys.strikethrough),
  ];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _bius
            .mapIndexed(
              (index, e) => [
                _buildBIUSItem(
                  context,
                  index,
                  e.$1,
                  e.$2,
                ),
                if (index != 0 || index != _bius.length - 1)
                  const ScaledVerticalDivider(),
              ],
            )
            .flattened
            .toList(),
      ),
    );
  }

  Widget _buildBIUSItem(
    BuildContext context,
    int index,
    UniflowSvgData icon,
    String richTextKey,
  ) {
    final theme = ToolbarColorExtension.of(context);
    return StatefulBuilder(
      builder: (_, setState) => MobileToolbarMenuItemWrapper(
        size: const Size(62, 52),
        enableTopLeftRadius: index == 0,
        enableBottomLeftRadius: index == 0,
        enableTopRightRadius: index == _bius.length - 1,
        enableBottomRightRadius: index == _bius.length - 1,
        backgroundColor: theme.toolbarMenuItemBackgroundColor,
        onTap: () async {
          await editorState.toggleAttribute(
            richTextKey,
            selectionExtraInfo: {
              selectionExtraInfoDisableFloatingToolbar: true,
              selectionExtraInfoDoNotAttachTextService: true,
            },
          );
          // refresh the status
          setState(() {});
        },
        icon: icon,
        isSelected: editorState.isTextDecorationSelected(richTextKey) &&
            editorState.toggledStyle[richTextKey] != false,
        iconPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
        ),
      ),
    );
  }
}
