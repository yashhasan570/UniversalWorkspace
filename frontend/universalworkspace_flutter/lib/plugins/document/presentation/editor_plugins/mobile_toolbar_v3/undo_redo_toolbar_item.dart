import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_toolbar_theme.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/widgets.dart';

final undoToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    final theme = ToolbarColorExtension.of(context);
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      iconBuilder: (context) {
        final canUndo = editorState.undoManager.undoStack.isNonEmpty;
        return Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
          ),
          child: UniflowSvg(
            UniflowSvgs.m_toolbar_undo_m,
            color: canUndo
                ? theme.toolbarItemIconColor
                : theme.toolbarItemIconDisabledColor,
          ),
        );
      },
      onTap: () => undoCommand.execute(editorState),
    );
  },
);

final redoToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    final theme = ToolbarColorExtension.of(context);
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      iconBuilder: (context) {
        final canRedo = editorState.undoManager.redoStack.isNonEmpty;
        return Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
          ),
          child: UniflowSvg(
            UniflowSvgs.m_toolbar_redo_m,
            color: canRedo
                ? theme.toolbarItemIconColor
                : theme.toolbarItemIconDisabledColor,
          ),
        );
      },
      onTap: () => redoCommand.execute(editorState),
    );
  },
);
