import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/checkbox_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:flutter/material.dart';

import '../editable_cell_skeleton/checkbox.dart';

class MobileRowDetailCheckboxCellSkin extends IEditableCheckboxCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    ValueNotifier<bool> compactModeNotifier,
    CheckboxCellBloc bloc,
    CheckboxCellState state,
  ) {
    return InkWell(
      onTap: () => bloc.add(const CheckboxCellEvent.select()),
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 48,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        alignment: AlignmentDirectional.centerStart,
        child: UniflowSvg(
          state.isSelected ? UniflowSvgs.check_filled_s : UniflowSvgs.uncheck_s,
          color: AFThemeExtension.of(context).onBackground,
          blendMode: BlendMode.dst,
          size: const Size.square(24),
        ),
      ),
    );
  }
}
