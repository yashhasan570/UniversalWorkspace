import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/header/emoji_icon_widget.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/uniflow_icon_emoji_picker.dart';
import 'package:universalworkspace/workspace/application/command_palette/search_result_ext.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/result.pb.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:flutter/material.dart';

extension SearchIconExtension on ViewPB {
  Widget buildIcon(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return icon.value.isNotEmpty
        ? SizedBox(
            width: 16,
            child: RawEmojiIconWidget(
              emoji: icon.toEmojiIconData(),
              emojiSize: 16,
              lineHeight: 20 / 16,
            ),
          )
        : UniflowSvg(
            iconData,
            size: const Size.square(18),
            color: theme.iconColorScheme.secondary,
          );
  }
}

extension SearchIconItemExtension on ResultIconPB {
  Widget? buildIcon(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    final color = theme.iconColorScheme.secondary;

    if (ty == ResultIconTypePB.Emoji) {
      return SizedBox(
        width: 16,
        child: getIcon(size: 16, lineHeight: 20 / 16, iconColor: color) ??
            SizedBox.shrink(),
      );
    } else {
      return getIcon(iconColor: color) ?? SizedBox.shrink();
    }
  }
}
