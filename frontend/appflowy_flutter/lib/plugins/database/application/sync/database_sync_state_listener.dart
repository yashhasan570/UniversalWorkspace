import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

typedef DatabaseSyncStateCallback = void Function(
  DatabaseSyncStatePB syncState,
);

class DatabaseSyncStateListener {
  DatabaseSyncStateListener({
    // NOTE: NOT the view id.
    required this.databaseId,
  });

  final String databaseId;
  StreamSubscription<SubscribeObject>? _subscription;
  DatabaseNotificationParser? _parser;

  DatabaseSyncStateCallback? didReceiveSyncState;

  void start({
    DatabaseSyncStateCallback? didReceiveSyncState,
  }) {
    this.didReceiveSyncState = didReceiveSyncState;

    _parser = DatabaseNotificationParser(
      id: databaseId,
      callback: _callback,
    );
    _subscription = RustStreamReceiver.listen(
      (observable) => _parser?.parse(observable),
    );
  }

  void _callback(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateDatabaseSyncUpdate:
        result.map(
          (r) {
            final value = DatabaseSyncStatePB.fromBuffer(r);
            didReceiveSyncState?.call(value);
          },
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
