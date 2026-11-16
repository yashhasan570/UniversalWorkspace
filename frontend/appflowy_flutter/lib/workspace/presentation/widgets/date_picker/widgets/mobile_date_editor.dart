import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/workspace/presentation/widgets/date_picker/widgets/date_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';

class MobileDatePicker extends StatefulWidget {
  const MobileDatePicker({
    super.key,
    this.selectedDay,
    this.startDay,
    this.endDay,
    required this.focusedDay,
    required this.isRange,
    this.onDaySelected,
    this.onRangeSelected,
    this.onPageChanged,
  });

  final DateTime? selectedDay;
  final DateTime? startDay;
  final DateTime? endDay;
  final DateTime focusedDay;

  final bool isRange;

  final void Function(DateTime)? onDaySelected;
  final void Function(DateTime?, DateTime?)? onRangeSelected;
  final void Function(DateTime)? onPageChanged;

  @override
  State<MobileDatePicker> createState() => _MobileDatePickerState();
}

class _MobileDatePickerState extends State<MobileDatePicker> {
  PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VSpace(8.0),
        _buildHeader(context),
        const VSpace(8.0),
        _buildCalendar(context),
        const VSpace(16.0),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return DatePicker(
      isRange: widget.isRange,
      onDaySelected: (selectedDay, _) {
        widget.onDaySelected?.call(selectedDay);
      },
      focusedDay: widget.focusedDay,
      onRangeSelected: (start, end, focusedDay) {
        widget.onRangeSelected?.call(start, end);
      },
      selectedDay: widget.selectedDay,
      startDay: widget.startDay,
      endDay: widget.endDay,
      onCalendarCreated: (pageController) {
        this.pageController = pageController;
      },
      onPageChanged: widget.onPageChanged,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
      child: Row(
        children: [
          Expanded(
            child: UniflowText(
              DateFormat.yMMMM().format(widget.focusedDay),
            ),
          ),
          UniflowButton(
            useIntrinsicWidth: true,
            text: UniflowSvg(
              UniflowSvgs.arrow_left_s,
              color: Theme.of(context).iconTheme.color,
              size: const Size.square(24.0),
            ),
            onTap: () {
              pageController?.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
          const HSpace(24.0),
          UniflowButton(
            useIntrinsicWidth: true,
            text: UniflowSvg(
              UniflowSvgs.arrow_right_s,
              color: Theme.of(context).iconTheme.color,
              size: const Size.square(24.0),
            ),
            onTap: () {
              pageController?.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
