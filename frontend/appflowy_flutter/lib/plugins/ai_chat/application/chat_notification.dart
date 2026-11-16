import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/notification_helper.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-ai/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/protobuf.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class ChatNotificationParser
    extends NotificationParser<ChatNotification, UniflowError> {
  ChatNotificationParser({
    super.id,
    required super.callback,
  }) : super(
          tyParser: (ty, source) =>
              source == "Chat" ? ChatNotification.valueOf(ty) : null,
          errorParser: (bytes) => UniflowError.fromBuffer(bytes),
        );
}

typedef ChatNotificationHandler = Function(
  ChatNotification ty,
  UniflowResult<Uint8List, UniflowError> result,
);

class ChatNotificationListener {
  ChatNotificationListener({
    required String objectId,
    required ChatNotificationHandler handler,
  }) : _parser = ChatNotificationParser(id: objectId, callback: handler) {
    _subscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  ChatNotificationParser? _parser;
  StreamSubscription<SubscribeObject>? _subscription;

  Future<void> stop() async {
    _parser = null;
    await _subscription?.cancel();
    _subscription = null;
  }
}
