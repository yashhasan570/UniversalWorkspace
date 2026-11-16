import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class FilterBackendService {
  const FilterBackendService({required this.viewId});

  final String viewId;

  Future<UniflowResult<List<FilterPB>, UniflowError>> getAllFilters() {
    final payload = DatabaseViewIdPB()..value = viewId;

    return DatabaseEventGetAllFilters(payload).send().then((result) {
      return result.fold(
        (repeated) => UniflowResult.success(repeated.items),
        (r) => UniflowResult.failure(r),
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> insertTextFilter({
    required String fieldId,
    String? filterId,
    required TextFilterConditionPB condition,
    required String content,
  }) {
    final filter = TextFilterPB()
      ..condition = condition
      ..content = content;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.RichText,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.RichText,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertCheckboxFilter({
    required String fieldId,
    String? filterId,
    required CheckboxFilterConditionPB condition,
  }) {
    final filter = CheckboxFilterPB()..condition = condition;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.Checkbox,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.Checkbox,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertNumberFilter({
    required String fieldId,
    String? filterId,
    required NumberFilterConditionPB condition,
    String content = "",
  }) {
    final filter = NumberFilterPB()
      ..condition = condition
      ..content = content;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.Number,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.Number,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertDateFilter({
    required String fieldId,
    required FieldType fieldType,
    String? filterId,
    required DateFilterConditionPB condition,
    int? start,
    int? end,
    int? timestamp,
  }) {
    final filter = DateFilterPB()..condition = condition;

    if (timestamp != null) {
      filter.timestamp = $fixnum.Int64(timestamp);
    }
    if (start != null) {
      filter.start = $fixnum.Int64(start);
    }
    if (end != null) {
      filter.end = $fixnum.Int64(end);
    }

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: fieldType,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: fieldType,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertURLFilter({
    required String fieldId,
    String? filterId,
    required TextFilterConditionPB condition,
    String content = "",
  }) {
    final filter = TextFilterPB()
      ..condition = condition
      ..content = content;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.URL,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.URL,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertSelectOptionFilter({
    required String fieldId,
    required FieldType fieldType,
    required SelectOptionFilterConditionPB condition,
    String? filterId,
    List<String> optionIds = const [],
  }) {
    final filter = SelectOptionFilterPB()
      ..condition = condition
      ..optionIds.addAll(optionIds);

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: fieldType,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: fieldType,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertChecklistFilter({
    required String fieldId,
    required ChecklistFilterConditionPB condition,
    String? filterId,
    List<String> optionIds = const [],
  }) {
    final filter = ChecklistFilterPB()..condition = condition;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.Checklist,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.Checklist,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertTimeFilter({
    required String fieldId,
    String? filterId,
    required NumberFilterConditionPB condition,
    String content = "",
  }) {
    final filter = TimeFilterPB()
      ..condition = condition
      ..content = content;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.Time,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.Time,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> insertFilter({
    required String fieldId,
    required FieldType fieldType,
    required List<int> data,
  }) async {
    final filterData = FilterDataPB()
      ..fieldId = fieldId
      ..fieldType = fieldType
      ..data = data;

    final insertFilterPayload = InsertFilterPB()..data = filterData;

    final payload = DatabaseSettingChangesetPB()
      ..viewId = viewId
      ..insertFilter = insertFilterPayload;

    final result = await DatabaseEventUpdateDatabaseSetting(payload).send();
    return result.fold(
      (l) => UniflowResult.success(l),
      (err) {
        Log.error(err);
        return UniflowResult.failure(err);
      },
    );
  }

  Future<UniflowResult<void, UniflowError>> updateFilter({
    required String filterId,
    required String fieldId,
    required FieldType fieldType,
    required List<int> data,
  }) async {
    final filterData = FilterDataPB()
      ..fieldId = fieldId
      ..fieldType = fieldType
      ..data = data;

    final updateFilterPayload = UpdateFilterDataPB()
      ..filterId = filterId
      ..data = filterData;

    final payload = DatabaseSettingChangesetPB()
      ..viewId = viewId
      ..updateFilterData = updateFilterPayload;

    final result = await DatabaseEventUpdateDatabaseSetting(payload).send();
    return result.fold(
      (l) => UniflowResult.success(l),
      (err) {
        Log.error(err);
        return UniflowResult.failure(err);
      },
    );
  }

  Future<UniflowResult<void, UniflowError>> insertMediaFilter({
    required String fieldId,
    String? filterId,
    required MediaFilterConditionPB condition,
    String content = "",
  }) {
    final filter = MediaFilterPB()
      ..condition = condition
      ..content = content;

    return filterId == null
        ? insertFilter(
            fieldId: fieldId,
            fieldType: FieldType.Media,
            data: filter.writeToBuffer(),
          )
        : updateFilter(
            filterId: filterId,
            fieldId: fieldId,
            fieldType: FieldType.Media,
            data: filter.writeToBuffer(),
          );
  }

  Future<UniflowResult<void, UniflowError>> deleteFilter({
    required String filterId,
  }) async {
    final deleteFilterPayload = DeleteFilterPB()..filterId = filterId;

    final payload = DatabaseSettingChangesetPB()
      ..viewId = viewId
      ..deleteFilter = deleteFilterPayload;

    final result = await DatabaseEventUpdateDatabaseSetting(payload).send();
    return result.fold(
      (l) => UniflowResult.success(l),
      (err) {
        Log.error(err);
        return UniflowResult.failure(err);
      },
    );
  }
}
