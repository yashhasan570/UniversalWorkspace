import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/timestamp_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

import '../editable_cell_skeleton/timestamp.dart';

class MobileRowDetailTimestampCellSkin extends IEditableTimestampCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    ValueNotifier<bool> compactModeNotifier,
    TimestampCellBloc bloc,
    TimestampCellState state,
  ) {
    return Container(
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
      child: UniflowText(
        state.dateStr.isEmpty
            ? LocaleKeys.grid_row_textPlaceholder.tr()
            : state.dateStr,
        fontSize: 16,
        color: state.dateStr.isEmpty ? Theme.of(context).hintColor : null,
        maxLines: null,
      ),
    );
  }
}
