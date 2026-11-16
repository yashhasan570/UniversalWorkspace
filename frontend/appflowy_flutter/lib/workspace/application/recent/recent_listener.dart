import 'dart:async';

import 'package:universalworkspace/core/notification/folder_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:flutter/foundation.dart';

typedef RecentViewsUpdated = void Function(
  UniflowResult<RepeatedViewIdPB, UniflowError> result,
);

class RecentViewsListener {
  StreamSubscription<SubscribeObject>? _streamSubscription;
  FolderNotificationParser? _parser;

  RecentViewsUpdated? _recentViewsUpdated;

  void start({
    RecentViewsUpdated? recentViewsUpdated,
  }) {
    _recentViewsUpdated = recentViewsUpdated;
    _parser = FolderNotificationParser(
      id: 'recent_views',
      callback: _observableCallback,
    );
    _streamSubscription = RustStreamReceiver.listen(
      (observable) => _parser?.parse(observable),
    );
  }

  void _observableCallback(
    FolderNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    if (_recentViewsUpdated == null) {
      return;
    }

    result.fold(
      (payload) {
        final view = RepeatedViewIdPB.fromBuffer(payload);
        _recentViewsUpdated?.call(
          UniflowResult.success(view),
        );
      },
      (error) => _recentViewsUpdated?.call(
        UniflowResult.failure(error),
      ),
    );
  }

  Future<void> stop() async {
    _parser = null;
    await _streamSubscription?.cancel();
    _recentViewsUpdated = null;
  }
}
