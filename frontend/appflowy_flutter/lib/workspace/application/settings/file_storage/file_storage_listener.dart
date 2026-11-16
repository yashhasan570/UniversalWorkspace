import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/notification_helper.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-storage/notification.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class StoregeNotificationParser
    extends NotificationParser<StorageNotification, UniflowError> {
  StoregeNotificationParser({
    super.id,
    required super.callback,
  }) : super(
          tyParser: (ty, source) =>
              source == "storage" ? StorageNotification.valueOf(ty) : null,
          errorParser: (bytes) => UniflowError.fromBuffer(bytes),
        );
}

class StoreageNotificationListener {
  StoreageNotificationListener({
    void Function(UniflowError error)? onError,
  }) : _parser = StoregeNotificationParser(
          callback: (
            StorageNotification ty,
            UniflowResult<Uint8List, UniflowError> result,
          ) {
            result.fold(
              (data) {
                try {
                  switch (ty) {
                    case StorageNotification.FileStorageLimitExceeded:
                      onError?.call(UniflowError.fromBuffer(data));
                      break;
                    case StorageNotification.SingleFileLimitExceeded:
                      onError?.call(UniflowError.fromBuffer(data));
                      break;
                  }
                } catch (e) {
                  Log.error(
                    "$StoreageNotificationListener deserialize PB fail",
                    e,
                  );
                }
              },
              (err) {
                Log.error("Error in StoreageNotificationListener", err);
              },
            );
          },
        ) {
    _subscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  StoregeNotificationParser? _parser;
  StreamSubscription<SubscribeObject>? _subscription;

  Future<void> stop() async {
    _parser = null;
    await _subscription?.cancel();
    _subscription = null;
  }
}
