import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/workspace/presentation/widgets/toggle/toggle.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';

class DateFormatButton extends StatelessWidget {
  const DateFormatButton({
    super.key,
    this.onTap,
    this.onHover,
  });

  final VoidCallback? onTap;
  final void Function(bool)? onHover;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(
          LocaleKeys.grid_field_dateFormat.tr(),
          lineHeight: 1.0,
        ),
        onTap: onTap,
        onHover: onHover,
        rightIcon: const UniflowSvg(UniflowSvgs.more_s),
      ),
    );
  }
}

class TimeFormatButton extends StatelessWidget {
  const TimeFormatButton({
    super.key,
    this.onTap,
    this.onHover,
  });

  final VoidCallback? onTap;
  final void Function(bool)? onHover;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(
          LocaleKeys.grid_field_timeFormat.tr(),
          lineHeight: 1.0,
        ),
        onTap: onTap,
        onHover: onHover,
        rightIcon: const UniflowSvg(UniflowSvgs.more_s),
      ),
    );
  }
}

class DateFormatList extends StatelessWidget {
  const DateFormatList({
    super.key,
    required this.selectedFormat,
    required this.onSelected,
  });

  final DateFormatPB selectedFormat;
  final Function(DateFormatPB format) onSelected;

  @override
  Widget build(BuildContext context) {
    final cells = DateFormatPB.values
        .where((value) => value != DateFormatPB.FriendlyFull)
        .map((format) {
      return DateFormatCell(
        dateFormat: format,
        onSelected: onSelected,
        isSelected: selectedFormat == format,
      );
    }).toList();

    return SizedBox(
      width: 180,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return VSpace(GridSize.typeOptionSeparatorHeight);
        },
        itemCount: cells.length,
        itemBuilder: (BuildContext context, int index) {
          return cells[index];
        },
      ),
    );
  }
}

class DateFormatCell extends StatelessWidget {
  const DateFormatCell({
    super.key,
    required this.dateFormat,
    required this.onSelected,
    required this.isSelected,
  });

  final DateFormatPB dateFormat;
  final Function(DateFormatPB format) onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Widget? checkmark;
    if (isSelected) {
      checkmark = const UniflowSvg(UniflowSvgs.check_s);
    }

    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(
          dateFormat.title(),
          lineHeight: 1.0,
        ),
        rightIcon: checkmark,
        onTap: () => onSelected(dateFormat),
      ),
    );
  }
}

extension DateFormatExtension on DateFormatPB {
  String title() {
    switch (this) {
      case DateFormatPB.Friendly:
        return LocaleKeys.grid_field_dateFormatFriendly.tr();
      case DateFormatPB.ISO:
        return LocaleKeys.grid_field_dateFormatISO.tr();
      case DateFormatPB.Local:
        return LocaleKeys.grid_field_dateFormatLocal.tr();
      case DateFormatPB.US:
        return LocaleKeys.grid_field_dateFormatUS.tr();
      case DateFormatPB.DayMonthYear:
        return LocaleKeys.grid_field_dateFormatDayMonthYear.tr();
      case DateFormatPB.FriendlyFull:
        return LocaleKeys.grid_field_dateFormatFriendly.tr();
      default:
        throw UnimplementedError;
    }
  }
}

class TimeFormatList extends StatelessWidget {
  const TimeFormatList({
    super.key,
    required this.selectedFormat,
    required this.onSelected,
  });

  final TimeFormatPB selectedFormat;
  final Function(TimeFormatPB format) onSelected;

  @override
  Widget build(BuildContext context) {
    final cells = TimeFormatPB.values.map((format) {
      return TimeFormatCell(
        isSelected: format == selectedFormat,
        timeFormat: format,
        onSelected: onSelected,
      );
    }).toList();

    return SizedBox(
      width: 120,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return VSpace(GridSize.typeOptionSeparatorHeight);
        },
        itemCount: cells.length,
        itemBuilder: (BuildContext context, int index) {
          return cells[index];
        },
      ),
    );
  }
}

class TimeFormatCell extends StatelessWidget {
  const TimeFormatCell({
    super.key,
    required this.timeFormat,
    required this.onSelected,
    required this.isSelected,
  });

  final TimeFormatPB timeFormat;
  final bool isSelected;
  final Function(TimeFormatPB format) onSelected;

  @override
  Widget build(BuildContext context) {
    Widget? checkmark;
    if (isSelected) {
      checkmark = const UniflowSvg(UniflowSvgs.check_s);
    }

    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(
          timeFormat.title(),
          lineHeight: 1.0,
        ),
        rightIcon: checkmark,
        onTap: () => onSelected(timeFormat),
      ),
    );
  }
}

extension TimeFormatExtension on TimeFormatPB {
  String title() {
    switch (this) {
      case TimeFormatPB.TwelveHour:
        return LocaleKeys.grid_field_timeFormatTwelveHour.tr();
      case TimeFormatPB.TwentyFourHour:
        return LocaleKeys.grid_field_timeFormatTwentyFourHour.tr();
      default:
        throw UnimplementedError;
    }
  }
}

class IncludeTimeButton extends StatelessWidget {
  const IncludeTimeButton({
    super.key,
    required this.onChanged,
    required this.includeTime,
    this.showIcon = true,
  });

  final Function(bool value) onChanged;
  final bool includeTime;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: Padding(
        padding: GridSize.typeOptionContentInsets,
        child: Row(
          children: [
            if (showIcon) ...[
              UniflowSvg(
                UniflowSvgs.clock_alarm_s,
                color: Theme.of(context).iconTheme.color,
              ),
              const HSpace(4),
            ],
            const HSpace(2),
            UniflowText(LocaleKeys.grid_field_includeTime.tr()),
            const Spacer(),
            Toggle(
              value: includeTime,
              onChanged: onChanged,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
