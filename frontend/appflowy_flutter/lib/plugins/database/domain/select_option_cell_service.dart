import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:nanoid/nanoid.dart';

class SelectOptionCellBackendService {
  SelectOptionCellBackendService({
    required this.viewId,
    required this.fieldId,
    required this.rowId,
  });

  final String viewId;
  final String fieldId;
  final String rowId;

  Future<UniflowResult<void, UniflowError>> create({
    required String name,
    SelectOptionColorPB? color,
    bool isSelected = true,
  }) {
    final option = SelectOptionPB()
      ..id = nanoid(4)
      ..name = name;
    if (color != null) {
      option.color = color;
    }

    final payload = RepeatedSelectOptionPayload()
      ..viewId = viewId
      ..fieldId = fieldId
      ..rowId = rowId
      ..items.add(option);

    return DatabaseEventInsertOrUpdateSelectOption(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> update({
    required SelectOptionPB option,
  }) {
    final payload = RepeatedSelectOptionPayload()
      ..items.add(option)
      ..viewId = viewId
      ..fieldId = fieldId
      ..rowId = rowId;

    return DatabaseEventInsertOrUpdateSelectOption(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> delete({
    required Iterable<SelectOptionPB> options,
  }) {
    final payload = RepeatedSelectOptionPayload()
      ..items.addAll(options)
      ..viewId = viewId
      ..fieldId = fieldId
      ..rowId = rowId;

    return DatabaseEventDeleteSelectOption(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> select({
    required Iterable<String> optionIds,
  }) {
    final payload = SelectOptionCellChangesetPB()
      ..cellIdentifier = _cellIdentifier()
      ..insertOptionIds.addAll(optionIds);

    return DatabaseEventUpdateSelectOptionCell(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> unselect({
    required Iterable<String> optionIds,
  }) {
    final payload = SelectOptionCellChangesetPB()
      ..cellIdentifier = _cellIdentifier()
      ..deleteOptionIds.addAll(optionIds);

    return DatabaseEventUpdateSelectOptionCell(payload).send();
  }

  CellIdPB _cellIdentifier() {
    return CellIdPB()
      ..viewId = viewId
      ..fieldId = fieldId
      ..rowId = rowId;
  }
}
