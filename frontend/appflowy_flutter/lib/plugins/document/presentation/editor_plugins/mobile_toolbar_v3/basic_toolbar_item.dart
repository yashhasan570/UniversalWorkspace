import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/font_colors.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_color_list.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/widgets.dart';

import 'link_toolbar_item.dart';

final boldToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () =>
          editorState.isTextDecorationSelected(
            UniversalWorkspaceRichTextKeys.bold,
          ) &&
          editorState.toggledStyle[UniversalWorkspaceRichTextKeys.bold] != false,
      icon: UniflowSvgs.m_toolbar_bold_m,
      onTap: () async => editorState.toggleAttribute(
        UniversalWorkspaceRichTextKeys.bold,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final italicToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        UniversalWorkspaceRichTextKeys.italic,
      ),
      icon: UniflowSvgs.m_toolbar_italic_m,
      onTap: () async => editorState.toggleAttribute(
        UniversalWorkspaceRichTextKeys.italic,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final underlineToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        UniversalWorkspaceRichTextKeys.underline,
      ),
      icon: UniflowSvgs.m_toolbar_underline_m,
      onTap: () async => editorState.toggleAttribute(
        UniversalWorkspaceRichTextKeys.underline,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final strikethroughToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        UniversalWorkspaceRichTextKeys.strikethrough,
      ),
      icon: UniflowSvgs.m_toolbar_strike_m,
      onTap: () async => editorState.toggleAttribute(
        UniversalWorkspaceRichTextKeys.strikethrough,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final colorToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, service, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      icon: UniflowSvgs.m_aa_font_color_m,
      iconBuilder: (context) {
        String? getColor(String key) {
          final selection = editorState.selection;
          if (selection == null) {
            return null;
          }
          String? color = editorState.toggledStyle[key];
          if (color == null) {
            if (selection.isCollapsed && selection.startIndex != 0) {
              color = editorState.getDeltaAttributeValueInSelection<String>(
                key,
                selection.copyWith(
                  start: selection.start.copyWith(
                    offset: selection.startIndex - 1,
                  ),
                ),
              );
            } else {
              color = editorState.getDeltaAttributeValueInSelection<String>(
                key,
              );
            }
          }
          return color;
        }

        final textColor = getColor(UniversalWorkspaceRichTextKeys.textColor);
        final backgroundColor = getColor(UniversalWorkspaceRichTextKeys.backgroundColor);

        return Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: EditorFontColors.fromBuiltInColors(
              context,
              backgroundColor?.tryToColor(),
            ),
          ),
          child: UniflowSvg(
            UniflowSvgs.m_aa_font_color_m,
            color: EditorFontColors.fromBuiltInColors(
              context,
              textColor?.tryToColor(),
            ),
          ),
        );
      },
      onTap: () {
        service.closeKeyboard();
        editorState.updateSelectionWithReason(
          editorState.selection,
          extraInfo: {
            selectionExtraInfoDisableMobileToolbarKey: true,
            selectionExtraInfoDisableFloatingToolbar: true,
            selectionExtraInfoDoNotAttachTextService: true,
          },
        );
        keepEditorFocusNotifier.increase();
        showTextColorAndBackgroundColorPicker(
          context,
          editorState: editorState,
          selection: editorState.selection!,
        );
      },
    );
  },
);

final linkToolbarItem = UniversalWorkspaceMobileToolbarItem(
  itemBuilder: (context, editorState, service, __, onAction) {
    return UniversalWorkspaceMobileToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      icon: UniflowSvgs.m_toolbar_link_m,
      onTap: () {
        onMobileLinkButtonTap(editorState);
      },
    );
  },
);
