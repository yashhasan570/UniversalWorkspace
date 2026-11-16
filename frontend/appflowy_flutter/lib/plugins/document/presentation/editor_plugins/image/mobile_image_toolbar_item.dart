import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/image/image_placeholder.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

final imageMobileToolbarItem = MobileToolbarItem.action(
  itemIconBuilder: (_, __, ___) => const UniflowSvg(UniflowSvgs.m_toolbar_imae_lg),
  actionHandler: (_, editorState) async {
    final imagePlaceholderKey = GlobalKey<ImagePlaceholderState>();
    await editorState.insertEmptyImageBlock(imagePlaceholderKey);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      imagePlaceholderKey.currentState?.showUploadImageMenu();
    });
  },
);
