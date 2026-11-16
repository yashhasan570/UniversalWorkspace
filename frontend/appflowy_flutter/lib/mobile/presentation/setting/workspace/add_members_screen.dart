import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar.dart';
import 'package:universalworkspace/mobile/presentation/widgets/show_uniflow_mobile_confirm_dialog.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/copy_and_paste/clipboard_service.dart';
import 'package:universalworkspace/shared/af_role_pb_extension.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/user_service.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/members/invitation/m_invite_member_by_email.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/members/workspace_member_bloc.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/code.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'member_list.dart';

class AddMembersScreen extends StatelessWidget {
  const AddMembersScreen({
    super.key,
  });

  static const routeName = '/add_member';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniflowAppBar(
        titleText: 'Add members',
      ),
      body: const _InviteMemberPage(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class _InviteMemberPage extends StatefulWidget {
  const _InviteMemberPage();

  @override
  State<_InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<_InviteMemberPage> {
  final emailController = TextEditingController();
  late final Future<UserProfilePB?> userProfile;
  bool exceededLimit = false;

  @override
  void initState() {
    super.initState();
    userProfile = UserBackendService.getCurrentUserProfile().fold(
      (s) => s,
      (f) => null,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return FutureBuilder(
      future: userProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _buildError(context);
        }

        final userProfile = snapshot.data!;

        return BlocProvider<WorkspaceMemberBloc>(
          create: (context) => WorkspaceMemberBloc(userProfile: userProfile)
            ..add(const WorkspaceMemberEvent.initial())
            ..add(const WorkspaceMemberEvent.getInviteCode()),
          child: BlocConsumer<WorkspaceMemberBloc, WorkspaceMemberState>(
            listener: _onListener,
            builder: (context, state) {
              return Column(
                children: [
                  if (state.myRole.isOwner) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(theme.spacing.xl),
                      child: const MInviteMemberByEmail(),
                    ),
                    VSpace(theme.spacing.m),
                  ],
                  if (state.members.isNotEmpty) ...[
                    const AFDivider(),
                    VSpace(theme.spacing.xl),
                    MobileMemberList(
                      members: state.members,
                      userProfile: userProfile,
                      myRole: state.myRole,
                    ),
                  ],
                  if (state.myRole.isMember) ...[
                    Spacer(),
                    const _LeaveWorkspaceButton(),
                  ],
                  const VSpace(48),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UniflowText.medium(
              LocaleKeys.settings_appearance_members_workspaceMembersError.tr(),
              fontSize: 18.0,
              textAlign: TextAlign.center,
            ),
            const VSpace(8.0),
            UniflowText.regular(
              LocaleKeys
                  .settings_appearance_members_workspaceMembersErrorDescription
                  .tr(),
              fontSize: 17.0,
              maxLines: 10,
              textAlign: TextAlign.center,
              lineHeight: 1.3,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }

  void _onListener(BuildContext context, WorkspaceMemberState state) {
    final actionResult = state.actionResult;
    if (actionResult == null) {
      return;
    }

    final actionType = actionResult.actionType;
    final result = actionResult.result;

    // only show the result dialog when the action is WorkspaceMemberActionType.add
    if (actionType == WorkspaceMemberActionType.addByEmail) {
      result.fold(
        (s) {
          showToastNotification(
            message:
                LocaleKeys.settings_appearance_members_addMemberSuccess.tr(),
          );
        },
        (f) {
          Log.error('add workspace member failed: $f');
          final message = f.code == ErrorCode.WorkspaceMemberLimitExceeded
              ? LocaleKeys
                  .settings_appearance_members_inviteFailedMemberLimitMobile
                  .tr()
              : LocaleKeys.settings_appearance_members_failedToAddMember.tr();
          setState(() {
            exceededLimit = f.code == ErrorCode.WorkspaceMemberLimitExceeded;
          });
          showToastNotification(
            type: ToastificationType.error,
            message: message,
          );
        },
      );
    } else if (actionType == WorkspaceMemberActionType.inviteByEmail) {
      result.fold(
        (s) {
          showToastNotification(
            message:
                LocaleKeys.settings_appearance_members_inviteMemberSuccess.tr(),
          );
        },
        (f) {
          Log.error('invite workspace member failed: $f');
          final message = f.code == ErrorCode.WorkspaceMemberLimitExceeded
              ? LocaleKeys
                  .settings_appearance_members_inviteFailedMemberLimitMobile
                  .tr()
              : LocaleKeys.settings_appearance_members_failedToInviteMember
                  .tr();
          setState(() {
            exceededLimit = f.code == ErrorCode.WorkspaceMemberLimitExceeded;
          });
          showToastNotification(
            type: ToastificationType.error,
            message: message,
          );
        },
      );
    } else if (actionType == WorkspaceMemberActionType.removeByEmail) {
      result.fold(
        (s) {
          showToastNotification(
            message: LocaleKeys
                .settings_appearance_members_removeFromWorkspaceSuccess
                .tr(),
          );
        },
        (f) {
          showToastNotification(
            type: ToastificationType.error,
            message: LocaleKeys
                .settings_appearance_members_removeFromWorkspaceFailed
                .tr(),
          );
        },
      );
    } else if (actionType == WorkspaceMemberActionType.generateInviteLink) {
      result.fold(
        (s) async {
          showToastNotification(
            message: LocaleKeys
                .settings_appearance_members_generatedLinkSuccessfully
                .tr(),
          );

          // copy the invite link to the clipboard
          final inviteLink = state.inviteLink;
          if (inviteLink != null) {
            await getIt<ClipboardService>().setPlainText(inviteLink);
            showToastNotification(
              message: LocaleKeys.shareAction_copyLinkSuccess.tr(),
            );
          }
        },
        (f) {
          Log.error('generate invite link failed: $f');
          showToastNotification(
            type: ToastificationType.error,
            message:
                LocaleKeys.settings_appearance_members_generatedLinkFailed.tr(),
          );
        },
      );
    } else if (actionType == WorkspaceMemberActionType.resetInviteLink) {
      result.fold(
        (s) async {
          showToastNotification(
            message: LocaleKeys
                .settings_appearance_members_resetLinkSuccessfully
                .tr(),
          );

          // copy the invite link to the clipboard
          final inviteLink = state.inviteLink;
          if (inviteLink != null) {
            await getIt<ClipboardService>().setPlainText(inviteLink);
            showToastNotification(
              message: LocaleKeys.shareAction_copyLinkSuccess.tr(),
            );
          }
        },
        (f) {
          Log.error('generate invite link failed: $f');
          showToastNotification(
            type: ToastificationType.error,
            message:
                LocaleKeys.settings_appearance_members_resetLinkFailed.tr(),
          );
        },
      );
    }
  }
}

class _LeaveWorkspaceButton extends StatelessWidget {
  const _LeaveWorkspaceButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AFOutlinedTextButton.destructive(
        alignment: Alignment.center,
        text: LocaleKeys.workspace_leaveCurrentWorkspace.tr(),
        onTap: () => _leaveWorkspace(context),
        size: AFButtonSize.l,
      ),
    );
  }

  void _leaveWorkspace(BuildContext context) {
    showUniflowCupertinoConfirmDialog(
      title: LocaleKeys.workspace_leaveCurrentWorkspacePrompt.tr(),
      leftButton: UniflowText(
        LocaleKeys.button_cancel.tr(),
        fontSize: 17.0,
        figmaLineHeight: 24.0,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF007AFF),
      ),
      rightButton: UniflowText(
        LocaleKeys.button_confirm.tr(),
        fontSize: 17.0,
        figmaLineHeight: 24.0,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFFE0220),
      ),
      onRightButtonPressed: (buttonContext) async {},
    );
  }
}
