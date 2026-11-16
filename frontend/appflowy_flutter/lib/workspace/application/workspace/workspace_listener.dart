import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/folder_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/workspace.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart'
    show UserProfilePB;
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef RootViewsNotifyValue = UniflowResult<List<ViewPB>, UniflowError>;
typedef WorkspaceNotifyValue = UniflowResult<WorkspacePB, UniflowError>;

/// The [WorkspaceListener] listens to the changes including the below:
///
/// - The root views of the workspace. (Not including the views are inside the root views)
/// - The workspace itself.
class WorkspaceListener {
  WorkspaceListener({required this.user, required this.workspaceId});

  final UserProfilePB user;
  final String workspaceId;

  PublishNotifier<RootViewsNotifyValue>? _appsChangedNotifier =
      PublishNotifier();
  PublishNotifier<WorkspaceNotifyValue>? _workspaceUpdatedNotifier =
      PublishNotifier();

  FolderNotificationListener? _listener;

  void start({
    void Function(RootViewsNotifyValue)? appsChanged,
    void Function(WorkspaceNotifyValue)? onWorkspaceUpdated,
  }) {
    if (appsChanged != null) {
      _appsChangedNotifier?.addPublishListener(appsChanged);
    }

    if (onWorkspaceUpdated != null) {
      _workspaceUpdatedNotifier?.addPublishListener(onWorkspaceUpdated);
    }

    _listener = FolderNotificationListener(
      objectId: workspaceId,
      handler: _handleObservableType,
    );
  }

  void _handleObservableType(
    FolderNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case FolderNotification.DidUpdateWorkspace:
        result.fold(
          (payload) => _workspaceUpdatedNotifier?.value =
              UniflowResult.success(WorkspacePB.fromBuffer(payload)),
          (error) =>
              _workspaceUpdatedNotifier?.value = UniflowResult.failure(error),
        );
        break;
      case FolderNotification.DidUpdateWorkspaceViews:
        result.fold(
          (payload) => _appsChangedNotifier?.value =
              UniflowResult.success(RepeatedViewPB.fromBuffer(payload).items),
          (error) => _appsChangedNotifier?.value = UniflowResult.failure(error),
        );
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _appsChangedNotifier?.dispose();
    _appsChangedNotifier = null;

    _workspaceUpdatedNotifier?.dispose();
    _workspaceUpdatedNotifier = null;
  }
}
