import 'dart:async';

import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/workspace.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart' as fixnum;

class WorkspaceService {
  WorkspaceService({required this.workspaceId, required this.userId});

  final String workspaceId;
  final fixnum.Int64 userId;

  Future<UniflowResult<ViewPB, UniflowError>> createView({
    required String name,
    required ViewSectionPB viewSection,
    int? index,
    ViewLayoutPB? layout,
    bool? setAsCurrent,
    String? viewId,
    String? extra,
  }) {
    final payload = CreateViewPayloadPB.create()
      ..parentViewId = workspaceId
      ..name = name
      ..layout = layout ?? ViewLayoutPB.Document
      ..section = viewSection;

    if (index != null) {
      payload.index = index;
    }

    if (setAsCurrent != null) {
      payload.setAsCurrent = setAsCurrent;
    }

    if (viewId != null) {
      payload.viewId = viewId;
    }

    if (extra != null) {
      payload.extra = extra;
    }

    return FolderEventCreateView(payload).send();
  }

  Future<UniflowResult<WorkspacePB, UniflowError>> getWorkspace() {
    return FolderEventReadCurrentWorkspace().send();
  }

  Future<UniflowResult<List<ViewPB>, UniflowError>> getPublicViews() {
    final payload = GetWorkspaceViewPB.create()..value = workspaceId;
    return FolderEventReadWorkspaceViews(payload).send().then((result) {
      return result.fold(
        (views) => UniflowResult.success(views.items),
        (error) => UniflowResult.failure(error),
      );
    });
  }

  Future<UniflowResult<List<ViewPB>, UniflowError>> getPrivateViews() {
    final payload = GetWorkspaceViewPB.create()..value = workspaceId;
    return FolderEventReadPrivateViews(payload).send().then((result) {
      return result.fold(
        (views) => UniflowResult.success(views.items),
        (error) => UniflowResult.failure(error),
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> moveView({
    required String viewId,
    required int fromIndex,
    required int toIndex,
  }) {
    final payload = MoveViewPayloadPB.create()
      ..viewId = viewId
      ..from = fromIndex
      ..to = toIndex;

    return FolderEventMoveView(payload).send();
  }

  Future<UniflowResult<WorkspaceUsagePB?, UniflowError>> getWorkspaceUsage() async {
    final payload = UserWorkspaceIdPB(workspaceId: workspaceId);
    return UserEventGetWorkspaceUsage(payload).send();
  }

  Future<UniflowResult<BillingPortalPB, UniflowError>> getBillingPortal() {
    return UserEventGetBillingPortal().send();
  }
}
