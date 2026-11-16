import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/uniflow_option_tile.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/plugins/database/application/field/field_info.dart';
import 'package:universalworkspace/plugins/database/calendar/application/calendar_setting_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/database_layout_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../field/mobile_field_bottom_sheets.dart';

/// [DatabaseViewLayoutPicker] is seen when changing the layout type of a
/// database view or creating a new database view.
class DatabaseViewLayoutPicker extends StatelessWidget {
  const DatabaseViewLayoutPicker({
    super.key,
    required this.selectedLayout,
    required this.onSelect,
  });

  final DatabaseLayoutPB selectedLayout;
  final void Function(DatabaseLayoutPB layout) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildButton(DatabaseLayoutPB.Grid, true),
        _buildButton(DatabaseLayoutPB.Board, false),
        _buildButton(DatabaseLayoutPB.Calendar, false),
      ],
    );
  }

  Widget _buildButton(DatabaseLayoutPB layout, bool showTopBorder) {
    return UniflowOptionTile.checkbox(
      text: layout.layoutName,
      leftIcon: UniflowSvg(layout.icon, size: const Size.square(20)),
      isSelected: selectedLayout == layout,
      showTopBorder: showTopBorder,
      onTap: () {
        onSelect(layout);
      },
    );
  }
}

/// [MobileCalendarViewLayoutSettings] is used when the database layout is
/// calendar. It allows changing the field being used to layout the events,
/// and which day of the week the calendar starts on.
class MobileCalendarViewLayoutSettings extends StatelessWidget {
  const MobileCalendarViewLayoutSettings({
    super.key,
    required this.databaseController,
  });

  final DatabaseController databaseController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarSettingBloc>(
      create: (context) {
        return CalendarSettingBloc(
          databaseController: databaseController,
        )..add(const CalendarSettingEvent.initial());
      },
      child: BlocBuilder<CalendarSettingBloc, CalendarSettingState>(
        builder: (context, state) {
          if (state.layoutSetting == null) {
            return const SizedBox.shrink();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CalendarLayoutField(
                context: context,
                databaseController: databaseController,
                selectedFieldId: state.layoutSetting?.fieldId,
              ),
              _divider(),
              ..._startWeek(context, state.layoutSetting?.firstDayOfWeek),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _startWeek(BuildContext context, int? firstDayOfWeek) {
    final symbols = DateFormat.EEEE(context.locale.toLanguageTag()).dateSymbols;
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
        child: UniflowText(
          LocaleKeys.calendar_settings_firstDayOfWeek.tr().toUpperCase(),
          fontSize: 13,
          color: Theme.of(context).hintColor,
        ),
      ),
      UniflowOptionTile.checkbox(
        text: symbols.WEEKDAYS[0],
        isSelected: firstDayOfWeek! == 0,
        onTap: () {
          context.read<CalendarSettingBloc>().add(
                const CalendarSettingEvent.updateLayoutSetting(
                  firstDayOfWeek: 0,
                ),
              );
        },
      ),
      UniflowOptionTile.checkbox(
        text: symbols.WEEKDAYS[1],
        isSelected: firstDayOfWeek == 1,
        showTopBorder: false,
        onTap: () {
          context.read<CalendarSettingBloc>().add(
                const CalendarSettingEvent.updateLayoutSetting(
                  firstDayOfWeek: 1,
                ),
              );
        },
      ),
    ];
  }

  Widget _divider() => const VSpace(20);
}

class _CalendarLayoutField extends StatelessWidget {
  const _CalendarLayoutField({
    required this.context,
    required this.databaseController,
    required this.selectedFieldId,
  });

  final BuildContext context;
  final DatabaseController databaseController;
  final String? selectedFieldId;

  @override
  Widget build(BuildContext context) {
    FieldInfo? selectedField;
    if (selectedFieldId != null) {
      selectedField =
          databaseController.fieldController.getField(selectedFieldId!);
    }
    return UniflowOptionTile.text(
      text: LocaleKeys.calendar_settings_layoutDateField.tr(),
      trailing: selectedFieldId == null
          ? null
          : Row(
              children: [
                UniflowText(
                  selectedField!.name,
                  color: Theme.of(context).hintColor,
                ),
                const HSpace(8),
                const UniflowSvg(UniflowSvgs.arrow_right_s),
              ],
            ),
      onTap: () async {
        final newFieldId = await showFieldPicker(
          context,
          LocaleKeys.calendar_settings_changeLayoutDateField.tr(),
          selectedFieldId,
          databaseController.fieldController,
          (field) => field.fieldType == FieldType.DateTime,
        );
        if (context.mounted &&
            newFieldId != null &&
            newFieldId != selectedFieldId) {
          context.read<CalendarSettingBloc>().add(
                CalendarSettingEvent.updateLayoutSetting(
                  layoutFieldId: newFieldId,
                ),
              );
        }
      },
    );
  }
}

class MobileBoardViewLayoutSettings extends StatelessWidget {
  const MobileBoardViewLayoutSettings({
    super.key,
    required this.databaseController,
  });

  final DatabaseController databaseController;

  @override
  Widget build(BuildContext context) {
    return UniflowOptionTile.text(text: LocaleKeys.board_groupBy.tr());
  }
}
