import 'package:universalworkspace/core/frameless_window.dart';
import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/settings/show_settings.dart';
import 'package:universalworkspace/shared/window_title_bar.dart';
import 'package:universalworkspace/user/application/sign_in_bloc.dart';
import 'package:universalworkspace/user/presentation/screens/sign_in_screen/widgets/anonymous_sign_in_button.dart';
import 'package:universalworkspace/user/presentation/screens/sign_in_screen/widgets/widgets.dart';
import 'package:universalworkspace/user/presentation/widgets/widgets.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class DesktopSignInScreen extends StatefulWidget {
  const DesktopSignInScreen({
    super.key,
  });

  @override
  State<DesktopSignInScreen> createState() => _DesktopSignInScreenState();
}

class _DesktopSignInScreenState extends State<DesktopSignInScreen>
    with WindowListener {
  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);

    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        final bottomPadding = UniversalPlatform.isDesktop ? 20.0 : 24.0;
        return Scaffold(
          appBar: _buildAppBar(),
          body: Center(
            child: AuthFormContainer(
              children: [
                const Spacer(),

                // logo and title
                UniflowLogoTitle(
                  title: LocaleKeys.welcomeText.tr(),
                  logoSize: Size.square(36),
                ),
                VSpace(theme.spacing.xxl),

                // continue with email and password
                isLocalAuthEnabled
                    ? const SignInAnonymousButtonV3()
                    : const ContinueWithEmailAndPassword(),

                VSpace(theme.spacing.xxl),

                // third-party sign in.
                if (isAuthEnabled) ...[
                  const _OrDivider(),
                  VSpace(theme.spacing.xxl),
                  const ThirdPartySignInButtons(),
                  VSpace(theme.spacing.xxl),
                ],

                // sign in agreement
                const SignInAgreement(),

                const Spacer(),

                // anonymous sign in and settings
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DesktopSignInSettingsButton(),
                    HSpace(20),
                    SignInAnonymousButtonV2(),
                  ],
                ),
                VSpace(bottomPadding),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(UniversalPlatform.isWindows ? 40 : 60),
      child: UniversalPlatform.isWindows
          ? const WindowTitleBar()
          : const MoveWindowDetector(),
    );
  }

  @override
  void onWindowFocus() {
    // https://pub.dev/packages/window_manager#windows
    // must call setState once when the window is focused
    setState(() {});
  }
}

class DesktopSignInSettingsButton extends StatelessWidget {
  const DesktopSignInSettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return AFGhostIconTextButton(
      text: LocaleKeys.signIn_settings.tr(),
      textColor: (context, isHovering, disabled) {
        return theme.textColorScheme.secondary;
      },
      size: AFButtonSize.s,
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.m,
        vertical: theme.spacing.xs,
      ),
      onTap: () => showSimpleSettingsDialog(context),
      iconBuilder: (context, isHovering, disabled) {
        return UniflowSvg(
          UniflowSvgs.settings_s,
          size: Size.square(20),
          color: theme.textColorScheme.secondary,
        );
      },
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return Row(
      children: [
        Flexible(
          child: AFDivider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            LocaleKeys.signIn_or.tr(),
            style: theme.textStyle.body.standard(
              color: theme.textColorScheme.secondary,
            ),
          ),
        ),
        Flexible(
          child: AFDivider(),
        ),
      ],
    );
  }
}
