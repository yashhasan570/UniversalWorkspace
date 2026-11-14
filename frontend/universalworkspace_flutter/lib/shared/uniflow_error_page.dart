import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/animated_gesture.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/copy_and_paste/clipboard_service.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class UniversalWorkspaceErrorPage extends StatelessWidget {
  const UniversalWorkspaceErrorPage({
    super.key,
    this.error,
  });

  final UniflowError? error;

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isMobile) {
      return _MobileSyncErrorPage(error: error);
    } else {
      return _DesktopSyncErrorPage(error: error);
    }
  }
}

class _MobileSyncErrorPage extends StatelessWidget {
  const _MobileSyncErrorPage({
    this.error,
  });

  final UniflowError? error;

  @override
  Widget build(BuildContext context) {
    return AnimatedGestureDetector(
      scaleFactor: 0.99,
      onTapUp: () {
        getIt<ClipboardService>().setPlainText(error.toString());
        showToastNotification(
          message: LocaleKeys.message_copy_success.tr(),
          bottomPadding: 0,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UniflowSvg(
            UniflowSvgs.icon_warning_xl,
            blendMode: null,
          ),
          const VSpace(16.0),
          UniflowText.medium(
            LocaleKeys.error_syncError.tr(),
            fontSize: 15,
          ),
          const VSpace(8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: UniflowText.regular(
              LocaleKeys.error_syncErrorHint.tr(),
              fontSize: 13,
              color: Theme.of(context).hintColor,
              textAlign: TextAlign.center,
              maxLines: 10,
            ),
          ),
          const VSpace(2.0),
          UniflowText.regular(
            '(${LocaleKeys.error_clickToCopy.tr()})',
            fontSize: 13,
            color: Theme.of(context).hintColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DesktopSyncErrorPage extends StatelessWidget {
  const _DesktopSyncErrorPage({
    this.error,
  });

  final UniflowError? error;

  @override
  Widget build(BuildContext context) {
    return AnimatedGestureDetector(
      scaleFactor: 0.995,
      onTapUp: () {
        getIt<ClipboardService>().setPlainText(error.toString());
        showToastNotification(
          message: LocaleKeys.message_copy_success.tr(),
          bottomPadding: 0,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UniflowSvg(
            UniflowSvgs.icon_warning_xl,
            blendMode: null,
          ),
          const VSpace(16.0),
          UniflowText.medium(
            error?.code.toString() ?? '',
            fontSize: 16,
          ),
          const VSpace(8.0),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.errorDialog_howToFixFallbackHint1.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                TextSpan(
                  text: 'Github',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      afLaunchUrlString(
                        'https://github.com/yashhasan570/UniversalWorkspace/issues/new?template=bug_report.yaml',
                      );
                    },
                ),
                TextSpan(
                  text: LocaleKeys.errorDialog_howToFixFallbackHint2.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          const VSpace(8.0),
          UniflowText.regular(
            '(${LocaleKeys.error_clickToCopy.tr()})',
            fontSize: 14,
            color: Theme.of(context).hintColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
