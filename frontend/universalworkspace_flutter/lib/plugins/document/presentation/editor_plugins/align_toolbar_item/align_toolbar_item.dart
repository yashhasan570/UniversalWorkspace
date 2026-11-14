import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

const String leftAlignmentKey = 'left';
const String centerAlignmentKey = 'center';
const String rightAlignmentKey = 'right';
const String kAlignToolbarItemId = 'editor.align';

final alignToolbarItem = ToolbarItem(
  id: kAlignToolbarItemId,
  group: 4,
  isActive: onlyShowInTextType,
  builder: (context, editorState, highlightColor, _, tooltipBuilder) {
    final selection = editorState.selection!;
    final nodes = editorState.getNodesInSelection(selection);

    bool isSatisfyCondition(bool Function(Object? value) test) {
      return nodes.every(
        (n) => test(n.attributes[blockComponentAlign]),
      );
    }

    bool isHighlight = false;
    UniflowSvgData data = UniflowSvgs.toolbar_align_left_s;
    if (isSatisfyCondition((value) => value == leftAlignmentKey)) {
      isHighlight = true;
      data = UniflowSvgs.toolbar_align_left_s;
    } else if (isSatisfyCondition((value) => value == centerAlignmentKey)) {
      isHighlight = true;
      data = UniflowSvgs.toolbar_align_center_s;
    } else if (isSatisfyCondition((value) => value == rightAlignmentKey)) {
      isHighlight = true;
      data = UniflowSvgs.toolbar_align_right_s;
    }

    Widget child = UniflowSvg(
      data,
      size: const Size.square(16),
      color: isHighlight ? highlightColor : Colors.white,
    );

    child = _AlignmentButtons(
      child: child,
      onAlignChanged: (align) async {
        await editorState.updateNode(
          selection,
          (node) => node.copyWith(
            attributes: {
              ...node.attributes,
              blockComponentAlign: align,
            },
          ),
        );
      },
    );

    if (tooltipBuilder != null) {
      child = tooltipBuilder(
        context,
        kAlignToolbarItemId,
        LocaleKeys.document_plugins_optionAction_align.tr(),
        child,
      );
    }

    return child;
  },
);

class _AlignmentButtons extends StatefulWidget {
  const _AlignmentButtons({
    required this.child,
    required this.onAlignChanged,
  });

  final Widget child;
  final Function(String align) onAlignChanged;

  @override
  State<_AlignmentButtons> createState() => _AlignmentButtonsState();
}

class _AlignmentButtonsState extends State<_AlignmentButtons> {
  final controller = PopoverController();

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
        return _AlignButtons(onAlignChanged: widget.onAlignChanged);
      },
      onClose: () {
        keepEditorFocusNotifier.decrease();
      },
      child: UniflowButton(
        useIntrinsicWidth: true,
        text: widget.child,
        hoverColor: Colors.grey.withValues(alpha: 0.3),
        onTap: () => controller.show(),
      ),
    );
  }
}

class _AlignButtons extends StatelessWidget {
  const _AlignButtons({
    required this.onAlignChanged,
  });

  final Function(String align) onAlignChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HSpace(4),
          _AlignButton(
            icon: UniflowSvgs.toolbar_align_left_s,
            tooltips: LocaleKeys.document_plugins_optionAction_left.tr(),
            onTap: () => onAlignChanged(leftAlignmentKey),
          ),
          const _Divider(),
          _AlignButton(
            icon: UniflowSvgs.toolbar_align_center_s,
            tooltips: LocaleKeys.document_plugins_optionAction_center.tr(),
            onTap: () => onAlignChanged(centerAlignmentKey),
          ),
          const _Divider(),
          _AlignButton(
            icon: UniflowSvgs.toolbar_align_right_s,
            tooltips: LocaleKeys.document_plugins_optionAction_right.tr(),
            onTap: () => onAlignChanged(rightAlignmentKey),
          ),
          const HSpace(4),
        ],
      ),
    );
  }
}

class _AlignButton extends StatelessWidget {
  const _AlignButton({
    required this.icon,
    required this.tooltips,
    required this.onTap,
  });

  final UniflowSvgData icon;
  final String tooltips;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      useIntrinsicWidth: true,
      hoverColor: Colors.grey.withValues(alpha: 0.3),
      onTap: onTap,
      text: UniflowTooltip(
        message: tooltips,
        child: UniflowSvg(
          icon,
          size: const Size.square(16),
          color: Colors.white,
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
