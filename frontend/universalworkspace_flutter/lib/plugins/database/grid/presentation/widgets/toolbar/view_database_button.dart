import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/application/tabs/tabs_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/icon_button.dart';
import 'package:flutter/material.dart';

class ViewDatabaseButton extends StatelessWidget {
  const ViewDatabaseButton({super.key, required this.view});

  final ViewPB view;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: UniflowIconButton(
        tooltipText: LocaleKeys.grid_rowPage_viewDatabase.tr(),
        width: 24,
        height: 24,
        iconPadding: const EdgeInsets.all(3),
        icon: const UniflowSvg(UniflowSvgs.database_fullscreen_s),
        onPressed: () {
          getIt<TabsBloc>().add(
            TabsEvent.openPlugin(
              plugin: view.plugin(),
              view: view,
            ),
          );
        },
      ),
    );
  }
}
