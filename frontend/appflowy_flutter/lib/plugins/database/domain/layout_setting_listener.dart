import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef LayoutSettingsValue<T> = UniflowResult<T, UniflowError>;

class DatabaseLayoutSettingListener {
  DatabaseLayoutSettingListener(this.viewId);

  final String viewId;

  PublishNotifier<LayoutSettingsValue<DatabaseLayoutSettingPB>>?
      _settingNotifier = PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(LayoutSettingsValue<DatabaseLayoutSettingPB>)
        onLayoutChanged,
  }) {
    _settingNotifier?.addPublishListener(onLayoutChanged);
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
      case DatabaseNotification.DidUpdateLayoutSettings:
        result.fold(
          (payload) => _settingNotifier?.value =
              UniflowResult.success(DatabaseLayoutSettingPB.fromBuffer(payload)),
          (error) => _settingNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _settingNotifier?.dispose();
    _settingNotifier = null;
  }
}
