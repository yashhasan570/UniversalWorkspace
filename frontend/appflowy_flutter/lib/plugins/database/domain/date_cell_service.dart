import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/cell_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/date_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart';

final class DateCellBackendService {
  DateCellBackendService({
    required String viewId,
    required String fieldId,
    required String rowId,
  }) : cellId = CellIdPB()
          ..viewId = viewId
          ..fieldId = fieldId
          ..rowId = rowId;

  final CellIdPB cellId;

  Future<UniflowResult<void, UniflowError>> update({
    bool? includeTime,
    bool? isRange,
    DateTime? date,
    DateTime? endDate,
    String? reminderId,
  }) {
    final payload = DateCellChangesetPB()..cellId = cellId;

    if (includeTime != null) {
      payload.includeTime = includeTime;
    }
    if (isRange != null) {
      payload.isRange = isRange;
    }
    if (date != null) {
      final dateTimestamp = date.millisecondsSinceEpoch ~/ 1000;
      payload.timestamp = Int64(dateTimestamp);
    }
    if (endDate != null) {
      final dateTimestamp = endDate.millisecondsSinceEpoch ~/ 1000;
      payload.endTimestamp = Int64(dateTimestamp);
    }
    if (reminderId != null) {
      payload.reminderId = reminderId;
    }

    return DatabaseEventUpdateDateCell(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> clear() {
    final payload = DateCellChangesetPB()
      ..cellId = cellId
      ..clearFlag = true;

    return DatabaseEventUpdateDateCell(payload).send();
  }
}
