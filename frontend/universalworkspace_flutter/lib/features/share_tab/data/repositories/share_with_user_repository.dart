import 'package:universalworkspace/features/share_tab/data/models/models.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// Abstract repository for sharing with users.
///
/// For example, we're using rust events now, but we can still use the http api
/// for the future.
abstract class ShareWithUserRepository {
  /// Gets the list of users and their roles for a shared page.
  Future<UniflowResult<SharedUsers, UniflowError>> getSharedUsersInPage({
    required String pageId,
  });

  /// Gets the list of users that are available to be shared with.
  Future<UniflowResult<SharedUsers, UniflowError>> getAvailableSharedUsers({
    required String pageId,
  });

  /// Removes a user from a shared page.
  Future<UniflowResult<void, UniflowError>> removeSharedUserFromPage({
    required String pageId,
    required List<String> emails,
  });

  /// Shares a page with a user, assigning a role.
  ///
  /// If the user is already in the shared page, the access level will be updated.
  Future<UniflowResult<void, UniflowError>> sharePageWithUser({
    required String pageId,
    required ShareAccessLevel accessLevel,
    required List<String> emails,
  });

  /// Change the role of a user in a shared page.
  Future<UniflowResult<void, UniflowError>> changeRole({
    required String workspaceId,
    required String email,
    required ShareRole role,
  });

  /// Get current user profile.
  Future<UniflowResult<UserProfilePB, UniflowError>> getCurrentUserProfile();

  /// Get current page is in public section or private section.
  Future<UniflowResult<SharedSectionType, UniflowError>> getCurrentPageSectionType({
    required String pageId,
  });

  /// Get the upgrade to pro button has been clicked.
  Future<bool> getUpgradeToProButtonClicked({
    required String workspaceId,
  });

  /// Set the upgrade to pro button has been clicked.
  Future<void> setUpgradeToProButtonClicked({
    required String workspaceId,
  });
}
