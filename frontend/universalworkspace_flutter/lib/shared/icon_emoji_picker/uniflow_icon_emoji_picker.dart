import 'dart:math';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/base/emoji/emoji_picker.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/icon_picker.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/tab.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/icon.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart' hide Icon;
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

import 'icon_uploader.dart';

extension ToProto on UniflowIconType {
  ViewIconTypePB toProto() {
    switch (this) {
      case UniflowIconType.emoji:
        return ViewIconTypePB.Emoji;
      case UniflowIconType.icon:
        return ViewIconTypePB.Icon;
      case UniflowIconType.custom:
        return ViewIconTypePB.Url;
    }
  }
}

extension FromProto on ViewIconTypePB {
  UniflowIconType fromProto() {
    switch (this) {
      case ViewIconTypePB.Emoji:
        return UniflowIconType.emoji;
      case ViewIconTypePB.Icon:
        return UniflowIconType.icon;
      case ViewIconTypePB.Url:
        return UniflowIconType.custom;
      default:
        return UniflowIconType.custom;
    }
  }
}

extension ToEmojiIconData on ViewIconPB {
  EmojiIconData toEmojiIconData() => EmojiIconData(ty.fromProto(), value);
}

enum UniflowIconType {
  emoji,
  icon,
  custom;
}

extension UniflowIconTypeToPickerTabType on UniflowIconType {
  PickerTabType? toPickerTabType() => name.toPickerTabType();
}

class EmojiIconData {
  factory EmojiIconData.none() => const EmojiIconData(UniflowIconType.icon, '');

  factory EmojiIconData.emoji(String emoji) =>
      EmojiIconData(UniflowIconType.emoji, emoji);

  factory EmojiIconData.icon(IconsData icon) =>
      EmojiIconData(UniflowIconType.icon, icon.iconString);

  factory EmojiIconData.custom(String url) =>
      EmojiIconData(UniflowIconType.custom, url);

  const EmojiIconData(
    this.type,
    this.emoji,
  );

  final UniflowIconType type;
  final String emoji;

  static EmojiIconData fromViewIconPB(ViewIconPB v) {
    return EmojiIconData(v.ty.fromProto(), v.value);
  }

  ViewIconPB toViewIcon() {
    return ViewIconPB()
      ..ty = type.toProto()
      ..value = emoji;
  }

  bool get isEmpty => emoji.isEmpty;

  bool get isNotEmpty => emoji.isNotEmpty;
}

class SelectedEmojiIconResult {
  SelectedEmojiIconResult(this.data, this.keepOpen);

  final EmojiIconData data;
  final bool keepOpen;

  UniflowIconType get type => data.type;

  String get emoji => data.emoji;
}

extension EmojiIconDataToSelectedResultExtension on EmojiIconData {
  SelectedEmojiIconResult toSelectedResult({bool keepOpen = false}) =>
      SelectedEmojiIconResult(this, keepOpen);
}

class UniflowIconEmojiPicker extends StatefulWidget {
  const UniflowIconEmojiPicker({
    super.key,
    this.onSelectedEmoji,
    this.initialType,
    this.documentId,
    this.enableBackgroundColorSelection = true,
    this.tabs = const [
      PickerTabType.emoji,
      PickerTabType.icon,
    ],
  });

  final ValueChanged<SelectedEmojiIconResult>? onSelectedEmoji;
  final bool enableBackgroundColorSelection;
  final List<PickerTabType> tabs;
  final PickerTabType? initialType;
  final String? documentId;

  @override
  State<UniflowIconEmojiPicker> createState() => _UniflowIconEmojiPickerState();
}

class _UniflowIconEmojiPickerState extends State<UniflowIconEmojiPicker>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final initialType = widget.initialType;
    if (initialType != null) {
      currentIndex = max(widget.tabs.indexOf(initialType), 0);
    }
    controller = TabController(
      initialIndex: currentIndex,
      length: widget.tabs.length,
      vsync: this,
    );
    controller.addListener(() {
      final currentType = widget.tabs[currentIndex];
      if (currentType == PickerTabType.custom) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 46,
          padding: const EdgeInsets.only(left: 4.0, right: 12.0),
          child: Row(
            children: [
              Expanded(
                child: PickerTab(
                  controller: controller,
                  tabs: widget.tabs,
                  onTap: (index) => currentIndex = index,
                ),
              ),
              _RemoveIconButton(
                onTap: () {
                  widget.onSelectedEmoji
                      ?.call(EmojiIconData.none().toSelectedResult());
                },
              ),
            ],
          ),
        ),
        const UniflowDivider(),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: widget.tabs.map((tab) {
              switch (tab) {
                case PickerTabType.emoji:
                  return _buildEmojiPicker();
                case PickerTabType.icon:
                  return _buildIconPicker();
                case PickerTabType.custom:
                  return _buildIconUploader();
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiPicker() {
    return UniflowEmojiPicker(
      ensureFocus: true,
      emojiPerLine: _getEmojiPerLine(context),
      onEmojiSelected: (r) {
        widget.onSelectedEmoji?.call(
          EmojiIconData.emoji(r.emoji).toSelectedResult(keepOpen: r.isRandom),
        );
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
  }

  int _getEmojiPerLine(BuildContext context) {
    if (UniversalPlatform.isDesktopOrWeb) {
      return 9;
    }
    final width = MediaQuery.of(context).size.width;
    return width ~/ 40.0; // the size of the emoji
  }

  Widget _buildIconPicker() {
    return UniflowIconPicker(
      ensureFocus: true,
      enableBackgroundColorSelection: widget.enableBackgroundColorSelection,
      onSelectedIcon: (r) {
        widget.onSelectedEmoji?.call(
          r.data.toEmojiIconData().toSelectedResult(keepOpen: r.isRandom),
        );
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
  }

  Widget _buildIconUploader() {
    return IconUploader(
      documentId: widget.documentId ?? '',
      ensureFocus: true,
      onUrl: (url) {
        widget.onSelectedEmoji
            ?.call(SelectedEmojiIconResult(EmojiIconData.custom(url), false));
      },
    );
  }
}

class _RemoveIconButton extends StatelessWidget {
  const _RemoveIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: UniflowButton(
        onTap: onTap,
        useIntrinsicWidth: true,
        text: UniflowText(
          fontSize: 14.0,
          figmaLineHeight: 16.0,
          fontWeight: FontWeight.w500,
          LocaleKeys.button_remove.tr(),
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}
