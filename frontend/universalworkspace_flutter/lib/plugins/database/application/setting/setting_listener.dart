import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/setting_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef UpdateSettingNotifiedValue
    = UniflowResult<DatabaseViewSettingPB, UniflowError>;

class DatabaseSettingListener {
  DatabaseSettingListener({required this.viewId});

  final String viewId;

  DatabaseNotificationListener? _listener;
  PublishNotifier<UpdateSettingNotifiedValue>? _updateSettingNotifier =
      PublishNotifier();

  void start({
    required void Function(UpdateSettingNotifiedValue) onSettingUpdated,
  }) {
    _updateSettingNotifier?.addPublishListener(onSettingUpdated);
    _listener =
        DatabaseNotificationListener(objectId: viewId, handler: _handler);
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateSettings:
        result.fold(
          (payload) => _updateSettingNotifier?.value = UniflowResult.success(
            DatabaseViewSettingPB.fromBuffer(payload),
          ),
          (error) => _updateSettingNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _updateSettingNotifier?.dispose();
    _updateSettingNotifier = null;
  }
}
