import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/sort_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef SortNotifiedValue
    = UniflowResult<SortChangesetNotificationPB, UniflowError>;

class SortsListener {
  SortsListener({required this.viewId});

  final String viewId;

  PublishNotifier<SortNotifiedValue>? _notifier = PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(SortNotifiedValue) onSortChanged,
  }) {
    _notifier?.addPublishListener(onSortChanged);
    _listener = DatabaseNotificationListener(
      objectId: viewId,
      handler: _handler,
    );
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateSort:
        result.fold(
          (payload) => _notifier?.value = UniflowResult.success(
            SortChangesetNotificationPB.fromBuffer(payload),
          ),
          (error) => _notifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _notifier?.dispose();
    _notifier = null;
  }
}
