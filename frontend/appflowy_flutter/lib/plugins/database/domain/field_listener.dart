import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef UpdateFieldsNotifiedValue
    = UniflowResult<DatabaseFieldChangesetPB, UniflowError>;

class FieldsListener {
  FieldsListener({required this.viewId});

  final String viewId;

  PublishNotifier<UpdateFieldsNotifiedValue>? updateFieldsNotifier =
      PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(UpdateFieldsNotifiedValue) onFieldsChanged,
  }) {
    updateFieldsNotifier?.addPublishListener(onFieldsChanged);
    _listener = DatabaseNotificationListener(
      objectId: viewId,
      handler: _handler,
    );
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateFields:
        result.fold(
          (payload) => updateFieldsNotifier?.value =
              UniflowResult.success(DatabaseFieldChangesetPB.fromBuffer(payload)),
          (error) => updateFieldsNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    updateFieldsNotifier?.dispose();
    updateFieldsNotifier = null;
  }
}
