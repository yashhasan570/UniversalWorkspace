import 'package:universalworkspace/user/presentation/screens/sign_in_screen/widgets/logo/logo.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class UniflowLogoTitle extends StatelessWidget {
  const UniflowLogoTitle({
    super.key,
    required this.title,
    this.logoSize = const Size.square(40),
  });

  final String title;
  final Size logoSize;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AFLogo(size: logoSize),
          const VSpace(20),
          Text(
            title,
            style: theme.textStyle.heading3.enhanced(
              color: theme.textColorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
