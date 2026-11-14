import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

import '../application/row/row_service.dart';

typedef UpdateFieldNotifiedValue = UniflowResult<void, UniflowError>;

class CellListener {
  CellListener({required this.rowId, required this.fieldId});

  final RowId rowId;
  final String fieldId;

  PublishNotifier<UpdateFieldNotifiedValue>? _updateCellNotifier =
      PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({required void Function(UpdateFieldNotifiedValue) onCellChanged}) {
    _updateCellNotifier?.addPublishListener(onCellChanged);
    _listener = DatabaseNotificationListener(
      objectId: "$rowId:$fieldId",
      handler: _handler,
    );
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateCell:
        result.fold(
          (payload) => _updateCellNotifier?.value = UniflowResult.success(null),
          (error) => _updateCellNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _updateCellNotifier?.dispose();
    _updateCellNotifier = null;
  }
}
