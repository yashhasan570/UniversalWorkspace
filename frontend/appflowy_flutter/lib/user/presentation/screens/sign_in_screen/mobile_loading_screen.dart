import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar.dart';
import 'package:universalworkspace/user/application/sign_in_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileLoadingScreen extends StatelessWidget {
  const MobileLoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;

    return Scaffold(
      appBar: UniflowAppBar(
        showDivider: false,
        onTapLeading: () => context.read<SignInBloc>().add(
              const SignInEvent.cancel(),
            ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UniflowText(LocaleKeys.signIn_signingInText.tr()),
            const VSpace(spacing),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
