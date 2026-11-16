import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_mart/flutter_emoji_mart.dart';

import 'colors.dart';

// use a temporary global value to store last selected skin tone
EmojiSkinTone? lastSelectedEmojiSkinTone;

@visibleForTesting
ValueKey emojiSkinToneKey(String icon) {
  return ValueKey('emoji_skin_tone_$icon');
}

class UniflowEmojiSkinToneSelector extends StatefulWidget {
  const UniflowEmojiSkinToneSelector({
    super.key,
    required this.onEmojiSkinToneChanged,
  });

  final EmojiSkinToneChanged onEmojiSkinToneChanged;

  @override
  State<UniflowEmojiSkinToneSelector> createState() =>
      _UniflowEmojiSkinToneSelectorState();
}

class _UniflowEmojiSkinToneSelectorState
    extends State<UniflowEmojiSkinToneSelector> {
  EmojiSkinTone skinTone = EmojiSkinTone.none;
  final controller = PopoverController();

  @override
  Widget build(BuildContext context) {
    return UniversalWorkspacePopover(
      direction: PopoverDirection.bottomWithCenterAligned,
      controller: controller,
      popupBuilder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: EmojiSkinTone.values
              .map(
                (e) => _buildIconButton(
                  e.icon,
                  () {
                    setState(() => lastSelectedEmojiSkinTone = e);
                    widget.onEmojiSkinToneChanged(e);
                    controller.close();
                  },
                ),
              )
              .toList(),
        );
      },
      child: UniflowTooltip(
        message: LocaleKeys.emoji_selectSkinTone.tr(),
        child: _buildIconButton(
          lastSelectedEmojiSkinTone?.icon ?? '👋',
          () => controller.show(),
        ),
      ),
    );
  }

  Widget _buildIconButton(String icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: context.pickerButtonBoarderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: UniflowButton(
        key: emojiSkinToneKey(icon),
        margin: EdgeInsets.zero,
        text: UniflowText.emoji(
          icon,
          fontSize: 24.0,
        ),
        onTap: onPressed,
      ),
    );
  }
}

extension EmojiSkinToneIcon on EmojiSkinTone {
  String get icon {
    switch (this) {
      case EmojiSkinTone.none:
        return '👋';
      case EmojiSkinTone.light:
        return '👋🏻';
      case EmojiSkinTone.mediumLight:
        return '👋🏼';
      case EmojiSkinTone.medium:
        return '👋🏽';
      case EmojiSkinTone.mediumDark:
        return '👋🏾';
      case EmojiSkinTone.dark:
        return '👋🏿';
    }
  }
}
