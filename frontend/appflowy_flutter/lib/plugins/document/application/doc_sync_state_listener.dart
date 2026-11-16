import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/document_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-document/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

typedef DocumentSyncStateCallback = void Function(
  DocumentSyncStatePB syncState,
);

class DocumentSyncStateListener {
  DocumentSyncStateListener({
    required this.id,
  });

  final String id;
  StreamSubscription<SubscribeObject>? _subscription;
  DocumentNotificationParser? _parser;
  DocumentSyncStateCallback? didReceiveSyncState;

  void start({
    DocumentSyncStateCallback? didReceiveSyncState,
  }) {
    this.didReceiveSyncState = didReceiveSyncState;

    _parser = DocumentNotificationParser(
      id: id,
      callback: _callback,
    );
    _subscription = RustStreamReceiver.listen(
      (observable) => _parser?.parse(observable),
    );
  }

  void _callback(
    DocumentNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DocumentNotification.DidUpdateDocumentSyncState:
        result.map(
          (r) {
            final value = DocumentSyncStatePB.fromBuffer(r);
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
