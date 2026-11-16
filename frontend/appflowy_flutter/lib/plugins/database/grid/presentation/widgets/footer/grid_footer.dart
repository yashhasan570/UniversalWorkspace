import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/grid/application/grid_bloc.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/plugins/database/tab_bar/tab_bar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridAddRowButton extends StatelessWidget {
  const GridAddRowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF171717).withValues(alpha: 0.4)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.4);
    return UniflowButton(
      radius: BorderRadius.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AFThemeExtension.of(context).borderColor),
        ),
      ),
      text: UniflowText(
        lineHeight: 1.0,
        LocaleKeys.grid_row_newRow.tr(),
        color: color,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      hoverColor: AFThemeExtension.of(context).lightGreyHover,
      onTap: () => context.read<GridBloc>().add(const GridEvent.createRow()),
      leftIcon: UniflowSvg(
        UniflowSvgs.add_less_padding_s,
        color: color,
      ),
    );
  }
}

class GridRowBottomBar extends StatelessWidget {
  const GridRowBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final padding =
        context.read<DatabasePluginWidgetBuilderSize>().horizontalPadding;
    return Container(
      padding: GridSize.footerContentInsets.copyWith(left: 0) +
          EdgeInsets.only(left: padding),
      height: GridSize.footerHeight,
      child: const GridAddRowButton(),
    );
  }
}

class GridRowLoadMoreButton extends StatelessWidget {
  const GridRowLoadMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final padding =
        context.read<DatabasePluginWidgetBuilderSize>().horizontalPadding;
    final color = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF171717).withValues(alpha: 0.4)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.4);

    return Container(
      padding: GridSize.footerContentInsets.copyWith(left: 0) +
          EdgeInsets.only(left: padding),
      height: GridSize.footerHeight,
      child: UniflowButton(
        radius: BorderRadius.zero,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AFThemeExtension.of(context).borderColor),
          ),
        ),
        text: UniflowText(
          lineHeight: 1.0,
          LocaleKeys.grid_row_loadMore.tr(),
          color: color,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        hoverColor: AFThemeExtension.of(context).lightGreyHover,
        onTap: () => context.read<GridBloc>().add(
              const GridEvent.loadMoreRows(),
            ),
        leftIcon: UniflowSvg(
          UniflowSvgs.load_more_s,
          color: color,
        ),
      ),
    );
  }
}
