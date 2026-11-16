import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import '../field/field_info.dart';

typedef RowId = String;

class RowBackendService {
  RowBackendService({required this.viewId});

  final String viewId;

  static Future<UniflowResult<RowMetaPB, UniflowError>> createRow({
    required String viewId,
    String? groupId,
    void Function(RowDataBuilder builder)? withCells,
    OrderObjectPositionTypePB? position,
    String? targetRowId,
  }) {
    final payload = CreateRowPayloadPB(
      viewId: viewId,
      groupId: groupId,
      rowPosition: OrderObjectPositionPB(
        position: position,
        objectId: targetRowId,
      ),
    );

    if (withCells != null) {
      final rowBuilder = RowDataBuilder();
      withCells(rowBuilder);
      payload.data.addAll(rowBuilder.build());
    }

    return DatabaseEventCreateRow(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> initRow(RowId rowId) async {
    final payload = DatabaseViewRowIdPB()
      ..viewId = viewId
      ..rowId = rowId;

    return DatabaseEventInitRow(payload).send();
  }

  Future<UniflowResult<RowMetaPB, UniflowError>> createRowBefore(RowId rowId) {
    return createRow(
      viewId: viewId,
      position: OrderObjectPositionTypePB.Before,
      targetRowId: rowId,
    );
  }

  Future<UniflowResult<RowMetaPB, UniflowError>> createRowAfter(RowId rowId) {
    return createRow(
      viewId: viewId,
      position: OrderObjectPositionTypePB.After,
      targetRowId: rowId,
    );
  }

  static Future<UniflowResult<RowMetaPB, UniflowError>> getRow({
    required String viewId,
    required String rowId,
  }) {
    final payload = DatabaseViewRowIdPB()
      ..viewId = viewId
      ..rowId = rowId;

    return DatabaseEventGetRowMeta(payload).send();
  }

  Future<UniflowResult<RowMetaPB, UniflowError>> getRowMeta(RowId rowId) {
    final payload = DatabaseViewRowIdPB.create()
      ..viewId = viewId
      ..rowId = rowId;

    return DatabaseEventGetRowMeta(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> updateMeta({
    required String rowId,
    String? iconURL,
    RowCoverPB? cover,
    bool? isDocumentEmpty,
  }) {
    final payload = UpdateRowMetaChangesetPB.create()
      ..viewId = viewId
      ..id = rowId;

    if (iconURL != null) {
      payload.iconUrl = iconURL;
    }
    if (cover != null) {
      payload.cover = cover;
    }

    if (isDocumentEmpty != null) {
      payload.isDocumentEmpty = isDocumentEmpty;
    }

    return DatabaseEventUpdateRowMeta(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> removeCover(String rowId) async {
    final payload = RemoveCoverPayloadPB.create()
      ..viewId = viewId
      ..rowId = rowId;

    return DatabaseEventRemoveCover(payload).send();
  }

  static Future<UniflowResult<void, UniflowError>> deleteRows(
    String viewId,
    List<RowId> rowIds,
  ) {
    final payload = RepeatedRowIdPB.create()
      ..viewId = viewId
      ..rowIds.addAll(rowIds);

    return DatabaseEventDeleteRows(payload).send();
  }

  static Future<UniflowResult<void, UniflowError>> duplicateRow(
    String viewId,
    RowId rowId,
  ) {
    final payload = DatabaseViewRowIdPB(
      viewId: viewId,
      rowId: rowId,
    );

    return DatabaseEventDuplicateRow(payload).send();
  }
}

class RowDataBuilder {
  final _cellDataByFieldId = <String, String>{};

  void insertText(FieldInfo fieldInfo, String text) {
    assert(fieldInfo.fieldType == FieldType.RichText);
    _cellDataByFieldId[fieldInfo.field.id] = text;
  }

  void insertNumber(FieldInfo fieldInfo, int num) {
    assert(fieldInfo.fieldType == FieldType.Number);
    _cellDataByFieldId[fieldInfo.field.id] = num.toString();
  }

  void insertDate(FieldInfo fieldInfo, DateTime date) {
    assert(fieldInfo.fieldType == FieldType.DateTime);
    final timestamp = date.millisecondsSinceEpoch ~/ 1000;
    _cellDataByFieldId[fieldInfo.field.id] = timestamp.toString();
  }

  Map<String, String> build() {
    return _cellDataByFieldId;
  }
}
