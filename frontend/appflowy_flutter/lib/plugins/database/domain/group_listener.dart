import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/group.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/group_changeset.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef GroupUpdateValue = UniflowResult<GroupChangesPB, UniflowError>;
typedef GroupByNewFieldValue = UniflowResult<List<GroupPB>, UniflowError>;

class DatabaseGroupListener {
  DatabaseGroupListener(this.viewId);

  final String viewId;

  PublishNotifier<GroupUpdateValue>? _numOfGroupsNotifier = PublishNotifier();
  PublishNotifier<GroupByNewFieldValue>? _groupByFieldNotifier =
      PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(GroupUpdateValue) onNumOfGroupsChanged,
    required void Function(GroupByNewFieldValue) onGroupByNewField,
  }) {
    _numOfGroupsNotifier?.addPublishListener(onNumOfGroupsChanged);
    _groupByFieldNotifier?.addPublishListener(onGroupByNewField);
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
      case DatabaseNotification.DidUpdateNumOfGroups:
        result.fold(
          (payload) => _numOfGroupsNotifier?.value =
              UniflowResult.success(GroupChangesPB.fromBuffer(payload)),
          (error) => _numOfGroupsNotifier?.value = UniflowResult.failure(error),
        );
        break;
      case DatabaseNotification.DidGroupByField:
        result.fold(
          (payload) => _groupByFieldNotifier?.value = UniflowResult.success(
            GroupChangesPB.fromBuffer(payload).initialGroups,
          ),
          (error) => _groupByFieldNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _numOfGroupsNotifier?.dispose();
    _numOfGroupsNotifier = null;

    _groupByFieldNotifier?.dispose();
    _groupByFieldNotifier = null;
  }
}
