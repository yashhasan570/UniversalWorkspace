import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/database/application/field/field_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/application/field/field_controller.dart';
import 'package:universalworkspace/plugins/database/application/field/field_info.dart';
import 'package:universalworkspace/plugins/database/widgets/field/field_editor.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/icon_picker.dart';
import 'package:universalworkspace/util/field_type_extension.dart';
import 'package:universalworkspace/util/theme_extension.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/field_entities.pb.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_infra_ui/style_widget/hover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/sizes.dart';

class GridFieldCell extends StatefulWidget {
  const GridFieldCell({
    super.key,
    required this.viewId,
    required this.fieldController,
    required this.fieldInfo,
    required this.onTap,
    required this.onEditorOpened,
    required this.onFieldInsertedOnEitherSide,
    required this.isEditing,
    required this.isNew,
  });

  final String viewId;
  final FieldController fieldController;
  final FieldInfo fieldInfo;
  final VoidCallback onTap;
  final VoidCallback onEditorOpened;
  final void Function(String fieldId) onFieldInsertedOnEitherSide;
  final bool isEditing;
  final bool isNew;

  @override
  State<GridFieldCell> createState() => _GridFieldCellState();
}

class _GridFieldCellState extends State<GridFieldCell> {
  final PopoverController popoverController = PopoverController();
  late final FieldCellBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FieldCellBloc(viewId: widget.viewId, fieldInfo: widget.fieldInfo);
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        popoverController.show();
      });
    }
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    if (widget.fieldInfo != oldWidget.fieldInfo && !_bloc.isClosed) {
      _bloc.add(FieldCellEvent.onFieldChanged(widget.fieldInfo));
    }
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        popoverController.show();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<FieldCellBloc, FieldCellState>(
        builder: (context, state) {
          final button = UniversalWorkspacePopover(
            triggerActions: PopoverTriggerFlags.none,
            constraints: const BoxConstraints(),
            margin: EdgeInsets.zero,
            direction: PopoverDirection.bottomWithLeftAligned,
            controller: popoverController,
            popupBuilder: (BuildContext context) {
              widget.onEditorOpened();
              return FieldEditor(
                viewId: widget.viewId,
                fieldController: widget.fieldController,
                fieldInfo: widget.fieldInfo,
                isNewField: widget.isNew,
                initialPage: widget.isNew
                    ? FieldEditorPage.details
                    : FieldEditorPage.general,
                onFieldInserted: widget.onFieldInsertedOnEitherSide,
              );
            },
            child: UniflowTooltip(
              message: widget.fieldInfo.name,
              preferBelow: false,
              child: SizedBox(
                height: GridSize.headerHeight,
                child: FieldCellButton(
                  field: widget.fieldInfo.field,
                  onTap: widget.onTap,
                  margin: const EdgeInsetsDirectional.fromSTEB(12, 9, 10, 9),
                ),
              ),
            ),
          );

          const line = Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: DragToExpandLine(),
          );

          return _GridHeaderCellContainer(
            width: state.width,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [button, line],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

class _GridHeaderCellContainer extends StatelessWidget {
  const _GridHeaderCellContainer({
    required this.child,
    required this.width,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    final borderSide =
        BorderSide(color: AFThemeExtension.of(context).borderColor);
    final decoration = BoxDecoration(
      border: Border(
        right: borderSide,
        bottom: borderSide,
      ),
    );

    return Container(
      width: width,
      decoration: decoration,
      child: child,
    );
  }
}

@visibleForTesting
class DragToExpandLine extends StatelessWidget {
  const DragToExpandLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) {
          context
              .read<FieldCellBloc>()
              .add(const FieldCellEvent.onResizeStart());
        },
        onHorizontalDragUpdate: (value) {
          context
              .read<FieldCellBloc>()
              .add(FieldCellEvent.startUpdateWidth(value.localPosition.dx));
        },
        onHorizontalDragEnd: (end) {
          context
              .read<FieldCellBloc>()
              .add(const FieldCellEvent.endUpdateWidth());
        },
        child: UniflowHover(
          cursor: SystemMouseCursors.resizeLeftRight,
          style: HoverStyle(
            hoverColor: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.zero,
            contentMargin: const EdgeInsets.only(left: 6),
          ),
          child: const SizedBox(width: 4),
        ),
      ),
    );
  }
}

class FieldCellButton extends StatelessWidget {
  const FieldCellButton({
    super.key,
    required this.field,
    required this.onTap,
    this.maxLines = 1,
    this.radius = BorderRadius.zero,
    this.margin,
  });

  final FieldPB field;
  final VoidCallback onTap;
  final int? maxLines;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      hoverColor: AFThemeExtension.of(context).lightGreyHover,
      onTap: onTap,
      leftIcon: FieldIcon(
        fieldInfo: FieldInfo.initial(field),
      ),
      rightIcon: field.fieldType.rightIcon != null
          ? UniflowSvg(
              field.fieldType.rightIcon!,
              blendMode: null,
              size: const Size.square(18),
            )
          : null,
      radius: radius,
      text: UniflowText(
        field.name,
        lineHeight: 1.0,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        color: AFThemeExtension.of(context).textColor,
      ),
      margin: margin ?? GridSize.cellContentInsets,
    );
  }
}

class FieldIcon extends StatelessWidget {
  const FieldIcon({
    super.key,
    required this.fieldInfo,
    this.dimension = 16.0,
  });

  final FieldInfo fieldInfo;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    final svgContent = kIconGroups?.findSvgContent(
      fieldInfo.icon,
    );
    final color =
        Theme.of(context).isLightMode ? const Color(0xFF171717) : Colors.white;
    return svgContent == null
        ? UniflowSvg(
            fieldInfo.fieldType.svgData,
            color: color.withValues(alpha: 0.6),
            size: Size.square(dimension),
          )
        : SizedBox.square(
            dimension: dimension,
            child: Center(
              child: UniflowSvg.string(
                svgContent,
                color: color.withValues(alpha: 0.45),
                size: Size.square(dimension - 2),
              ),
            ),
          );
  }
}
