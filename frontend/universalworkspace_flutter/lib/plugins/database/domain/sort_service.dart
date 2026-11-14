import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/database_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/setting_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/sort_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class SortBackendService {
  SortBackendService({required this.viewId});

  final String viewId;

  Future<UniflowResult<List<SortPB>, UniflowError>> getAllSorts() {
    final payload = DatabaseViewIdPB()..value = viewId;

    return DatabaseEventGetAllSorts(payload).send().then((result) {
      return result.fold(
        (repeated) => UniflowResult.success(repeated.items),
        (r) => UniflowResult.failure(r),
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> updateSort({
    required String sortId,
    required String fieldId,
    required SortConditionPB condition,
  }) {
    final insertSortPayload = UpdateSortPayloadPB.create()
      ..viewId = viewId
      ..sortId = sortId
      ..fieldId = fieldId
      ..condition = condition;

    final payload = DatabaseSettingChangesetPB.create()
      ..viewId = viewId
      ..updateSort = insertSortPayload;
    return DatabaseEventUpdateDatabaseSetting(payload).send().then((result) {
      return result.fold(
        (l) => UniflowResult.success(l),
        (err) {
          Log.error(err);
          return UniflowResult.failure(err);
        },
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> insertSort({
    required String fieldId,
    required SortConditionPB condition,
  }) {
    final insertSortPayload = UpdateSortPayloadPB.create()
      ..fieldId = fieldId
      ..viewId = viewId
      ..condition = condition;

    final payload = DatabaseSettingChangesetPB.create()
      ..viewId = viewId
      ..updateSort = insertSortPayload;
    return DatabaseEventUpdateDatabaseSetting(payload).send().then((result) {
      return result.fold(
        (l) => UniflowResult.success(l),
        (err) {
          Log.error(err);
          return UniflowResult.failure(err);
        },
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> reorderSort({
    required String fromSortId,
    required String toSortId,
  }) {
    final payload = DatabaseSettingChangesetPB()
      ..viewId = viewId
      ..reorderSort = (ReorderSortPayloadPB()
        ..viewId = viewId
        ..fromSortId = fromSortId
        ..toSortId = toSortId);

    return DatabaseEventUpdateDatabaseSetting(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> deleteSort({
    required String sortId,
  }) {
    final deleteSortPayload = DeleteSortPayloadPB.create()
      ..sortId = sortId
      ..viewId = viewId;

    final payload = DatabaseSettingChangesetPB.create()
      ..viewId = viewId
      ..deleteSort = deleteSortPayload;

    return DatabaseEventUpdateDatabaseSetting(payload).send().then((result) {
      return result.fold(
        (l) => UniflowResult.success(l),
        (err) {
          Log.error(err);
          return UniflowResult.failure(err);
        },
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> deleteAllSorts() {
    final payload = DatabaseViewIdPB(value: viewId);
    return DatabaseEventDeleteAllSorts(payload).send().then((result) {
      return result.fold(
        (l) => UniflowResult.success(l),
        (err) {
          Log.error(err);
          return UniflowResult.failure(err);
        },
      );
    });
  }
}
