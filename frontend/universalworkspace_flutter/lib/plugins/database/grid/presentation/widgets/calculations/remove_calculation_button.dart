import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace_popover/universalworkspace_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';

class RemoveCalculationButton extends StatelessWidget {
  const RemoveCalculationButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(
          LocaleKeys.grid_calculationTypeLabel_none.tr(),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          onTap();
          PopoverContainer.of(context).close();
        },
      ),
    );
  }
}
