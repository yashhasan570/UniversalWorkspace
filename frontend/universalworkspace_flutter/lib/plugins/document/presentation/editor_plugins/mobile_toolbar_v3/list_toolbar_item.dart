import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

final todoListToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      keepSelectedStatus: true,
      isSelected: () => false,
      icon: UniflowSvgs.m_toolbar_checkbox_m,
      onTap: () async {
        await editorState.convertBlockType(
          TodoListBlockKeys.type,
          extraAttributes: {
            TodoListBlockKeys.checked: false,
          },
        );
      },
    );
  },
);

final numberedListToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    final isSelected =
        editorState.isBlockTypeSelected(NumberedListBlockKeys.type);
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      keepSelectedStatus: true,
      isSelected: () => isSelected,
      icon: UniflowSvgs.m_toolbar_numbered_list_m,
      onTap: () async {
        await editorState.convertBlockType(
          NumberedListBlockKeys.type,
        );
      },
    );
  },
);

final bulletedListToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    final isSelected =
        editorState.isBlockTypeSelected(BulletedListBlockKeys.type);
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      keepSelectedStatus: true,
      isSelected: () => isSelected,
      icon: UniflowSvgs.m_toolbar_bulleted_list_m,
      onTap: () async {
        await editorState.convertBlockType(
          BulletedListBlockKeys.type,
        );
      },
    );
  },
);
