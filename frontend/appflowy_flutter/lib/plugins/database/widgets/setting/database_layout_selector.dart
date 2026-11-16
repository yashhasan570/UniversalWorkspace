import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/plugins/database/application/layout/layout_bloc.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/plugins/database/widgets/database_layout_ext.dart';
import 'package:universalworkspace/workspace/presentation/widgets/toggle/toggle.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/setting_entities.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatabaseLayoutSelector extends StatelessWidget {
  const DatabaseLayoutSelector({
    super.key,
    required this.viewId,
    required this.databaseController,
  });

  final String viewId;
  final DatabaseController databaseController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DatabaseLayoutBloc(
        viewId: viewId,
        databaseLayout: databaseController.databaseLayout,
      )..add(const DatabaseLayoutEvent.initial()),
      child: BlocBuilder<DatabaseLayoutBloc, DatabaseLayoutState>(
        builder: (context, state) {
          final cells = DatabaseLayoutPB.values
              .map(
                (layout) => DatabaseViewLayoutCell(
                  databaseLayout: layout,
                  isSelected: state.databaseLayout == layout,
                  onTap: (selectedLayout) => context
                      .read<DatabaseLayoutBloc>()
                      .add(DatabaseLayoutEvent.updateLayout(selectedLayout)),
                ),
              )
              .toList();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: cells.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, int index) => cells[index],
                  separatorBuilder: (_, __) =>
                      VSpace(GridSize.typeOptionSeparatorHeight),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 0),
                  color: AFThemeExtension.of(context).borderColor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: SizedBox(
                    height: 30,
                    child: UniflowButton(
                      resetHoverOnRebuild: false,
                      text: UniflowText(
                        LocaleKeys.grid_settings_compactMode.tr(),
                        lineHeight: 1.0,
                      ),
                      onTap: () {
                        databaseController.setCompactMode(
                          !databaseController.compactModeNotifier.value,
                        );
                      },
                      rightIcon: ValueListenableBuilder(
                        valueListenable: databaseController.compactModeNotifier,
                        builder: (context, compactMode, child) {
                          return Toggle(
                            value: compactMode,
                            duration: Duration.zero,
                            onChanged: (value) =>
                                databaseController.setCompactMode(value),
                            padding: EdgeInsets.zero,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DatabaseViewLayoutCell extends StatelessWidget {
  const DatabaseViewLayoutCell({
    super.key,
    required this.isSelected,
    required this.databaseLayout,
    required this.onTap,
  });

  final bool isSelected;
  final DatabaseLayoutPB databaseLayout;
  final void Function(DatabaseLayoutPB) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        height: 30,
        child: UniflowButton(
          hoverColor: AFThemeExtension.of(context).lightGreyHover,
          text: UniflowText(
            lineHeight: 1.0,
            databaseLayout.layoutName,
            color: AFThemeExtension.of(context).textColor,
          ),
          leftIcon: UniflowSvg(
            databaseLayout.icon,
            color: Theme.of(context).iconTheme.color,
          ),
          rightIcon: isSelected ? const UniflowSvg(UniflowSvgs.check_s) : null,
          onTap: () => onTap(databaseLayout),
        ),
      ),
    );
  }
}
