import 'dart:math' as math;

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/database/application/field/field_controller.dart';
import 'package:universalworkspace/plugins/database/application/field/sort_entities.dart';
import 'package:universalworkspace/plugins/database/grid/application/sort/sort_editor_bloc.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import 'sort_choice_button.dart';
import 'sort_editor.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({
    super.key,
    required this.fieldController,
  });

  final FieldController fieldController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SortEditorBloc(
        viewId: fieldController.viewId,
        fieldController: fieldController,
      ),
      child: BlocBuilder<SortEditorBloc, SortEditorState>(
        builder: (context, state) {
          if (state.sorts.isEmpty) {
            return const SizedBox.shrink();
          }

          return UniversalWorkspacePopover(
            controller: PopoverController(),
            constraints: BoxConstraints.loose(const Size(320, 200)),
            direction: PopoverDirection.bottomWithLeftAligned,
            offset: const Offset(0, 5),
            margin: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
            popupBuilder: (BuildContext popoverContext) {
              return BlocProvider.value(
                value: context.read<SortEditorBloc>(),
                child: const SortEditor(),
              );
            },
            child: SortChoiceChip(sorts: state.sorts),
          );
        },
      ),
    );
  }
}

class SortChoiceChip extends StatelessWidget {
  const SortChoiceChip({
    super.key,
    required this.sorts,
    this.onTap,
  });

  final List<DatabaseSort> sorts;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final arrow = Transform.rotate(
      angle: -math.pi / 2,
      child: UniflowSvg(
        UniflowSvgs.arrow_left_s,
        color: Theme.of(context).iconTheme.color,
      ),
    );

    final text = LocaleKeys.grid_settings_sort.tr();
    final leftIcon = UniflowSvg(
      UniflowSvgs.sort_ascending_s,
      color: Theme.of(context).iconTheme.color,
    );

    return SizedBox(
      height: 28,
      child: SortChoiceButton(
        text: text,
        leftIcon: leftIcon,
        rightIcon: arrow,
        onTap: onTap,
      ),
    );
  }
}
