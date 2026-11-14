import 'package:universalworkspace/plugins/database/application/row/row_service.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import 'layout_service.dart';

class DatabaseViewBackendService {
  DatabaseViewBackendService({required this.viewId});

  final String viewId;

  /// Returns the database id associated with the view.
  Future<UniflowResult<String, UniflowError>> getDatabaseId() async {
    final payload = DatabaseViewIdPB(value: viewId);
    return DatabaseEventGetDatabaseId(payload)
        .send()
        .then((value) => value.map((l) => l.value));
  }

  static Future<UniflowResult<ViewPB, UniflowError>> updateLayout({
    required String viewId,
    required DatabaseLayoutPB layout,
  }) {
    final payload = UpdateViewPayloadPB.create()
      ..viewId = viewId
      ..layout = viewLayoutFromDatabaseLayout(layout);

    return FolderEventUpdateView(payload).send();
  }

  Future<UniflowResult<DatabasePB, UniflowError>> openDatabase() async {
    final payload = DatabaseViewIdPB(value: viewId);
    return DatabaseEventGetDatabase(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> moveGroupRow({
    required RowId fromRowId,
    required String fromGroupId,
    required String toGroupId,
    RowId? toRowId,
  }) {
    final payload = MoveGroupRowPayloadPB.create()
      ..viewId = viewId
      ..fromRowId = fromRowId
      ..fromGroupId = fromGroupId
      ..toGroupId = toGroupId;

    if (toRowId != null) {
      payload.toRowId = toRowId;
    }

    return DatabaseEventMoveGroupRow(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> moveRow({
    required String fromRowId,
    required String toRowId,
  }) {
    final payload = MoveRowPayloadPB.create()
      ..viewId = viewId
      ..fromRowId = fromRowId
      ..toRowId = toRowId;

    return DatabaseEventMoveRow(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> moveGroup({
    required String fromGroupId,
    required String toGroupId,
  }) {
    final payload = MoveGroupPayloadPB.create()
      ..viewId = viewId
      ..fromGroupId = fromGroupId
      ..toGroupId = toGroupId;

    return DatabaseEventMoveGroup(payload).send();
  }

  Future<UniflowResult<List<FieldPB>, UniflowError>> getFields({
    List<FieldIdPB>? fieldIds,
  }) {
    final payload = GetFieldPayloadPB.create()..viewId = viewId;

    if (fieldIds != null) {
      payload.fieldIds = RepeatedFieldIdPB(items: fieldIds);
    }
    return DatabaseEventGetFields(payload).send().then((result) {
      return result.fold(
        (l) => UniflowResult.success(l.items),
        (r) => UniflowResult.failure(r),
      );
    });
  }

  Future<UniflowResult<DatabaseLayoutSettingPB, UniflowError>> getLayoutSetting(
    DatabaseLayoutPB layoutType,
  ) {
    final payload = DatabaseLayoutMetaPB.create()
      ..viewId = viewId
      ..layout = layoutType;
    return DatabaseEventGetLayoutSetting(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> updateLayoutSetting({
    required DatabaseLayoutPB layoutType,
    BoardLayoutSettingPB? boardLayoutSetting,
    CalendarLayoutSettingPB? calendarLayoutSetting,
  }) {
    final payload = LayoutSettingChangesetPB.create()
      ..viewId = viewId
      ..layoutType = layoutType;

    if (boardLayoutSetting != null) {
      payload.board = boardLayoutSetting;
    }

    if (calendarLayoutSetting != null) {
      payload.calendar = calendarLayoutSetting;
    }

    return DatabaseEventSetLayoutSetting(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> closeView() {
    final request = ViewIdPB(value: viewId);
    return FolderEventCloseView(request).send();
  }

  Future<UniflowResult<RepeatedGroupPB, UniflowError>> loadGroups() {
    final payload = DatabaseViewIdPB(value: viewId);
    return DatabaseEventGetGroups(payload).send();
  }
}
