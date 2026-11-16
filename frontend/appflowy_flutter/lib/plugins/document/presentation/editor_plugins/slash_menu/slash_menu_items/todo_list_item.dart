import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/selectable_svg_widget.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';

import 'slash_menu_item_builder.dart';

final _keywords = [
  'checkbox',
  'todo',
  'list',
  'to-do',
  'task',
];

final todoListSlashMenuItem = SelectionMenuItem(
  getName: () => LocaleKeys.editor_checkbox.tr(),
  keywords: _keywords,
  handler: (editorState, _, __) async => insertCheckboxAfterSelection(
    editorState,
  ),
  nameBuilder: slashMenuItemNameBuilder,
  icon: (editorState, isSelected, style) => SelectableSvgWidget(
    data: UniflowSvgs.slash_menu_icon_checkbox_s,
    isSelected: isSelected,
    style: style,
  ),
);
