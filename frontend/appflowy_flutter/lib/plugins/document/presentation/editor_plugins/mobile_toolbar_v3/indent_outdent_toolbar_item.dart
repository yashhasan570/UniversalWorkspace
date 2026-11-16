import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

final indentToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      keepSelectedStatus: true,
      isSelected: () => false,
      enable: () => isIndentable(editorState),
      icon: UniflowSvgs.m_aa_indent_m,
      onTap: () async {
        indentCommand.execute(editorState);
      },
    );
  },
);

final outdentToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      keepSelectedStatus: true,
      isSelected: () => false,
      enable: () => isOutdentable(editorState),
      icon: UniflowSvgs.m_aa_outdent_m,
      onTap: () async {
        outdentCommand.execute(editorState);
      },
    );
  },
);
