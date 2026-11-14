import 'package:universalworkspace/workspace/presentation/widgets/date_picker/utils/layout.dart';
import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_popover/universalworkspace_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';

class ClearDateButton extends StatelessWidget {
  const ClearDateButton({
    super.key,
    required this.onClearDate,
  });

  final VoidCallback onClearDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: DatePickerSize.itemHeight,
        child: UniflowButton(
          text: UniflowText(LocaleKeys.datePicker_clearDate.tr()),
          onTap: () {
            onClearDate();
            PopoverContainer.of(context).close();
          },
        ),
      ),
    );
  }
}
