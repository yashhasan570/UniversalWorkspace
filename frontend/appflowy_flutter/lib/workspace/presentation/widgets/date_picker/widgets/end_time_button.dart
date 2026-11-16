import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/workspace/presentation/widgets/toggle/toggle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';

class EndTimeButton extends StatelessWidget {
  const EndTimeButton({
    super.key,
    required this.isRange,
    required this.onChanged,
  });

  final bool isRange;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: GridSize.popoverItemHeight,
        child: Padding(
          padding: GridSize.typeOptionContentInsets,
          child: Row(
            children: [
              UniflowSvg(
                UniflowSvgs.date_s,
                color: Theme.of(context).iconTheme.color,
              ),
              const HSpace(6),
              UniflowText(LocaleKeys.datePicker_isRange.tr()),
              const Spacer(),
              Toggle(
                value: isRange,
                onChanged: onChanged,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
