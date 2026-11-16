import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/copy_and_paste/clipboard_service.dart';
import 'package:universalworkspace/plugins/shared/share/share_bloc.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';

class ShareTab extends StatelessWidget {
  const ShareTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        VSpace(18),
        _ShareTabHeader(),
        VSpace(2),
        _ShareTabDescription(),
        VSpace(14),
        _ShareTabContent(),
      ],
    );
  }
}

class _ShareTabHeader extends StatelessWidget {
  const _ShareTabHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const UniflowSvg(UniflowSvgs.share_tab_icon_s),
        const HSpace(6),
        UniflowText.medium(
          LocaleKeys.shareAction_shareTabTitle.tr(),
          figmaLineHeight: 18.0,
        ),
      ],
    );
  }
}

class _ShareTabDescription extends StatelessWidget {
  const _ShareTabDescription();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: UniflowText.regular(
        LocaleKeys.shareAction_shareTabDescription.tr(),
        fontSize: 13.0,
        figmaLineHeight: 18.0,
        color: Theme.of(context).hintColor,
      ),
    );
  }
}

class _ShareTabContent extends StatelessWidget {
  const _ShareTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareBloc, ShareState>(
      builder: (context, state) {
        final shareUrl = ShareConstants.buildShareUrl(
          workspaceId: state.workspaceId,
          viewId: state.viewId,
        );
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 36,
                child: UniflowTextField(
                  text: shareUrl, // todo: add workspace id + view id
                  readOnly: true,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const HSpace(8.0),
            PrimaryRoundedButton(
              margin: const EdgeInsets.symmetric(
                vertical: 9.0,
                horizontal: 14.0,
              ),
              text: LocaleKeys.button_copyLink.tr(),
              figmaLineHeight: 18.0,
              leftIcon: UniflowSvg(
                UniflowSvgs.share_tab_copy_s,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onTap: () => _copy(context, shareUrl),
            ),
          ],
        );
      },
    );
  }

  void _copy(BuildContext context, String url) {
    getIt<ClipboardService>().setData(
      ClipboardServiceData(plainText: url),
    );

    showToastNotification(
      message: LocaleKeys.message_copy_success.tr(),
    );
  }
}
