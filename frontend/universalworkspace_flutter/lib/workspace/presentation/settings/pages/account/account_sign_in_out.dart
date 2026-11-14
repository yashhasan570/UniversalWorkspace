import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/application/password/password_bloc.dart';
import 'package:universalworkspace/user/application/prelude.dart';
import 'package:universalworkspace/user/presentation/screens/sign_in_screen/widgets/continue_with/continue_with_email_and_password.dart';
import 'package:universalworkspace/util/navigator_context_extension.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/account/password/change_password.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/account/password/setup_password.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/setting_third_party_login.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSignInOutSection extends StatelessWidget {
  const AccountSignInOutSection({
    super.key,
    required this.userProfile,
    required this.onAction,
    this.signIn = true,
  });

  final UserProfilePB userProfile;
  final VoidCallback onAction;
  final bool signIn;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Row(
      children: [
        Text(
          LocaleKeys.settings_accountPage_login_title.tr(),
          style: theme.textStyle.body.enhanced(
            color: theme.textColorScheme.primary,
          ),
        ),
        const Spacer(),
        AccountSignInOutButton(
          userProfile: userProfile,
          onAction: onAction,
          signIn: signIn,
        ),
      ],
    );
  }
}

class AccountSignInOutButton extends StatelessWidget {
  const AccountSignInOutButton({
    super.key,
    required this.userProfile,
    required this.onAction,
    this.signIn = true,
  });

  final UserProfilePB userProfile;
  final VoidCallback onAction;
  final bool signIn;

  @override
  Widget build(BuildContext context) {
    return AFFilledTextButton.primary(
      text: signIn
          ? LocaleKeys.settings_accountPage_login_loginLabel.tr()
          : LocaleKeys.settings_accountPage_login_logoutLabel.tr(),
      onTap: () =>
          signIn ? _showSignInDialog(context) : _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCancelAndConfirmDialog(
      context: context,
      title: LocaleKeys.settings_accountPage_login_logoutLabel.tr(),
      description: LocaleKeys.settings_menu_logoutPrompt.tr(),
      confirmLabel: LocaleKeys.button_yes.tr(),
      onConfirm: (_) async {
        await getIt<AuthService>().signOut();
        onAction();
      },
    );
  }

  Future<void> _showSignInDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => BlocProvider<SignInBloc>(
        create: (context) => getIt<SignInBloc>(),
        child: const UniflowDialog(
          constraints: BoxConstraints(maxHeight: 485, maxWidth: 375),
          child: _SignInDialogContent(),
        ),
      ),
    );
  }
}

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({
    super.key,
    required this.userProfile,
  });

  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return BlocBuilder<PasswordBloc, PasswordState>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              LocaleKeys.newSettings_myAccount_password_title.tr(),
              style: theme.textStyle.body.enhanced(
                color: theme.textColorScheme.primary,
              ),
            ),
            const Spacer(),
            state.hasPassword
                ? AFFilledTextButton.primary(
                    text: LocaleKeys
                        .newSettings_myAccount_password_changePassword
                        .tr(),
                    onTap: () => _showChangePasswordDialog(context),
                  )
                : AFFilledTextButton.primary(
                    text: LocaleKeys
                        .newSettings_myAccount_password_setupPassword
                        .tr(),
                    onTap: () => _showSetPasswordDialog(context),
                  ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final theme = UniversalWorkspaceTheme.of(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<PasswordBloc>.value(
            value: context.read<PasswordBloc>(),
          ),
          BlocProvider<SignInBloc>.value(
            value: getIt<SignInBloc>(),
          ),
        ],
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(theme.borderRadius.xl),
          ),
          child: ChangePasswordDialogContent(
            userProfile: userProfile,
          ),
        ),
      ),
    );
  }

  Future<void> _showSetPasswordDialog(BuildContext context) async {
    final theme = UniversalWorkspaceTheme.of(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<PasswordBloc>.value(
            value: context.read<PasswordBloc>(),
          ),
          BlocProvider<SignInBloc>.value(
            value: getIt<SignInBloc>(),
          ),
        ],
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(theme.borderRadius.xl),
          ),
          child: SetupPasswordDialogContent(
            userProfile: userProfile,
          ),
        ),
      ),
    );
  }
}

class _SignInDialogContent extends StatelessWidget {
  const _SignInDialogContent();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _DialogHeader(),
                const _DialogTitle(),
                const VSpace(16),
                const ContinueWithEmailAndPassword(),
                if (isAuthEnabled) ...[
                  const VSpace(20),
                  const _OrDivider(),
                  const VSpace(10),
                  SettingThirdPartyLogin(
                    didLogin: () {
                      context.popToHome();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(context),
        _buildCloseButton(context),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            const UniflowSvg(UniflowSvgs.arrow_back_m, size: Size.square(24)),
            const HSpace(8),
            UniflowText.semibold(LocaleKeys.button_back.tr(), fontSize: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: UniflowSvg(
          UniflowSvgs.m_close_m,
          size: const Size.square(20),
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: UniflowText.medium(
            LocaleKeys.settings_accountPage_login_loginLabel.tr(),
            fontSize: 22,
            color: Theme.of(context).colorScheme.tertiary,
            maxLines: null,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: UniflowText.regular(LocaleKeys.signIn_or.tr()),
        ),
        const Flexible(child: Divider(thickness: 1)),
      ],
    );
  }
}
