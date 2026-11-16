import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/date_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/plugins/database/widgets/cell_editor/date_cell_editor.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/widgets.dart';

import '../editable_cell_skeleton/date.dart';

class DesktopGridDateCellSkin extends IEditableDateCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    ValueNotifier<bool> compactModeNotifier,
    DateCellBloc bloc,
    DateCellState state,
    PopoverController popoverController,
  ) {
    return UniversalWorkspacePopover(
      controller: popoverController,
      triggerActions: PopoverTriggerFlags.none,
      direction: PopoverDirection.bottomWithLeftAligned,
      constraints: BoxConstraints.loose(const Size(260, 620)),
      margin: EdgeInsets.zero,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: state.fieldInfo.wrapCellContent ?? false
            ? _buildCellContent(state, compactModeNotifier)
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: _buildCellContent(state, compactModeNotifier),
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

  Widget _buildCellContent(
    DateCellState state,
    ValueNotifier<bool> compactModeNotifier,
  ) {
    final wrap = state.fieldInfo.wrapCellContent ?? false;
    final dateStr = getDateCellStrFromCellData(
      state.fieldInfo,
      state.cellData,
    );
    return ValueListenableBuilder(
      valueListenable: compactModeNotifier,
      builder: (context, compactMode, _) {
        final padding = compactMode
            ? GridSize.compactCellContentInsets
            : GridSize.cellContentInsets;
        return Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: UniflowText(
                  dateStr,
                  overflow: wrap ? null : TextOverflow.ellipsis,
                  maxLines: wrap ? null : 1,
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
        );
      },
    );
  }
}
