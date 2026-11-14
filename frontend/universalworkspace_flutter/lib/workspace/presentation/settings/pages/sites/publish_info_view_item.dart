import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/header/emoji_icon_widget.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/uniflow_icon_emoji_picker.dart';
import 'package:universalworkspace/util/string_extension.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class PublishInfoViewItem extends StatelessWidget {
  const PublishInfoViewItem({
    super.key,
    required this.publishInfoView,
    this.onTap,
    this.useIntrinsicWidth = true,
    this.margin,
    this.extraTooltipMessage,
  });

  final PublishInfoViewPB publishInfoView;
  final VoidCallback? onTap;
  final bool useIntrinsicWidth;
  final EdgeInsets? margin;
  final String? extraTooltipMessage;

  @override
  Widget build(BuildContext context) {
    final name = publishInfoView.view.name.orDefault(
      LocaleKeys.menuAppHeader_defaultNewPageName.tr(),
    );
    final tooltipMessage =
        extraTooltipMessage != null ? '$extraTooltipMessage\n$name' : name;
    return Container(
      alignment: Alignment.centerLeft,
      child: UniflowButton(
        margin: margin,
        useIntrinsicWidth: useIntrinsicWidth,
        mainAxisAlignment: MainAxisAlignment.start,
        leftIcon: _buildIcon(),
        text: UniflowTooltip(
          message: tooltipMessage,
          child: UniflowText.regular(
            name,
            fontSize: 14.0,
            figmaLineHeight: 18.0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIcon() {
    final icon = publishInfoView.view.icon.toEmojiIconData();
    return icon.isNotEmpty
        ? RawEmojiIconWidget(
            emoji: icon,
            emojiSize: 16.0,
            lineHeight: 1.1,
          )
        : publishInfoView.view.defaultIcon();
  }
}
