import 'package:universalworkspace/features/workspace/data/repositories/workspace_repository.dart';
import 'package:universalworkspace/user/application/user_service.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/setting_universalworkspace_cloud.dart'
    as billing_service;
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart';

/// Implementation of WorkspaceRepository using UserBackendService.
class RustWorkspaceRepositoryImpl implements WorkspaceRepository {
  RustWorkspaceRepositoryImpl({
    required Int64 userId,
  }) : _userService = UserBackendService(userId: userId);

  final UserBackendService _userService;

  @override
  Future<UniflowResult<WorkspacePB, UniflowError>> getCurrentWorkspace() async {
    return UserBackendService.getCurrentWorkspace();
  }

  @override
  Future<UniflowResult<List<UserWorkspacePB>, UniflowError>> getWorkspaces() async {
    return _userService.getWorkspaces();
  }

  @override
  Future<UniflowResult<UserWorkspacePB, UniflowError>> createWorkspace({
    required String name,
    required WorkspaceTypePB workspaceType,
  }) async {
    return _userService.createUserWorkspace(name, workspaceType);
  }

  @override
  Future<UniflowResult<void, UniflowError>> deleteWorkspace({
    required String workspaceId,
  }) async {
    return _userService.deleteWorkspaceById(workspaceId);
  }

  @override
  Future<UniflowResult<void, UniflowError>> openWorkspace({
    required String workspaceId,
    required WorkspaceTypePB workspaceType,
  }) async {
    return _userService.openWorkspace(workspaceId, workspaceType);
  }

  @override
  Future<UniflowResult<void, UniflowError>> renameWorkspace({
    required String workspaceId,
    required String name,
  }) async {
    return _userService.renameWorkspace(workspaceId, name);
  }

  @override
  Future<UniflowResult<void, UniflowError>> updateWorkspaceIcon({
    required String workspaceId,
    required String icon,
  }) async {
    return _userService.updateWorkspaceIcon(workspaceId, icon);
  }

  @override
  Future<UniflowResult<void, UniflowError>> leaveWorkspace({
    required String workspaceId,
  }) async {
    return _userService.leaveWorkspace(workspaceId);
  }

  @override
  Future<UniflowResult<WorkspaceSubscriptionInfoPB, UniflowError>>
      getWorkspaceSubscriptionInfo({
    required String workspaceId,
  }) async {
    return UserBackendService.getWorkspaceSubscriptionInfo(workspaceId);
  }

  @override
  Future<bool> isBillingEnabled() async {
    return billing_service.isBillingEnabled();
  }
}
