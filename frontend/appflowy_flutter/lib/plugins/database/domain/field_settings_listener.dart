import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef FieldSettingsValue = UniflowResult<FieldSettingsPB, UniflowError>;

class FieldSettingsListener {
  FieldSettingsListener({required this.viewId});

  final String viewId;

  PublishNotifier<FieldSettingsValue>? _fieldSettingsNotifier =
      PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(FieldSettingsValue) onFieldSettingsChanged,
  }) {
    _fieldSettingsNotifier?.addPublishListener(onFieldSettingsChanged);
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
      case DatabaseNotification.DidUpdateFieldSettings:
        result.fold(
          (payload) => _fieldSettingsNotifier?.value =
              UniflowResult.success(FieldSettingsPB.fromBuffer(payload)),
          (error) => _fieldSettingsNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _fieldSettingsNotifier?.dispose();
    _fieldSettingsNotifier = null;
  }
}
