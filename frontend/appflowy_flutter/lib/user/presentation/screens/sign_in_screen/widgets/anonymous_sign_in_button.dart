import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/anon_user_bloc.dart';
import 'package:universalworkspace/user/application/sign_in_bloc.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInAnonymousButtonV3 extends StatelessWidget {
  const SignInAnonymousButtonV3({
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
                final text = LocaleKeys.signIn_continueWithLocalModel.tr();
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
                return AFFilledTextButton.primary(
                  text: text,
                  size: AFButtonSize.l,
                  alignment: Alignment.center,
                  onTap: onTap,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
