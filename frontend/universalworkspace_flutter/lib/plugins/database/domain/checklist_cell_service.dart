import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:protobuf/protobuf.dart';

class ChecklistCellBackendService {
  ChecklistCellBackendService({
    required this.viewId,
    required this.fieldId,
    required this.rowId,
  });

  final String viewId;
  final String fieldId;
  final String rowId;

  Future<UniflowResult<void, UniflowError>> create({
    required String name,
    int? index,
  }) {
    final insert = ChecklistCellInsertPB()..name = name;
    if (index != null) {
      insert.index = index;
    }

    final payload = ChecklistCellDataChangesetPB()
      ..cellId = _makdeCellId()
      ..insertTask.add(insert);

    return DatabaseEventUpdateChecklistCell(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> delete({
    required List<String> optionIds,
  }) {
    final payload = ChecklistCellDataChangesetPB()
      ..cellId = _makdeCellId()
      ..deleteTasks.addAll(optionIds);

    return DatabaseEventUpdateChecklistCell(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> select({
    required String optionId,
  }) {
    final payload = ChecklistCellDataChangesetPB()
      ..cellId = _makdeCellId()
      ..completedTasks.add(optionId);

    return DatabaseEventUpdateChecklistCell(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> updateName({
    required SelectOptionPB option,
    required name,
  }) {
    option.freeze();
    final newOption = option.rebuild((option) {
      option.name = name;
    });
    final payload = ChecklistCellDataChangesetPB()
      ..cellId = _makdeCellId()
      ..updateTasks.add(newOption);

    return DatabaseEventUpdateChecklistCell(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> reorder({
    required fromTaskId,
    required toTaskId,
  }) {
    final payload = ChecklistCellDataChangesetPB()
      ..cellId = _makdeCellId()
      ..reorder = "$fromTaskId $toTaskId";

    return DatabaseEventUpdateChecklistCell(payload).send();
  }

  CellIdPB _makdeCellId() {
    return CellIdPB()
      ..viewId = viewId
      ..fieldId = fieldId
      ..rowId = rowId;
  }
}
