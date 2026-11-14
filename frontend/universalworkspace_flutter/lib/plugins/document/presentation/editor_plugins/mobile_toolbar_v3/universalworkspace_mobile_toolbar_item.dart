import 'dart:async';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/mobile/presentation/base/animated_gesture.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/aa_menu/_toolbar_theme.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mobile_toolbar_v3/universalworkspace_mobile_toolbar.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

// build the toolbar item, like Aa, +, image ...
typedef UniversalWorkspaceMobileToolbarItemBuilder = Widget Function(
  BuildContext context,
  EditorState editorState,
  UniversalWorkspaceMobileToolbarWidgetService service,
  VoidCallback? onMenuCallback,
  VoidCallback? onActionCallback,
);

// build the menu after clicking the toolbar item
typedef UniversalWorkspaceMobileToolbarItemMenuBuilder = Widget Function(
  BuildContext context,
  EditorState editorState,
  UniversalWorkspaceMobileToolbarWidgetService service,
);

class UniversalWorkspaceMobileToolbarItem {
  /// Tool bar item that implements attribute directly(without opening menu)
  const UniversalWorkspaceMobileToolbarItem({
    required this.itemBuilder,
    this.menuBuilder,
    this.pilotAtCollapsedSelection = false,
    this.pilotAtExpandedSelection = false,
  });

  final UniversalWorkspaceMobileToolbarItemBuilder itemBuilder;
  final UniversalWorkspaceMobileToolbarItemMenuBuilder? menuBuilder;
  final bool pilotAtCollapsedSelection;
  final bool pilotAtExpandedSelection;
}

class UniversalWorkspaceMobileToolbarIconItem extends StatefulWidget {
  const UniversalWorkspaceMobileToolbarIconItem({
    super.key,
    this.icon,
    this.keepSelectedStatus = false,
    this.iconBuilder,
    this.isSelected,
    this.shouldListenToToggledStyle = false,
    this.enable,
    required this.onTap,
    required this.editorState,
  });

  final UniflowSvgData? icon;
  final bool keepSelectedStatus;
  final VoidCallback onTap;
  final WidgetBuilder? iconBuilder;
  final bool Function()? isSelected;
  final bool shouldListenToToggledStyle;
  final EditorState editorState;
  final bool Function()? enable;

  @override
  State<UniversalWorkspaceMobileToolbarIconItem> createState() =>
      _UniversalWorkspaceMobileToolbarIconItemState();
}

class _UniversalWorkspaceMobileToolbarIconItemState
    extends State<UniversalWorkspaceMobileToolbarIconItem> {
  bool isSelected = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    isSelected = widget.isSelected?.call() ?? false;
    if (widget.shouldListenToToggledStyle) {
      widget.editorState.toggledStyleNotifier.addListener(_rebuild);
      _subscription = widget.editorState.transactionStream.listen((_) {
        _rebuild();
      });
    }
  }

  @override
  void dispose() {
    if (widget.shouldListenToToggledStyle) {
      widget.editorState.toggledStyleNotifier.removeListener(_rebuild);
      _subscription?.cancel();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UniversalWorkspaceMobileToolbarIconItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != null) {
      isSelected = widget.isSelected!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ToolbarColorExtension.of(context);
    final enable = widget.enable?.call() ?? true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: AnimatedGestureDetector(
        scaleFactor: 0.95,
        onTapUp: () {
          widget.onTap();
          _rebuild();
        },
        child: widget.iconBuilder?.call(context) ??
            Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: isSelected
                    ? theme.toolbarItemSelectedBackgroundColor
                    : null,
              ),
              child: UniflowSvg(
                widget.icon!,
                color: enable
                    ? theme.toolbarItemIconColor
                    : theme.toolbarItemIconDisabledColor,
              ),
            ),
      ),
    );
  }

  void _rebuild() {
    if (!mounted) {
      return;
    }
    setState(() {
      isSelected = (widget.keepSelectedStatus && widget.isSelected == null)
          ? !isSelected
          : widget.isSelected?.call() ?? false;
    });
  }
}
