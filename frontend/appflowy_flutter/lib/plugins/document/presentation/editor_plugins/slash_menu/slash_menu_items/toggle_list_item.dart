import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/selectable_svg_widget.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';

import 'slash_menu_item_builder.dart';

final _keywords = [
  'collapsed list',
  'toggle list',
  'list',
  'dropdown',
];

// toggle menu item
SelectionMenuItem toggleListSlashMenuItem = SelectionMenuItem.node(
  getName: () => LocaleKeys.document_slashMenu_name_toggleList.tr(),
  keywords: _keywords,
  nodeBuilder: (editorState, _) => toggleListBlockNode(),
  replace: (_, node) => node.delta?.isEmpty ?? false,
  nameBuilder: slashMenuItemNameBuilder,
  iconBuilder: (editorState, isSelected, style) => SelectableSvgWidget(
    data: UniflowSvgs.slash_menu_icon_toggle_s,
    isSelected: isSelected,
    style: style,
  ),
);
