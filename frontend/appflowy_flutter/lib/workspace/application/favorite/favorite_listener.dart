import 'dart:async';

import 'package:universalworkspace/core/notification/folder_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:flutter/foundation.dart';

typedef FavoriteUpdated = void Function(
  UniflowResult<RepeatedViewPB, UniflowError> result,
  bool isFavorite,
);

class FavoriteListener {
  StreamSubscription<SubscribeObject>? _streamSubscription;
  FolderNotificationParser? _parser;

  FavoriteUpdated? _favoriteUpdated;

  void start({
    FavoriteUpdated? favoritesUpdated,
  }) {
    _favoriteUpdated = favoritesUpdated;
    _parser = FolderNotificationParser(
      id: 'favorite',
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
    switch (ty) {
      case FolderNotification.DidFavoriteView:
        result.onSuccess(
          (success) => _favoriteUpdated?.call(
            UniflowResult.success(RepeatedViewPB.fromBuffer(success)),
            true,
          ),
        );
      case FolderNotification.DidUnfavoriteView:
        result.map(
          (success) => _favoriteUpdated?.call(
            UniflowResult.success(RepeatedViewPB.fromBuffer(success)),
            false,
          ),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    _parser = null;
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    _favoriteUpdated = null;
  }
}
