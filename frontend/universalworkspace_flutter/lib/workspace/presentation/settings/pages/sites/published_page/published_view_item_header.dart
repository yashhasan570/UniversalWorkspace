import 'package:universalworkspace/workspace/presentation/settings/pages/sites/constants.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class PublishViewItemHeader extends StatelessWidget {
  const PublishViewItemHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      SettingsPageSitesConstants.publishedViewHeaderTitles.length,
      (index) => (
        title: SettingsPageSitesConstants.publishedViewHeaderTitles[index],
        flex: SettingsPageSitesConstants.publishedViewItemFlexes[index],
      ),
    );

    return Row(
      children: [
        ...items.map(
          (item) => Expanded(
            flex: item.flex,
            child: UniflowText.medium(
              item.title,
              fontSize: 14.0,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        // it used to align the three dots button in the published page item
        const HSpace(SettingsPageSitesConstants.threeDotsButtonWidth),
      ],
    );
  }
}
