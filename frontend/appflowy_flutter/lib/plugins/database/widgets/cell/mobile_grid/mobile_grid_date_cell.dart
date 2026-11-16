import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/show_mobile_bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/database/date_picker/mobile_date_picker_screen.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/date_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/cell/editable_cell_skeleton/date.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class MobileGridDateCellSkin extends IEditableDateCellSkin {
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
    return UniflowButton(
      radius: BorderRadius.zero,
      hoverColor: Colors.transparent,
      margin: EdgeInsets.zero,
      text: Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (state.cellData.reminderId.isNotEmpty) ...[
                const UniflowSvg(UniflowSvgs.clock_alarm_s),
                const HSpace(6),
              ],
              UniflowText(
                dateStr,
                fontSize: 15,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showMobileBottomSheet(
          context,
          builder: (context) {
            return MobileDateCellEditScreen(
              controller: bloc.cellController,
              showAsFullScreen: false,
            );
          },
        );
      },
    );
  }
}
