import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/header/emoji_icon_widget.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/uniflow_icon_emoji_picker.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/result.pb.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

extension GetIcon on ResultIconPB {
  Widget? getIcon({
    double size = 18.0,
    double lineHeight = 1.0,
    Color? iconColor,
  }) {
    final iconValue = value, iconType = ty;
    if (iconType == ResultIconTypePB.Emoji) {
      if (iconValue.isEmpty) return null;
      if (UniversalPlatform.isMobile) {
        return Text(
          iconValue,
          strutStyle: StrutStyle(
            fontSize: size,
            height: lineHeight,

            /// currently [forceStrutHeight] set to true seems only work in iOS
            forceStrutHeight: UniversalPlatform.isIOS,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        );
      }
      return RawEmojiIconWidget(
        emoji: EmojiIconData.emoji(iconValue),
        emojiSize: size,
        lineHeight: lineHeight,
      );
    } else if (iconType == ResultIconTypePB.Icon ||
        iconType == ResultIconTypePB.Url) {
      if (_resultIconValueTypes.contains(iconValue)) {
        return UniflowSvg(
          getViewSvg(),
          size: Size.square(size),
          color: iconColor,
        );
      }
      return RawEmojiIconWidget(
        emoji: EmojiIconData(iconType.toUniflowIconType(), iconValue),
        emojiSize: size,
        lineHeight: lineHeight,
      );
    }
    return null;
  }
}

extension ResultIconTypePBToUniflowIconType on ResultIconTypePB {
  UniflowIconType toUniflowIconType() {
    switch (this) {
      case ResultIconTypePB.Emoji:
        return UniflowIconType.emoji;
      case ResultIconTypePB.Icon:
        return UniflowIconType.icon;
      case ResultIconTypePB.Url:
        return UniflowIconType.custom;
      default:
        return UniflowIconType.custom;
    }
  }
}

extension _ToViewIcon on ResultIconPB {
  UniflowSvgData getViewSvg() => switch (value) {
        "0" => UniflowSvgs.icon_document_s,
        "1" => UniflowSvgs.icon_grid_s,
        "2" => UniflowSvgs.icon_board_s,
        "3" => UniflowSvgs.icon_calendar_s,
        "4" => UniflowSvgs.chat_ai_page_s,
        _ => UniflowSvgs.icon_document_s,
      };
}

const _resultIconValueTypes = {'0', '1', '2', '3', '4'};
