import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/user_notification.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/auth.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/notification.pb.dart'
    as user;
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class UserAuthStateListener {
  void Function(String)? _onInvalidAuth;
  void Function()? _didSignIn;
  StreamSubscription<SubscribeObject>? _subscription;
  UserNotificationParser? _userParser;

  void start({
    void Function(String)? onInvalidAuth,
    void Function()? didSignIn,
  }) {
    _onInvalidAuth = onInvalidAuth;
    _didSignIn = didSignIn;

    _userParser = UserNotificationParser(
      id: "auth_state_change_notification",
      callback: _userNotificationCallback,
    );
    _subscription = RustStreamReceiver.listen((observable) {
      _userParser?.parse(observable);
    });
  }

  Future<void> stop() async {
    _userParser = null;
    await _subscription?.cancel();
    _onInvalidAuth = null;
  }

  void _userNotificationCallback(
    user.UserNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case user.UserNotification.UserAuthStateChanged:
        result.fold(
          (payload) {
            final pb = AuthStateChangedPB.fromBuffer(payload);
            switch (pb.state) {
              case AuthStatePB.AuthStateSignIn:
                _didSignIn?.call();
                break;
              case AuthStatePB.InvalidAuth:
                _onInvalidAuth?.call(pb.message);
                break;
              default:
                break;
            }
          },
          (r) => Log.error(r),
        );
        break;
      default:
        break;
    }
  }
}
