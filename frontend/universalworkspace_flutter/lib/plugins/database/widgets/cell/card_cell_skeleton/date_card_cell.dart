import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/database/application/cell/cell_controller.dart';
import 'package:universalworkspace/plugins/database/application/cell/cell_controller_builder.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/date_cell_bloc.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../editable_cell_skeleton/date.dart';
import 'card_cell.dart';

class DateCardCellStyle extends CardCellStyle {
  DateCardCellStyle({
    required super.padding,
    required this.textStyle,
  });

  final TextStyle textStyle;
}

class DateCardCell extends CardCell<DateCardCellStyle> {
  const DateCardCell({
    super.key,
    required super.style,
    required this.databaseController,
    required this.cellContext,
  });

  final DatabaseController databaseController;
  final CellContext cellContext;

  @override
  State<DateCardCell> createState() => _DateCellState();
}

class _DateCellState extends State<DateCardCell> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DateCellBloc(
          cellController: makeCellController(
            widget.databaseController,
            widget.cellContext,
          ).as(),
        );
      },
      child: BlocBuilder<DateCellBloc, DateCellState>(
        builder: (context, state) {
          final dateStr = getDateCellStrFromCellData(
            state.fieldInfo,
            state.cellData,
          );

          if (dateStr.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            alignment: Alignment.centerLeft,
            padding: widget.style.padding,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    dateStr,
                    style: widget.style.textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (state.cellData.reminderId.isNotEmpty) ...[
                  const HSpace(4),
                  const UniflowSvg(UniflowSvgs.clock_alarm_s),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
