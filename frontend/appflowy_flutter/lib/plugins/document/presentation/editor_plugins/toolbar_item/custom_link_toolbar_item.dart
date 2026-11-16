import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/application/document_bloc.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/toolbar_extension.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/desktop_toolbar/desktop_floating_toolbar.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/desktop_toolbar/link/link_create_menu.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/desktop_toolbar/link/link_hover_menu.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_style.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/util/theme_extension.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:uniflow_infra_ui/style_widget/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'toolbar_id_enum.dart';

const kIsPageLink = 'is_page_link';

final customLinkItem = ToolbarItem(
  id: ToolbarId.link.id,
  group: 4,
  isActive: (state) =>
      !isNarrowWindow(state) && onlyShowInSingleSelectionAndTextType(state),
  builder: (context, editorState, highlightColor, iconColor, tooltipBuilder) {
    final selection = editorState.selection!;
    final nodes = editorState.getNodesInSelection(selection);
    final isHref = nodes.allSatisfyInSelection(selection, (delta) {
      return delta.everyAttributes(
        (attributes) => attributes[UniversalWorkspaceRichTextKeys.href] != null,
      );
    });

    final isDark = !Theme.of(context).isLightMode;
    final hoverColor = isHref
        ? highlightColor
        : EditorStyleCustomizer.toolbarHoverColor(context);
    final theme = UniversalWorkspaceTheme.of(context);
    final child = UniflowIconButton(
      width: 36,
      height: 32,
      hoverColor: hoverColor,
      isSelected: isHref,
      icon: UniflowSvg(
        UniflowSvgs.toolbar_link_m,
        size: Size.square(20.0),
        color: (isDark && isHref)
            ? Color(0xFF282E3A)
            : theme.iconColorScheme.primary,
      ),
      onPressed: () {
        getIt<FloatingToolbarController>().hideToolbar();
        if (!isHref) {
          final viewId = context.read<DocumentBloc?>()?.documentId ?? '';
          showLinkCreateMenu(context, editorState, selection, viewId);
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            getIt<LinkHoverTriggers>()
                .call(HoverTriggerKey(nodes.first.id, selection));
          });
        }
      },
    );

    if (tooltipBuilder != null) {
      return tooltipBuilder(
        context,
        ToolbarId.highlightColor.id,
        AppFlowyEditorL10n.current.link,
        child,
      );
    }

    return child;
  },
);

extension AttributeExtension on Attributes {
  bool get isPage {
    if (this[kIsPageLink] is bool) {
      return this[kIsPageLink];
    }
    return false;
  }
}

enum LinkMenuAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

extension LinkMenuAlignmentExtension on LinkMenuAlignment {
  bool get isTop =>
      this == LinkMenuAlignment.topLeft || this == LinkMenuAlignment.topRight;
}
