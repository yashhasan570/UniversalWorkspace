import 'package:universalworkspace/workspace/application/edit_panel/edit_panel_bloc.dart';
import 'package:universalworkspace/workspace/application/edit_panel/edit_context.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/bar_title.dart';
import 'package:uniflow_infra_ui/style_widget/close_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';

class EditPanel extends StatelessWidget {
  const EditPanel({
    super.key,
    required this.panelContext,
    required this.onEndEdit,
  });

  final EditPanelContext panelContext;
  final VoidCallback onEndEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: BlocProvider(
        create: (context) => getIt<EditPanelBloc>(),
        child: BlocBuilder<EditPanelBloc, EditPanelState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EditPanelTopBar(onClose: () => onEndEdit()),
                Expanded(
                  child: panelContext.child,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EditPanelTopBar extends StatelessWidget {
  const EditPanelTopBar({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.editPanelTopBarHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            UniflowBarTitle(
              title: LocaleKeys.title.tr(),
            ),
            const Spacer(),
            UniflowCloseButton(onPressed: onClose),
          ],
        ),
      ),
    );
  }
}
