import 'package:universalworkspace/startup/plugin/plugin.dart';
import 'package:universalworkspace/workspace/application/view/view_listener.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:flutter/material.dart';

class ViewPluginNotifier extends PluginNotifier<DeletedViewPB?> {
  ViewPluginNotifier({
    required this.view,
  }) : _viewListener = ViewListener(viewId: view.id) {
    _viewListener?.start(
      onViewUpdated: (updatedView) => view = updatedView,
      onViewMoveToTrash: (result) => result.fold(
        (deletedView) => isDeleted.value = deletedView,
        (err) => Log.error(err),
      ),
    );
  }

  ViewPB view;
  final ViewListener? _viewListener;

  @override
  final ValueNotifier<DeletedViewPB?> isDeleted = ValueNotifier(null);

  @override
  void dispose() {
    isDeleted.dispose();
    _viewListener?.stop();
  }
}
