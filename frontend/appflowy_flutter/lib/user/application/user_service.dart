import 'dart:async';

import 'package:universalworkspace/workspace/application/settings/plan/workspace_subscription_ext.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/workspace.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

abstract class IUserBackendService {
  Future<UniflowResult<void, UniflowError>> cancelSubscription(
    String workspaceId,
    SubscriptionPlanPB plan,
    String? reason,
  );
  Future<UniflowResult<PaymentLinkPB, UniflowError>> createSubscription(
    String workspaceId,
    SubscriptionPlanPB plan,
  );
}

const _baseBetaUrl = 'https://beta.universalworkspace.com';
const _baseProdUrl = 'https://universalworkspace.com';

class UserBackendService implements IUserBackendService {
  UserBackendService({required this.userId});

  final Int64 userId;

  static Future<UniflowResult<UserProfilePB, UniflowError>>
      getCurrentUserProfile() async {
    final result = await UserEventGetUserProfile().send();
    return result;
  }

  Future<UniflowResult<void, UniflowError>> updateUserProfile({
    String? name,
    String? password,
    String? email,
    String? iconUrl,
  }) {
    final payload = UpdateUserProfilePayloadPB.create()..id = userId;

    if (name != null) {
      payload.name = name;
    }

    if (password != null) {
      payload.password = password;
    }

    if (email != null) {
      payload.email = email;
    }

    if (iconUrl != null) {
      payload.iconUrl = iconUrl;
    }

    return UserEventUpdateUserProfile(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> deleteWorkspace({
    required String workspaceId,
  }) {
    throw UnimplementedError();
  }

  static Future<UniflowResult<UserProfilePB, UniflowError>> signInWithMagicLink(
    String email,
    String redirectTo,
  ) async {
    final payload = MagicLinkSignInPB(email: email, redirectTo: redirectTo);
    return UserEventMagicLinkSignIn(payload).send();
  }

  static Future<UniflowResult<GotrueTokenResponsePB, UniflowError>>
      signInWithPasscode(
    String email,
    String passcode,
  ) async {
    final payload = PasscodeSignInPB(email: email, passcode: passcode);
    return UserEventPasscodeSignIn(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> signInWithPassword(
    String email,
    String password,
  ) {
    final payload = SignInPayloadPB(
      email: email,
      password: password,
    );
    return UserEventSignInWithEmailPassword(payload).send();
  }

  static Future<UniflowResult<void, UniflowError>> signOut() {
    return UserEventSignOut().send();
  }

  Future<UniflowResult<void, UniflowError>> initUser() async {
    return UserEventInitUser().send();
  }

  static Future<UniflowResult<UserProfilePB, UniflowError>> getAnonUser() async {
    return UserEventGetAnonUser().send();
  }

  static Future<UniflowResult<void, UniflowError>> openAnonUser() async {
    return UserEventOpenAnonUser().send();
  }

  Future<UniflowResult<List<UserWorkspacePB>, UniflowError>> getWorkspaces() {
    return UserEventGetAllWorkspace().send().then((value) {
      return value.fold(
        (workspaces) => UniflowResult.success(workspaces.items),
        (error) => UniflowResult.failure(error),
      );
    });
  }

  static Future<UniflowResult<UserWorkspacePB, UniflowError>> getWorkspaceById(
    String workspaceId,
  ) async {
    final result = await UserEventGetAllWorkspace().send();
    return result.fold(
      (workspaces) {
        final workspace = workspaces.items.firstWhere(
          (workspace) => workspace.workspaceId == workspaceId,
        );
        return UniflowResult.success(workspace);
      },
      (error) => UniflowResult.failure(error),
    );
  }

  Future<UniflowResult<void, UniflowError>> openWorkspace(
    String workspaceId,
    WorkspaceTypePB workspaceType,
  ) {
    final payload = OpenUserWorkspacePB()
      ..workspaceId = workspaceId
      ..workspaceType = workspaceType;
    return UserEventOpenWorkspace(payload).send();
  }

  static Future<UniflowResult<WorkspacePB, UniflowError>> getCurrentWorkspace() {
    return FolderEventReadCurrentWorkspace().send().then((result) {
      return result.fold(
        (workspace) => UniflowResult.success(workspace),
        (error) => UniflowResult.failure(error),
      );
    });
  }

  Future<UniflowResult<UserWorkspacePB, UniflowError>> createUserWorkspace(
    String name,
    WorkspaceTypePB workspaceType,
  ) {
    final request = CreateWorkspacePB.create()
      ..name = name
      ..workspaceType = workspaceType;
    return UserEventCreateWorkspace(request).send();
  }

  Future<UniflowResult<void, UniflowError>> deleteWorkspaceById(
    String workspaceId,
  ) {
    final request = UserWorkspaceIdPB.create()..workspaceId = workspaceId;
    return UserEventDeleteWorkspace(request).send();
  }

  Future<UniflowResult<void, UniflowError>> renameWorkspace(
    String workspaceId,
    String name,
  ) {
    final request = RenameWorkspacePB()
      ..workspaceId = workspaceId
      ..newName = name;
    return UserEventRenameWorkspace(request).send();
  }

  Future<UniflowResult<void, UniflowError>> updateWorkspaceIcon(
    String workspaceId,
    String icon,
  ) {
    final request = ChangeWorkspaceIconPB()
      ..workspaceId = workspaceId
      ..newIcon = icon;
    return UserEventChangeWorkspaceIcon(request).send();
  }

  Future<UniflowResult<RepeatedWorkspaceMemberPB, UniflowError>>
      getWorkspaceMembers(
    String workspaceId,
  ) async {
    final data = QueryWorkspacePB()..workspaceId = workspaceId;
    return UserEventGetWorkspaceMembers(data).send();
  }

  Future<UniflowResult<void, UniflowError>> addWorkspaceMember(
    String workspaceId,
    String email,
  ) async {
    final data = AddWorkspaceMemberPB()
      ..workspaceId = workspaceId
      ..email = email;
    return UserEventAddWorkspaceMember(data).send();
  }

  Future<UniflowResult<void, UniflowError>> inviteWorkspaceMember(
    String workspaceId,
    String email, {
    AFRolePB? role,
  }) async {
    final data = WorkspaceMemberInvitationPB()
      ..workspaceId = workspaceId
      ..inviteeEmail = email;
    if (role != null) {
      data.role = role;
    }
    return UserEventInviteWorkspaceMember(data).send();
  }

  Future<UniflowResult<void, UniflowError>> removeWorkspaceMember(
    String workspaceId,
    String email,
  ) async {
    final data = RemoveWorkspaceMemberPB()
      ..workspaceId = workspaceId
      ..email = email;
    return UserEventRemoveWorkspaceMember(data).send();
  }

  Future<UniflowResult<void, UniflowError>> updateWorkspaceMember(
    String workspaceId,
    String email,
    AFRolePB role,
  ) async {
    final data = UpdateWorkspaceMemberPB()
      ..workspaceId = workspaceId
      ..email = email
      ..role = role;
    return UserEventUpdateWorkspaceMember(data).send();
  }

  Future<UniflowResult<void, UniflowError>> leaveWorkspace(
    String workspaceId,
  ) async {
    final data = UserWorkspaceIdPB.create()..workspaceId = workspaceId;
    return UserEventLeaveWorkspace(data).send();
  }

  static Future<UniflowResult<WorkspaceSubscriptionInfoPB, UniflowError>>
      getWorkspaceSubscriptionInfo(String workspaceId) {
    final params = UserWorkspaceIdPB.create()..workspaceId = workspaceId;
    return UserEventGetWorkspaceSubscriptionInfo(params).send();
  }

  @override
  Future<UniflowResult<PaymentLinkPB, UniflowError>> createSubscription(
    String workspaceId,
    SubscriptionPlanPB plan,
  ) {
    final request = SubscribeWorkspacePB()
      ..workspaceId = workspaceId
      ..recurringInterval = RecurringIntervalPB.Year
      ..workspaceSubscriptionPlan = plan
      ..successUrl =
          '${kDebugMode ? _baseBetaUrl : _baseProdUrl}/after-payment?plan=${plan.toRecognizable()}';
    return UserEventSubscribeWorkspace(request).send();
  }

  @override
  Future<UniflowResult<void, UniflowError>> cancelSubscription(
    String workspaceId,
    SubscriptionPlanPB plan, [
    String? reason,
  ]) {
    final request = CancelWorkspaceSubscriptionPB()
      ..workspaceId = workspaceId
      ..plan = plan;

    if (reason != null) {
      request.reason = reason;
    }

    return UserEventCancelWorkspaceSubscription(request).send();
  }

  Future<UniflowResult<void, UniflowError>> updateSubscriptionPeriod(
    String workspaceId,
    SubscriptionPlanPB plan,
    RecurringIntervalPB interval,
  ) {
    final request = UpdateWorkspaceSubscriptionPaymentPeriodPB()
      ..workspaceId = workspaceId
      ..plan = plan
      ..recurringInterval = interval;

    return UserEventUpdateWorkspaceSubscriptionPaymentPeriod(request).send();
  }

  // NOTE: This function is irreversible and will delete the current user's account.
  static Future<UniflowResult<void, UniflowError>> deleteCurrentAccount() {
    return UserEventDeleteAccount().send();
  }
}
