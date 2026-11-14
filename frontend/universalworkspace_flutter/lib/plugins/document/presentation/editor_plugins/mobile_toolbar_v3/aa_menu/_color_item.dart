import 'dart:async';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/font_colors.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/_get_selection_color.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_color_list.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_toolbar_theme.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({
    super.key,
    required this.editorState,
    required this.service,
  });

  final EditorState editorState;
  final UniversalWorkspaceMobileToolbarWidgetService service;

  @override
  Widget build(BuildContext context) {
    final theme = ToolbarColorExtension.of(context);
    final String? selectedTextColor =
        editorState.getSelectionColor(UniversalWorkspaceRichTextKeys.textColor);
    final String? selectedBackgroundColor =
        editorState.getSelectionColor(UniversalWorkspaceRichTextKeys.backgroundColor);
    final backgroundColor = EditorFontColors.fromBuiltInColors(
      context,
      selectedBackgroundColor?.tryToColor(),
    );
    return MobileToolbarMenuItemWrapper(
      size: const Size(82, 52),
      onTap: () async {
        service.closeKeyboard();
        unawaited(
          editorState.updateSelectionWithReason(
            editorState.selection,
            extraInfo: {
              selectionExtraInfoDisableMobileToolbarKey: true,
              selectionExtraInfoDisableFloatingToolbar: true,
              selectionExtraInfoDoNotAttachTextService: true,
            },
          ),
        );
        keepEditorFocusNotifier.increase();
        await showTextColorAndBackgroundColorPicker(
          context,
          editorState: editorState,
          selection: editorState.selection!,
        );
      },
      icon: UniflowSvgs.m_aa_font_color_m,
      iconColor: EditorFontColors.fromBuiltInColors(
        context,
        selectedTextColor?.tryToColor(),
      ),
      backgroundColor: backgroundColor ?? theme.toolbarMenuItemBackgroundColor,
      selectedBackgroundColor: backgroundColor,
      isSelected: selectedBackgroundColor != null,
      showRightArrow: true,
      iconPadding: const EdgeInsets.only(
        top: 14.0,
        bottom: 14.0,
        right: 28.0,
      ),
    );
  }
}
