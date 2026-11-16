import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/filter_changeset.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/util.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef UpdateFilterNotifiedValue
    = UniflowResult<FilterChangesetNotificationPB, UniflowError>;

class FiltersListener {
  FiltersListener({required this.viewId});

  final String viewId;

  PublishNotifier<UpdateFilterNotifiedValue>? _filterNotifier =
      PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(UpdateFilterNotifiedValue) onFilterChanged,
  }) {
    _filterNotifier?.addPublishListener(onFilterChanged);
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
      case DatabaseNotification.DidUpdateFilter:
        result.fold(
          (payload) => _filterNotifier?.value = UniflowResult.success(
            FilterChangesetNotificationPB.fromBuffer(payload),
          ),
          (error) => _filterNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _filterNotifier?.dispose();
    _filterNotifier = null;
  }
}

class FilterListener {
  FilterListener({required this.viewId, required this.filterId});

  final String viewId;
  final String filterId;

  PublishNotifier<FilterPB>? _onUpdateNotifier = PublishNotifier();

  DatabaseNotificationListener? _listener;

  void start({void Function(FilterPB)? onUpdated}) {
    _onUpdateNotifier?.addPublishListener((filter) {
      onUpdated?.call(filter);
    });

    _listener = DatabaseNotificationListener(
      objectId: viewId,
      handler: _handler,
    );
  }

  void handleChangeset(FilterChangesetNotificationPB changeset) {
    final filters = changeset.filters.items;
    final updatedIndex = filters.indexWhere(
      (filter) => filter.id == filterId,
    );
    if (updatedIndex != -1) {
      _onUpdateNotifier?.value = filters[updatedIndex];
    }
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateFilter:
        result.fold(
          (payload) => handleChangeset(
            FilterChangesetNotificationPB.fromBuffer(payload),
          ),
          (error) {},
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _onUpdateNotifier?.dispose();
    _onUpdateNotifier = null;
  }
}
