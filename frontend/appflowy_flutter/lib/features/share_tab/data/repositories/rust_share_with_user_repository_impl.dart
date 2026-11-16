import 'package:universalworkspace/core/config/kv.dart';
import 'package:universalworkspace/core/config/kv_keys.dart';
import 'package:universalworkspace/features/share_tab/data/models/models.dart';
import 'package:universalworkspace/features/util/extensions.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/application/sidebar/space/space_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/workspace.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:collection/collection.dart';

import 'share_with_user_repository.dart';

class RustShareWithUserRepositoryImpl extends ShareWithUserRepository {
  RustShareWithUserRepositoryImpl();

  @override
  Future<UniflowResult<SharedUsers, UniflowError>> getSharedUsersInPage({
    required String pageId,
  }) async {
    final request = GetSharedUsersPayloadPB(
      viewId: pageId,
    );
    final result = await FolderEventGetSharedUsers(request).send();

    return result.fold(
      (success) {
        Log.debug('get shared users success: $success');

        return UniflowSuccess(success.sharedUsers);
      },
      (failure) {
        Log.error('get shared users failed: $failure');

        return UniflowFailure(failure);
      },
    );
  }

  @override
  Future<UniflowResult<void, UniflowError>> removeSharedUserFromPage({
    required String pageId,
    required List<String> emails,
  }) async {
    final request = RemoveUserFromSharedPagePayloadPB(
      viewId: pageId,
      emails: emails,
    );
    final result = await FolderEventRemoveUserFromSharedPage(request).send();

    return result.fold(
      (success) {
        Log.debug('remove users($emails) from shared page($pageId)');

        return UniflowSuccess(success);
      },
      (failure) {
        Log.error('remove users($emails) from shared page($pageId): $failure');

        return UniflowFailure(failure);
      },
    );
  }

  @override
  Future<UniflowResult<void, UniflowError>> sharePageWithUser({
    required String pageId,
    required ShareAccessLevel accessLevel,
    required List<String> emails,
  }) async {
    final request = SharePageWithUserPayloadPB(
      viewId: pageId,
      emails: emails,
      accessLevel: accessLevel.accessLevel,
      autoConfirm: true,
    );
    final result = await FolderEventSharePageWithUser(request).send();

    return result.fold(
      (success) {
        Log.debug(
          'share page($pageId) with users($emails) with access level($accessLevel)',
        );

        return UniflowSuccess(success);
      },
      (failure) {
        Log.error(
          'share page($pageId) with users($emails) with access level($accessLevel): $failure',
        );

        return UniflowFailure(failure);
      },
    );
  }

  @override
  Future<UniflowResult<SharedUsers, UniflowError>> getAvailableSharedUsers({
    required String pageId,
  }) async {
    return UniflowSuccess([]);
  }

  @override
  Future<UniflowResult<void, UniflowError>> changeRole({
    required String workspaceId,
    required String email,
    required ShareRole role,
  }) async {
    final request = UpdateWorkspaceMemberPB(
      workspaceId: workspaceId,
      email: email,
      role: role.userRole,
    );
    final result = await UserEventUpdateWorkspaceMember(request).send();
    return result.fold(
      (success) {
        Log.debug(
          'change role($role) for user($email) in workspaceId($workspaceId)',
        );
        return UniflowSuccess(success);
      },
      (failure) {
        Log.error(
          'failed to change role($role) for user($email) in workspaceId($workspaceId)',
          failure,
        );
        return UniflowFailure(failure);
      },
    );
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> getCurrentUserProfile() async {
    final result = await UserEventGetUserProfile().send();
    return result;
  }

  @override
  Future<UniflowResult<SharedSectionType, UniflowError>> getCurrentPageSectionType({
    required String pageId,
  }) async {
    final request = ViewIdPB.create()..value = pageId;
    final result = await FolderEventGetViewAncestors(request).send();
    final ancestors = result.fold(
      (s) => s.items,
      (f) => <ViewPB>[],
    );
    final space = ancestors.firstWhereOrNull((e) => e.isSpace);

    if (space == null) {
      return UniflowSuccess(SharedSectionType.unknown);
    }

    final sectionType = switch (space.spacePermission) {
      SpacePermission.publicToAll => SharedSectionType.public,
      SpacePermission.private => SharedSectionType.private,
    };

    return UniflowSuccess(sectionType);
  }

  @override
  Future<bool> getUpgradeToProButtonClicked({
    required String workspaceId,
  }) async {
    final result = await getIt<KeyValueStorage>().getWithFormat(
      '${KVKeys.hasClickedUpgradeToProButton}_$workspaceId',
      (value) => bool.parse(value),
    );
    if (result == null) {
      return false;
    }
    return result;
  }

  @override
  Future<void> setUpgradeToProButtonClicked({
    required String workspaceId,
  }) async {
    await getIt<KeyValueStorage>().set(
      '${KVKeys.hasClickedUpgradeToProButton}_$workspaceId',
      'true',
    );
  }
}
