import 'package:universalworkspace/workspace/application/command_palette/search_result_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/result.pb.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:flutter/material.dart';

extension MobileSearchIconItemExtension on ResultIconPB {
  Widget? buildIcon(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);

    if (ty == ResultIconTypePB.Emoji) {
      return SizedBox(
        width: 20,
        child: getIcon(size: 20) ?? SizedBox.shrink(),
      );
    } else {
      return getIcon(
            size: 20,
            iconColor: theme.iconColorScheme.secondary,
          ) ??
          SizedBox.shrink();
    }
  }
}
