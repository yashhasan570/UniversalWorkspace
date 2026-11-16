import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/shared/share/constants.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/util/navigator_context_extension.dart';
import 'package:universalworkspace/workspace/application/action_navigation/action_navigation_bloc.dart';
import 'package:universalworkspace/workspace/application/action_navigation/navigation_action.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/sites/constants.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/sites/publish_info_view_item.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/sites/published_page/published_view_more_action.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class PublishedViewItem extends StatelessWidget {
  const PublishedViewItem({
    super.key,
    required this.publishInfoView,
  });

  final PublishInfoViewPB publishInfoView;

  @override
  Widget build(BuildContext context) {
    final flexes = SettingsPageSitesConstants.publishedViewItemFlexes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Published page name
        Expanded(
          flex: flexes[0],
          child: _buildPublishedPageName(context),
        ),

        // Published Name
        Expanded(
          flex: flexes[1],
          child: _buildPublishedName(context),
        ),

        // Published at
        Expanded(
          flex: flexes[2],
          child: Padding(
            padding: const EdgeInsets.only(
              left: SettingsPageSitesConstants.alignPadding,
            ),
            child: _buildPublishedAt(context),
          ),
        ),

        // More actions
        PublishedViewMoreAction(
          publishInfoView: publishInfoView,
        ),
      ],
    );
  }

  Widget _buildPublishedPageName(BuildContext context) {
    return PublishInfoViewItem(
      extraTooltipMessage:
          LocaleKeys.settings_sites_publishedPage_clickToOpenPageInApp.tr(),
      publishInfoView: publishInfoView,
      onTap: () {
        context.popToHome();

        getIt<ActionNavigationBloc>().add(
          ActionNavigationEvent.performAction(
            action: NavigationAction(
              objectId: publishInfoView.view.viewId,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPublishedAt(BuildContext context) {
    final formattedDate = SettingsPageSitesConstants.dateFormat.format(
      DateTime.fromMillisecondsSinceEpoch(
        publishInfoView.info.publishTimestampSec.toInt() * 1000,
      ),
    );
    return UniflowText(
      formattedDate,
      fontSize: 14.0,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPublishedName(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 48.0),
      child: UniflowButton(
        useIntrinsicWidth: true,
        onTap: () {
          final url = ShareConstants.buildPublishUrl(
            nameSpace: publishInfoView.info.namespace,
            publishName: publishInfoView.info.publishName,
          );
          afLaunchUrlString(url);
        },
        text: UniflowTooltip(
          message:
              '${LocaleKeys.settings_sites_publishedPage_clickToOpenPageInBrowser.tr()}\n${publishInfoView.info.publishName}',
          child: UniflowText(
            publishInfoView.info.publishName,
            fontSize: 14.0,
            figmaLineHeight: 18.0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
