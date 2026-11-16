import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

final _headingData = [
  (UniflowSvgs.h1_s, LocaleKeys.editor_heading1.tr()),
  (UniflowSvgs.h2_s, LocaleKeys.editor_heading2.tr()),
  (UniflowSvgs.h3_s, LocaleKeys.editor_heading3.tr()),
];

final headingsToolbarItem = ToolbarItem(
  id: 'editor.headings',
  group: 1,
  isActive: onlyShowInTextType,
  builder: (context, editorState, highlightColor, _, __) {
    final selection = editorState.selection!;
    final node = editorState.getNodeAtPath(selection.start.path)!;
    final delta = (node.delta ?? Delta()).toJson();
    int level = node.attributes[HeadingBlockKeys.level] ?? 1;
    final originLevel = level;
    final isHighlight =
        node.type == HeadingBlockKeys.type && (level >= 1 && level <= 3);
    // only supports the level 1 - 3 in the toolbar, ignore the other levels
    level = level.clamp(1, 3);

    final svg = _headingData[level - 1].$1;
    final message = _headingData[level - 1].$2;

    final child = UniflowTooltip(
      message: message,
      preferBelow: false,
      child: Row(
        children: [
          UniflowSvg(
            svg,
            size: const Size.square(18),
            color: isHighlight ? highlightColor : Colors.white,
          ),
          const HSpace(2.0),
          const UniflowSvg(
            UniflowSvgs.arrow_down_s,
            size: Size.square(12),
            color: Colors.grey,
          ),
        ],
      ),
    );
    return HeadingPopup(
      currentLevel: isHighlight ? level : -1,
      highlightColor: highlightColor,
      child: child,
      onLevelChanged: (newLevel) async {
        // same level means cancel the heading
        final type =
            newLevel == originLevel && node.type == HeadingBlockKeys.type
                ? ParagraphBlockKeys.type
                : HeadingBlockKeys.type;

        if (type == HeadingBlockKeys.type) {
          // from paragraph to heading
          final newNode = node.copyWith(
            type: type,
            attributes: {
              HeadingBlockKeys.level: newLevel,
              blockComponentBackgroundColor:
                  node.attributes[blockComponentBackgroundColor],
              blockComponentTextDirection:
                  node.attributes[blockComponentTextDirection],
              blockComponentDelta: delta,
            },
          );
          final children = node.children.map((child) => child.deepCopy());

          final transaction = editorState.transaction;
          transaction.insertNodes(
            selection.start.path.next,
            [newNode, ...children],
          );
          transaction.deleteNode(node);
          await editorState.apply(transaction);
        } else {
          // from heading to paragraph
          await editorState.formatNode(
            selection,
            (node) => node.copyWith(
              type: type,
              attributes: {
                HeadingBlockKeys.level: newLevel,
                blockComponentBackgroundColor:
                    node.attributes[blockComponentBackgroundColor],
                blockComponentTextDirection:
                    node.attributes[blockComponentTextDirection],
                blockComponentDelta: delta,
              },
            ),
          );
        }
      },
    );
  },
);

class HeadingPopup extends StatelessWidget {
  const HeadingPopup({
    super.key,
    required this.currentLevel,
    required this.highlightColor,
    required this.onLevelChanged,
    required this.child,
  });

  final int currentLevel;
  final Color highlightColor;
  final Function(int level) onLevelChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UniversalWorkspacePopover(
      windowPadding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      direction: PopoverDirection.bottomWithCenterAligned,
      offset: const Offset(0, 10),
      decorationColor: Theme.of(context).colorScheme.onTertiary,
      borderRadius: BorderRadius.circular(6.0),
      popupBuilder: (_) {
        keepEditorFocusNotifier.increase();
        return _HeadingButtons(
          currentLevel: currentLevel,
          highlightColor: highlightColor,
          onLevelChanged: onLevelChanged,
        );
      },
      onClose: () {
        keepEditorFocusNotifier.decrease();
      },
      child: UniflowButton(
        useIntrinsicWidth: true,
        hoverColor: Colors.grey.withValues(alpha: 0.3),
        text: child,
      ),
    );
  }
}

class _HeadingButtons extends StatelessWidget {
  const _HeadingButtons({
    required this.highlightColor,
    required this.currentLevel,
    required this.onLevelChanged,
  });

  final int currentLevel;
  final Color highlightColor;
  final Function(int level) onLevelChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HSpace(4),
          ..._headingData.mapIndexed((index, data) {
            final svg = data.$1;
            final message = data.$2;
            return [
              HeadingButton(
                icon: svg,
                tooltip: message,
                onTap: () => onLevelChanged(index + 1),
                isHighlight: index + 1 == currentLevel,
                highlightColor: highlightColor,
              ),
              index != _headingData.length - 1
                  ? const _Divider()
                  : const SizedBox.shrink(),
            ];
          }).flattened,
          const HSpace(4),
        ],
      ),
    );
  }
}

class HeadingButton extends StatelessWidget {
  const HeadingButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.highlightColor,
    required this.isHighlight,
  });

  final Color highlightColor;
  final UniflowSvgData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      useIntrinsicWidth: true,
      hoverColor: Colors.grey.withValues(alpha: 0.3),
      onTap: onTap,
      text: UniflowTooltip(
        message: tooltip,
        preferBelow: true,
        child: UniflowSvg(
          icon,
          size: const Size.square(18),
          color: isHighlight ? highlightColor : Colors.white,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 1,
        color: Colors.grey,
      ),
    );
  }
}
