import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/size.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_platform/universal_platform.dart';

class UniflowMessageToast extends StatelessWidget {
  const UniflowMessageToast({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: UniflowText.medium(
          message,
          fontSize: FontSizes.s16,
          maxLines: 3,
        ),
      ),
    );
  }
}

void initToastWithContext(BuildContext context) {
  getIt<FToast>().init(context);
}

void showMessageToast(
  String message, {
  BuildContext? context,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  final child = UniflowMessageToast(message: message);
  final toast = context == null ? getIt<FToast>() : (FToast()..init(context));
  toast.showToast(
    child: child,
    gravity: gravity,
    toastDuration: const Duration(seconds: 3),
  );
}

void showSnackBarMessage(
  BuildContext context,
  String message, {
  bool showCancel = false,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      duration: duration,
      action: !showCancel
          ? null
          : SnackBarAction(
              label: LocaleKeys.button_cancel.tr(),
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
      content: UniflowText(
        message,
        maxLines: 2,
        fontSize: UniversalPlatform.isDesktop ? 14 : 12,
      ),
    ),
  );
}
