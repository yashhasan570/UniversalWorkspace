import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/user/application/sign_in_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwitchSignInSignUpButton extends StatelessWidget {
  const SwitchSignInSignUpButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UniflowText(
                  switch (state.loginType) {
                    LoginType.signIn =>
                      LocaleKeys.signIn_dontHaveAnAccount.tr(),
                    LoginType.signUp =>
                      LocaleKeys.signIn_alreadyHaveAnAccount.tr(),
                  },
                  fontSize: 12,
                ),
                const HSpace(4),
                UniflowText(
                  switch (state.loginType) {
                    LoginType.signIn => LocaleKeys.signIn_createAccount.tr(),
                    LoginType.signUp => LocaleKeys.signIn_logIn.tr(),
                  },
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
