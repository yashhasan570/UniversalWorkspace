import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// Abstract repository for workspace operations.
///
/// This abstracts the data source for workspace operations,
/// allowing for different implementations (e.g., REST API, gRPC, local storage).
abstract class WorkspaceRepository {
  /// Gets the current workspace for the user.
  Future<UniflowResult<WorkspacePB, UniflowError>> getCurrentWorkspace();

  /// Gets the list of workspaces for the current user.
  Future<UniflowResult<List<UserWorkspacePB>, UniflowError>> getWorkspaces();

  /// Creates a new workspace.
  Future<UniflowResult<UserWorkspacePB, UniflowError>> createWorkspace({
    required String name,
    required WorkspaceTypePB workspaceType,
  });

  /// Deletes a workspace by ID.
  Future<UniflowResult<void, UniflowError>> deleteWorkspace({
    required String workspaceId,
  });

  /// Opens a workspace.
  Future<UniflowResult<void, UniflowError>> openWorkspace({
    required String workspaceId,
    required WorkspaceTypePB workspaceType,
  });

  /// Renames a workspace.
  Future<UniflowResult<void, UniflowError>> renameWorkspace({
    required String workspaceId,
    required String name,
  });

  /// Updates workspace icon.
  Future<UniflowResult<void, UniflowError>> updateWorkspaceIcon({
    required String workspaceId,
    required String icon,
  });

  /// Leaves a workspace.
  Future<UniflowResult<void, UniflowError>> leaveWorkspace({
    required String workspaceId,
  });

  /// Gets workspace subscription information.
  Future<UniflowResult<WorkspaceSubscriptionInfoPB, UniflowError>>
      getWorkspaceSubscriptionInfo({
    required String workspaceId,
  });

  /// Is billing enabled.
  Future<bool> isBillingEnabled();
}
