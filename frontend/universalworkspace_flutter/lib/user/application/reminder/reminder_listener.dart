import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/user_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/reminder.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class UserAwarenessListener {
  UserAwarenessListener({
    required this.workspaceId,
  });

  final String workspaceId;

  UserNotificationParser? _userParser;
  StreamSubscription<SubscribeObject>? _subscription;
  void Function()? onLoadedUserAwareness;
  void Function(ReminderPB)? onDidUpdateReminder;

  /// [onLoadedUserAwareness] is called when the user awareness is loaded. After this, can
  /// call fetch reminders releated events
  ///
  void start({
    void Function()? onLoadedUserAwareness,
    void Function(ReminderPB)? onDidUpdateReminder,
  }) {
    this.onLoadedUserAwareness = onLoadedUserAwareness;
    this.onDidUpdateReminder = onDidUpdateReminder;

    _userParser = UserNotificationParser(
      id: workspaceId,
      callback: _userNotificationCallback,
    );

    _subscription = RustStreamReceiver.listen((observable) {
      _userParser?.parse(observable);
    });
  }

  void stop() {
    _userParser = null;
    _subscription?.cancel();
    _subscription = null;
  }

  void _userNotificationCallback(
    UserNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case UserNotification.DidLoadUserAwareness:
        onLoadedUserAwareness?.call();
        break;
      case UserNotification.DidUpdateReminder:
        result.map((r) => onDidUpdateReminder?.call(ReminderPB.fromBuffer(r)));
        break;
      default:
        break;
    }
  }
}
