import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/folder_notification.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

// Delete the view from trash, which means the view was deleted permanently
typedef DeleteViewNotifyValue = UniflowResult<ViewPB, UniflowError>;
// The view get updated
typedef UpdateViewNotifiedValue = ViewPB;
// Restore the view from trash
typedef RestoreViewNotifiedValue = UniflowResult<ViewPB, UniflowError>;
// Move the view to trash
typedef MoveToTrashNotifiedValue = UniflowResult<DeletedViewPB, UniflowError>;

class ViewListener {
  ViewListener({required this.viewId});

  StreamSubscription<SubscribeObject>? _subscription;
  void Function(UpdateViewNotifiedValue)? _updatedViewNotifier;
  void Function(ChildViewUpdatePB)? _updateViewChildViewsNotifier;
  void Function(DeleteViewNotifyValue)? _deletedNotifier;
  void Function(RestoreViewNotifiedValue)? _restoredNotifier;
  void Function(MoveToTrashNotifiedValue)? _moveToTrashNotifier;
  bool _isDisposed = false;

  FolderNotificationParser? _parser;
  final String viewId;

  void start({
    void Function(UpdateViewNotifiedValue)? onViewUpdated,
    void Function(ChildViewUpdatePB)? onViewChildViewsUpdated,
    void Function(DeleteViewNotifyValue)? onViewDeleted,
    void Function(RestoreViewNotifiedValue)? onViewRestored,
    void Function(MoveToTrashNotifiedValue)? onViewMoveToTrash,
  }) {
    if (_isDisposed) {
      Log.warn("ViewListener is already disposed");
      return;
    }

    _updatedViewNotifier = onViewUpdated;
    _deletedNotifier = onViewDeleted;
    _restoredNotifier = onViewRestored;
    _moveToTrashNotifier = onViewMoveToTrash;
    _updateViewChildViewsNotifier = onViewChildViewsUpdated;

    _parser = FolderNotificationParser(
      id: viewId,
      callback: (ty, result) {
        _handleObservableType(ty, result);
      },
    );

    _subscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  void _handleObservableType(
    FolderNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case FolderNotification.DidUpdateView:
        result.fold(
          (payload) {
            final view = ViewPB.fromBuffer(payload);
            _updatedViewNotifier?.call(view);
          },
          (error) => Log.error(error),
        );
        break;
      case FolderNotification.DidUpdateChildViews:
        result.fold(
          (payload) {
            final pb = ChildViewUpdatePB.fromBuffer(payload);
            _updateViewChildViewsNotifier?.call(pb);
          },
          (error) => Log.error(error),
        );
        break;
      case FolderNotification.DidDeleteView:
        result.fold(
          (payload) => _deletedNotifier
              ?.call(UniflowResult.success(ViewPB.fromBuffer(payload))),
          (error) => _deletedNotifier?.call(UniflowResult.failure(error)),
        );
        break;
      case FolderNotification.DidRestoreView:
        result.fold(
          (payload) => _restoredNotifier
              ?.call(UniflowResult.success(ViewPB.fromBuffer(payload))),
          (error) => _restoredNotifier?.call(UniflowResult.failure(error)),
        );
        break;
      case FolderNotification.DidMoveViewToTrash:
        result.fold(
          (payload) => _moveToTrashNotifier
              ?.call(UniflowResult.success(DeletedViewPB.fromBuffer(payload))),
          (error) => _moveToTrashNotifier?.call(UniflowResult.failure(error)),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    _isDisposed = true;
    _parser = null;
    await _subscription?.cancel();
    _updatedViewNotifier = null;
    _deletedNotifier = null;
    _restoredNotifier = null;
  }
}
