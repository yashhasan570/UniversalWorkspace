import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/folder_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/trash.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

typedef TrashUpdatedCallback = void Function(
  UniflowResult<List<TrashPB>, UniflowError> trashOrFailed,
);

class TrashListener {
  StreamSubscription<SubscribeObject>? _subscription;
  TrashUpdatedCallback? _trashUpdated;
  FolderNotificationParser? _parser;

  void start({TrashUpdatedCallback? trashUpdated}) {
    _trashUpdated = trashUpdated;
    _parser = FolderNotificationParser(
      id: "trash",
      callback: _observableCallback,
    );
    _subscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  void _observableCallback(
    FolderNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case FolderNotification.DidUpdateTrash:
        if (_trashUpdated != null) {
          result.fold(
            (payload) {
              final repeatedTrash = RepeatedTrashPB.fromBuffer(payload);
              _trashUpdated!(UniflowResult.success(repeatedTrash.items));
            },
            (error) => _trashUpdated!(UniflowResult.failure(error)),
          );
        }
        break;
      default:
        break;
    }
  }

  Future<void> close() async {
    _parser = null;
    await _subscription?.cancel();
    _trashUpdated = null;
  }
}
