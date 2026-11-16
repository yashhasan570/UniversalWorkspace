import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/folder_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart'
    show UserProfilePB;
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef SectionNotifyValue = UniflowResult<SectionViewsPB, UniflowError>;

/// The [WorkspaceSectionsListener] listens to the changes including the below:
///
/// - The root views inside different section of the workspace. (Not including the views are inside the root views)
///   depends on the section type(s).
class WorkspaceSectionsListener {
  WorkspaceSectionsListener({
    required this.user,
    required this.workspaceId,
  });

  final UserProfilePB user;
  final String workspaceId;

  final _sectionNotifier = PublishNotifier<SectionNotifyValue>();
  late final FolderNotificationListener _listener;

  void start({
    void Function(SectionNotifyValue)? sectionChanged,
  }) {
    if (sectionChanged != null) {
      _sectionNotifier.addPublishListener(sectionChanged);
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
      case FolderNotification.DidUpdateSectionViews:
        final UniflowResult<SectionViewsPB, UniflowError> value = result.fold(
          (s) => UniflowResult.success(
            SectionViewsPB.fromBuffer(s),
          ),
          (f) => UniflowResult.failure(f),
        );
        _sectionNotifier.value = value;
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    _sectionNotifier.dispose();

    await _listener.stop();
  }
}
