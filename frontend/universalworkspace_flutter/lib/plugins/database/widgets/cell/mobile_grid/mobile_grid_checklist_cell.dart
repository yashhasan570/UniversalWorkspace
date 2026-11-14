import 'package:universalworkspace/mobile/presentation/bottom_sheet/show_mobile_bottom_sheet.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/checklist_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/plugins/database/widgets/cell_editor/checklist_progress_bar.dart';
import 'package:universalworkspace/plugins/database/widgets/cell_editor/mobile_checklist_cell_editor.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../editable_cell_skeleton/checklist.dart';

class MobileGridChecklistCellSkin extends IEditableChecklistCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    ValueNotifier<bool> compactModeNotifier,
    ChecklistCellBloc bloc,
    PopoverController popoverController,
  ) {
    return BlocBuilder<ChecklistCellBloc, ChecklistCellState>(
      builder: (context, state) {
        return UniflowButton(
          radius: BorderRadius.zero,
          hoverColor: Colors.transparent,
          text: Container(
            alignment: Alignment.centerLeft,
            padding: GridSize.cellContentInsets,
            child: state.tasks.isEmpty
                ? const SizedBox.shrink()
                : ChecklistProgressBar(
                    tasks: state.tasks,
                    percent: state.percent,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 15),
                  ),
          ),
          onTap: () => showMobileBottomSheet(
            context,
            builder: (context) {
              return BlocProvider.value(
                value: bloc,
                child: const MobileChecklistCellEditScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
