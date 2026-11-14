import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/date_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/cell/editable_cell_skeleton/date.dart';
import 'package:universalworkspace/plugins/database/widgets/cell_editor/date_cell_editor.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class DesktopRowDetailDateCellSkin extends IEditableDateCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    ValueNotifier<bool> compactModeNotifier,
    DateCellBloc bloc,
    DateCellState state,
    PopoverController popoverController,
  ) {
    final dateStr = getDateCellStrFromCellData(
      state.fieldInfo,
      state.cellData,
    );
    final text =
        dateStr.isEmpty ? LocaleKeys.grid_row_textPlaceholder.tr() : dateStr;
    final color = dateStr.isEmpty ? Theme.of(context).hintColor : null;

    return UniversalWorkspacePopover(
      controller: popoverController,
      triggerActions: PopoverTriggerFlags.none,
      direction: PopoverDirection.bottomWithLeftAligned,
      constraints: BoxConstraints.loose(const Size(260, 620)),
      margin: EdgeInsets.zero,
      asBarrier: true,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: UniflowText(
                text,
                color: color,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.cellData.reminderId.isNotEmpty) ...[
              const HSpace(4),
              UniflowTooltip(
                message: LocaleKeys.grid_field_reminderOnDateTooltip.tr(),
                child: const UniflowSvg(UniflowSvgs.clock_alarm_s),
              ),
            ],
          ],
        ),
      ),
      popupBuilder: (BuildContext popoverContent) {
        return DateCellEditor(
          cellController: bloc.cellController,
          onDismissed: () => cellContainerNotifier.isFocus = false,
        );
      },
      onClose: () {
        cellContainerNotifier.isFocus = false;
      },
    );
  }
}
