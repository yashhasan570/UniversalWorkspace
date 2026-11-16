import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/selectable_svg_widget.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'slash_menu_item_builder.dart';

final _keywords = [
  'callout',
];

/// Callout menu item
SelectionMenuItem calloutSlashMenuItem = SelectionMenuItem.node(
  getName: LocaleKeys.document_plugins_callout.tr,
  keywords: _keywords,
  nodeBuilder: (editorState, context) =>
      calloutNode(defaultColor: Colors.transparent),
  replace: (_, node) => node.delta?.isEmpty ?? false,
  updateSelection: (_, path, __, ___) {
    return Selection.single(path: path, startOffset: 0);
  },
  nameBuilder: slashMenuItemNameBuilder,
  iconBuilder: (editorState, isSelected, style) => SelectableSvgWidget(
    data: UniflowSvgs.slash_menu_icon_callout_s,
    isSelected: isSelected,
    style: style,
  ),
);
