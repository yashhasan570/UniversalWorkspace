import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import '../../../core/notification/user_notification.dart';

class UserCloudConfigListener {
  UserCloudConfigListener();

  UserNotificationParser? _userParser;
  StreamSubscription<SubscribeObject>? _subscription;
  void Function(UniflowResult<CloudSettingPB, UniflowError>)? _onSettingChanged;

  void start({
    void Function(UniflowResult<CloudSettingPB, UniflowError>)? onSettingChanged,
  }) {
    _onSettingChanged = onSettingChanged;
    _userParser = UserNotificationParser(
      id: 'user_cloud_config',
      callback: _userNotificationCallback,
    );
    _subscription = RustStreamReceiver.listen((observable) {
      _userParser?.parse(observable);
    });
  }

  Future<void> stop() async {
    _userParser = null;
    await _subscription?.cancel();
    _onSettingChanged = null;
  }

  void _userNotificationCallback(
    UserNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case UserNotification.DidUpdateCloudConfig:
        result.fold(
          (payload) => _onSettingChanged
              ?.call(UniflowResult.success(CloudSettingPB.fromBuffer(payload))),
          (error) => _onSettingChanged?.call(UniflowResult.failure(error)),
        );
        break;
      default:
        break;
    }
  }
}
