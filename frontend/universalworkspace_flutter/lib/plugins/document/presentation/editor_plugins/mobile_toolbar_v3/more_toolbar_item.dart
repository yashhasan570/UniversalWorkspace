import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';

final moreToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      icon: UniflowSvgs.m_toolbar_more_s,
      onTap: () {},
    );
  },
);
