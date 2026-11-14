import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/sign_in_bloc.dart';
import 'package:universalworkspace/user/presentation/screens/sign_in_screen/widgets/widgets.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:uniflow_infra_ui/style_widget/snap_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingThirdPartyLogin extends StatelessWidget {
  const SettingThirdPartyLogin({
    super.key,
    required this.didLogin,
  });

  final VoidCallback didLogin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInBloc>(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          final successOrFail = state.successOrFail;
          if (successOrFail != null) {
            _handleSuccessOrFail(successOrFail, context);
          }
        },
        builder: (_, state) {
          final indicator = state.isSubmitting
              ? const LinearProgressIndicator(minHeight: 1)
              : const SizedBox.shrink();

          final promptMessage = state.isSubmitting
              ? UniflowText.medium(
                  LocaleKeys.signIn_syncPromptMessage.tr(),
                  maxLines: null,
                )
              : const SizedBox.shrink();

          return Column(
            children: [
              promptMessage,
              const VSpace(6),
              indicator,
              const VSpace(6),
              if (isAuthEnabled) const ThirdPartySignInButtons(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleSuccessOrFail(
    UniflowResult<UserProfilePB, UniflowError> result,
    BuildContext context,
  ) async {
    result.fold(
      (user) async {
        didLogin();
        await runUniversalWorkspace();
      },
      (error) => showSnapBar(context, error.msg),
    );
  }
}
