import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/checkbox_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

import '../editable_cell_skeleton/checkbox.dart';

class DesktopRowDetailCheckboxCellSkin extends IEditableCheckboxCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    ValueNotifier<bool> compactModeNotifier,
    CheckboxCellBloc bloc,
    CheckboxCellState state,
  ) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: UniflowIconButton(
        hoverColor: Colors.transparent,
        onPressed: () => bloc.add(const CheckboxCellEvent.select()),
        icon: UniflowSvg(
          state.isSelected ? UniflowSvgs.check_filled_s : UniflowSvgs.uncheck_s,
          blendMode: BlendMode.dst,
          size: const Size.square(20),
        ),
        width: 20,
      ),
    );
  }
}
