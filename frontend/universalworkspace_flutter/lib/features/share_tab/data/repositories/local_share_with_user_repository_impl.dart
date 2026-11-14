import 'dart:math';

import 'package:universalworkspace/features/share_tab/data/models/models.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import 'share_with_user_repository.dart';

// Move this file to test folder
class LocalShareWithUserRepositoryImpl extends ShareWithUserRepository {
  LocalShareWithUserRepositoryImpl();

  final SharedUsers _sharedUsers = [
    // current user has full access
    SharedUser(
      email: 'lucas.xu@universalworkspace.io',
      name: 'Lucas Xu - Long long long long long name',
      accessLevel: ShareAccessLevel.readOnly,
      role: ShareRole.guest,
      avatarUrl: 'https://avatar.iran.liara.run/public',
    ),
    // member user has read and write access
    SharedUser(
      email: 'vivian@universalworkspace.io',
      name: 'Vivian Wang',
      accessLevel: ShareAccessLevel.readAndWrite,
      role: ShareRole.member,
      avatarUrl: 'https://avatar.iran.liara.run/public/girl',
    ),
    // member user has read access
    SharedUser(
      email: 'shuheng@universalworkspace.io',
      name: 'Shuheng',
      accessLevel: ShareAccessLevel.readOnly,
      role: ShareRole.member,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy',
    ),
    // guest user has read access
    SharedUser(
      email: 'guest_user_1@universalworkspace.io',
      name: 'Read Only Guest',
      accessLevel: ShareAccessLevel.readOnly,
      role: ShareRole.guest,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy/10',
    ),
    // guest user has read and write access
    SharedUser(
      email: 'guest_user_2@universalworkspace.io',
      name: 'Read And Write Guest',
      accessLevel: ShareAccessLevel.readAndWrite,
      role: ShareRole.guest,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy/11',
    ),
    // Others
    SharedUser(
      email: 'member_user_1@universalworkspace.io',
      name: 'Member User 1',
      accessLevel: ShareAccessLevel.readAndWrite,
      role: ShareRole.member,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy/12',
    ),
    SharedUser(
      email: 'member_user_2@universalworkspace.io',
      name: 'Member User 2',
      accessLevel: ShareAccessLevel.readAndWrite,
      role: ShareRole.member,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy/13',
    ),
  ];

  final SharedUsers _availableSharedUsers = [
    SharedUser(
      email: 'guest_email@universalworkspace.io',
      name: 'Guest',
      accessLevel: ShareAccessLevel.readOnly,
      role: ShareRole.guest,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy/28',
    ),
    SharedUser(
      email: 'richard@universalworkspace.io',
      name: 'Richard',
      accessLevel: ShareAccessLevel.readAndWrite,
      role: ShareRole.member,
      avatarUrl: 'https://avatar.iran.liara.run/public/boy/28',
    ),
  ];

  @override
  Future<UniflowResult<SharedUsers, UniflowError>> getSharedUsersInPage({
    required String pageId,
  }) async {
    return UniflowSuccess(_sharedUsers);
  }

  @override
  Future<UniflowResult<void, UniflowError>> removeSharedUserFromPage({
    required String pageId,
    required List<String> emails,
  }) async {
    for (final email in emails) {
      _sharedUsers.removeWhere((user) => user.email == email);
    }

    return UniflowSuccess(null);
  }

  @override
  Future<UniflowResult<void, UniflowError>> sharePageWithUser({
    required String pageId,
    required ShareAccessLevel accessLevel,
    required List<String> emails,
  }) async {
    for (final email in emails) {
      final index = _sharedUsers.indexWhere((user) => user.email == email);
      if (index != -1) {
        // Update access level if user exists
        final user = _sharedUsers[index];
        _sharedUsers[index] = SharedUser(
          name: user.name,
          email: user.email,
          accessLevel: accessLevel,
          role: user.role,
          avatarUrl: user.avatarUrl,
        );
      } else {
        // Add new user
        _sharedUsers.add(
          SharedUser(
            name: email.split('@').first,
            email: email,
            accessLevel: accessLevel,
            role: ShareRole.guest,
            avatarUrl:
                'https://avatar.iran.liara.run/public/${Random().nextInt(100)}',
          ),
        );
      }
    }

    return UniflowSuccess(null);
  }

  @override
  Future<UniflowResult<SharedUsers, UniflowError>> getAvailableSharedUsers({
    required String pageId,
  }) async {
    return UniflowSuccess([
      ..._sharedUsers,
      ..._availableSharedUsers,
    ]);
  }

  @override
  Future<UniflowResult<void, UniflowError>> changeRole({
    required String workspaceId,
    required String email,
    required ShareRole role,
  }) async {
    final index = _sharedUsers.indexWhere((user) => user.email == email);
    if (index != -1) {
      _sharedUsers[index] = _sharedUsers[index].copyWith(role: role);
    }

    return UniflowSuccess(null);
  }

  @override
  Future<UniflowResult<UserProfilePB, UniflowError>> getCurrentUserProfile() async {
    // Simulate fetching current user profile
    return UniflowSuccess(
      UserProfilePB()
        ..email = 'lucas.xu@universalworkspace.io'
        ..name = 'Lucas Xu',
    );
  }

  @override
  Future<UniflowResult<SharedSectionType, UniflowError>> getCurrentPageSectionType({
    required String pageId,
  }) async {
    return UniflowSuccess(SharedSectionType.private);
  }

  @override
  Future<bool> getUpgradeToProButtonClicked({
    required String workspaceId,
  }) async {
    return false;
  }

  @override
  Future<void> setUpgradeToProButtonClicked({
    required String workspaceId,
  }) async {
    return;
  }
}
