import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/sort_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/view_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

typedef RowsVisibilityCallback = void Function(
  UniflowResult<RowsVisibilityChangePB, UniflowError>,
);
typedef NumberOfRowsCallback = void Function(
  UniflowResult<RowsChangePB, UniflowError>,
);
typedef ReorderAllRowsCallback = void Function(
  UniflowResult<List<String>, UniflowError>,
);
typedef SingleRowCallback = void Function(
  UniflowResult<ReorderSingleRowPB, UniflowError>,
);

class DatabaseViewListener {
  DatabaseViewListener({required this.viewId});

  final String viewId;
  DatabaseNotificationListener? _listener;

  void start({
    required NumberOfRowsCallback onRowsChanged,
    required ReorderAllRowsCallback onReorderAllRows,
    required SingleRowCallback onReorderSingleRow,
    required RowsVisibilityCallback onRowsVisibilityChanged,
  }) {
    // Stop any existing listener
    _listener?.stop();

    // Initialize the notification listener
    _listener = DatabaseNotificationListener(
      objectId: viewId,
      handler: (ty, result) => _handler(
        ty,
        result,
        onRowsChanged,
        onReorderAllRows,
        onReorderSingleRow,
        onRowsVisibilityChanged,
      ),
    );
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
    NumberOfRowsCallback onRowsChanged,
    ReorderAllRowsCallback onReorderAllRows,
    SingleRowCallback onReorderSingleRow,
    RowsVisibilityCallback onRowsVisibilityChanged,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateViewRowsVisibility:
        result.fold(
          (payload) => onRowsVisibilityChanged(
            UniflowResult.success(RowsVisibilityChangePB.fromBuffer(payload)),
          ),
          (error) => onRowsVisibilityChanged(UniflowResult.failure(error)),
        );
        break;
      case DatabaseNotification.DidUpdateRow:
        result.fold(
          (payload) => onRowsChanged(
            UniflowResult.success(RowsChangePB.fromBuffer(payload)),
          ),
          (error) => onRowsChanged(UniflowResult.failure(error)),
        );
        break;
      case DatabaseNotification.DidReorderRows:
        result.fold(
          (payload) => onReorderAllRows(
            UniflowResult.success(ReorderAllRowsPB.fromBuffer(payload).rowOrders),
          ),
          (error) => onReorderAllRows(UniflowResult.failure(error)),
        );
        break;
      case DatabaseNotification.DidReorderSingleRow:
        result.fold(
          (payload) => onReorderSingleRow(
            UniflowResult.success(ReorderSingleRowPB.fromBuffer(payload)),
          ),
          (error) => onReorderSingleRow(UniflowResult.failure(error)),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _listener = null;
  }
}
