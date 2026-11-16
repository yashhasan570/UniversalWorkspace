import 'dart:async';

import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import '../application/cell/cell_controller.dart';

class CellBackendService {
  CellBackendService();

  static Future<UniflowResult<void, UniflowError>> updateCell({
    required String viewId,
    required CellContext cellContext,
    required String data,
  }) {
    final payload = CellChangesetPB()
      ..viewId = viewId
      ..fieldId = cellContext.fieldId
      ..rowId = cellContext.rowId
      ..cellChangeset = data;
    return DatabaseEventUpdateCell(payload).send();
  }

  static Future<UniflowResult<CellPB, UniflowError>> getCell({
    required String viewId,
    required CellContext cellContext,
  }) {
    final payload = CellIdPB()
      ..viewId = viewId
      ..fieldId = cellContext.fieldId
      ..rowId = cellContext.rowId;
    return DatabaseEventGetCell(payload).send();
  }
}
