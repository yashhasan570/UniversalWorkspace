import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/workspace/presentation/widgets/date_picker/widgets/date_time_settings.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/date_entities.pbenum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';

class DateTypeOptionButton extends StatelessWidget {
  const DateTypeOptionButton({
    super.key,
    required this.dateFormat,
    required this.timeFormat,
    required this.onDateFormatChanged,
    required this.onTimeFormatChanged,
    required this.popoverMutex,
  });

  final DateFormatPB dateFormat;
  final TimeFormatPB timeFormat;
  final Function(DateFormatPB) onDateFormatChanged;
  final Function(TimeFormatPB) onTimeFormatChanged;
  final PopoverMutex? popoverMutex;

  @override
  Widget build(BuildContext context) {
    final title =
        "${LocaleKeys.datePicker_dateFormat.tr()} & ${LocaleKeys.datePicker_timeFormat.tr()}";
    return UniversalWorkspacePopover(
      mutex: popoverMutex,
      offset: const Offset(8, 0),
      margin: EdgeInsets.zero,
      constraints: BoxConstraints.loose(const Size(140, 100)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          height: GridSize.popoverItemHeight,
          child: UniflowButton(
            text: UniflowText(title),
            rightIcon: const UniflowSvg(UniflowSvgs.more_s),
          ),
        ),
      ),
      popupBuilder: (_) => DateTimeSetting(
        dateFormat: dateFormat,
        timeFormat: timeFormat,
        onDateFormatChanged: (format) {
          onDateFormatChanged(format);
          popoverMutex?.close();
        },
        onTimeFormatChanged: (format) {
          onTimeFormatChanged(format);
          popoverMutex?.close();
        },
      ),
    );
  }
}
