import 'dart:collection';

import 'package:universalworkspace/plugins/database/application/field/filter_entities.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'field/field_info.dart';
import 'field/sort_entities.dart';
import 'row/row_cache.dart';
import 'row/row_service.dart';

part 'defines.freezed.dart';

typedef OnFieldsChanged = void Function(UnmodifiableListView<FieldInfo>);
typedef OnFiltersChanged = void Function(List<DatabaseFilter>);
typedef OnSortsChanged = void Function(List<DatabaseSort>);
typedef OnDatabaseChanged = void Function(DatabasePB);

typedef OnRowsCreated = void Function(List<InsertedRowPB> rows);
typedef OnRowsUpdated = void Function(
  List<RowId> rowIds,
  ChangedReason reason,
);
typedef OnRowsDeleted = void Function(List<RowId> rowIds);
typedef OnNumOfRowsChanged = void Function(
  UnmodifiableListView<RowInfo> rows,
  UnmodifiableMapView<RowId, RowInfo> rowById,
  ChangedReason reason,
);
typedef OnRowsVisibilityChanged = void Function(
  List<(RowId, bool)> rowVisibilityChanges,
);

@freezed
class LoadingState with _$LoadingState {
  const factory LoadingState.idle() = _Idle;
  const factory LoadingState.loading() = _Loading;
  const factory LoadingState.finish(
    UniflowResult<void, UniflowError> successOrFail,
  ) = _Finish;

  const LoadingState._();
  bool isLoading() => this is _Loading;
}
