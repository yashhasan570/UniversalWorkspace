import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/page_style/_page_style_cover_image.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/page_style/_page_style_icon.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/page_style/_page_style_layout.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/page_style/_page_style_util.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/tab.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class PageStyleBottomSheet extends StatelessWidget {
  const PageStyleBottomSheet({
    super.key,
    required this.view,
    required this.tabs,
  });

  final ViewPB view;
  final List<PickerTabType> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // cover image
          UniflowText(
            LocaleKeys.pageStyle_coverImage.tr(),
            color: context.pageStyleTextColor,
            fontSize: 14.0,
          ),
          const VSpace(8.0),
          PageStyleCoverImage(documentId: view.id),
          const VSpace(20.0),
          // layout: font size, line height and font family.
          UniflowText(
            LocaleKeys.pageStyle_layout.tr(),
            color: context.pageStyleTextColor,
            fontSize: 14.0,
          ),
          const VSpace(8.0),
          const PageStyleLayout(),
          const VSpace(20.0),
          // icon
          UniflowText(
            LocaleKeys.pageStyle_pageIcon.tr(),
            color: context.pageStyleTextColor,
            fontSize: 14.0,
          ),
          const VSpace(8.0),
          PageStyleIcon(
            view: view,
            tabs: tabs,
          ),
        ],
      ),
    );
  }
}
