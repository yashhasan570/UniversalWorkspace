import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/anon_user_bloc.dart';
import 'package:universalworkspace/user/application/sign_in_bloc.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInAnonymousButtonV2 extends StatelessWidget {
  const SignInAnonymousButtonV2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, signInState) {
        return BlocProvider(
          create: (context) => AnonUserBloc()
            ..add(
              const AnonUserEvent.initial(),
            ),
          child: BlocListener<AnonUserBloc, AnonUserState>(
            listener: (context, state) async {
              if (state.openedAnonUser != null) {
                await runUniversalWorkspace();
              }
            },
            child: BlocBuilder<AnonUserBloc, AnonUserState>(
              builder: (context, state) {
                final theme = UniversalWorkspaceTheme.of(context);
                final onTap = state.anonUsers.isEmpty
                    ? () {
                        context
                            .read<SignInBloc>()
                            .add(const SignInEvent.signInAsGuest());
                      }
                    : () {
                        final bloc = context.read<AnonUserBloc>();
                        final user = bloc.state.anonUsers.first;
                        bloc.add(AnonUserEvent.openAnonUser(user));
                      };
                return AFGhostIconTextButton(
                  text: LocaleKeys.signIn_anonymousMode.tr(),
                  textColor: (context, isHovering, disabled) {
                    return theme.textColorScheme.secondary;
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.m,
                    vertical: theme.spacing.xs,
                  ),
                  size: AFButtonSize.s,
                  onTap: onTap,
                  iconBuilder: (context, isHovering, disabled) {
                    return UniflowSvg(
                      UniflowSvgs.anonymous_mode_m,
                      color: theme.textColorScheme.secondary,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ChangeCloudModeButton extends StatelessWidget {
  const ChangeCloudModeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    return AFGhostIconTextButton(
      text: LocaleKeys.signIn_switchToUniversalWorkspaceCloud.tr(),
      textColor: (context, isHovering, disabled) {
        return theme.textColorScheme.secondary;
      },
      size: AFButtonSize.s,
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.m,
        vertical: theme.spacing.xs,
      ),
      onTap: () async {
        await useUniversalWorkspaceBetaCloudWithURL(
          kUniversalWorkspaceCloudUrl,
          AuthenticatorType.universalworkspaceCloud,
        );
        await runUniversalWorkspace();
      },
      iconBuilder: (context, isHovering, disabled) {
        return UniflowSvg(
          UniflowSvgs.cloud_mode_m,
          size: Size.square(20),
          color: theme.textColorScheme.secondary,
        );
      },
    );
  }
}
