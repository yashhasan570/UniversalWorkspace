import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';

class NotificationHubTitle extends StatelessWidget {
  const NotificationHubTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16) +
          const EdgeInsets.only(top: 12, bottom: 4),
      child: UniflowText.semibold(
        LocaleKeys.notificationHub_title.tr(),
        color: Theme.of(context).colorScheme.tertiary,
        fontSize: 16,
      ),
    );
  }
}
