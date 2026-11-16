import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/protobuf.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import 'notification_helper.dart';

// This value should be the same as the DATABASE_OBSERVABLE_SOURCE value
const String _source = 'Database';

class DatabaseNotificationParser
    extends NotificationParser<DatabaseNotification, UniflowError> {
  DatabaseNotificationParser({
    super.id,
    required super.callback,
  }) : super(
          tyParser: (ty, source) =>
              source == _source ? DatabaseNotification.valueOf(ty) : null,
          errorParser: (bytes) => UniflowError.fromBuffer(bytes),
        );
}

typedef DatabaseNotificationHandler = Function(
  DatabaseNotification ty,
  UniflowResult<Uint8List, UniflowError> result,
);

class DatabaseNotificationListener {
  DatabaseNotificationListener({
    required String objectId,
    required DatabaseNotificationHandler handler,
  }) : _parser = DatabaseNotificationParser(id: objectId, callback: handler) {
    _subscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  DatabaseNotificationParser? _parser;
  StreamSubscription<SubscribeObject>? _subscription;

  Future<void> stop() async {
    _parser = null;
    await _subscription?.cancel();
    _subscription = null;
  }
}
