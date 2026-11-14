import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

enum MobileBlockActionType {
  delete,
  duplicate,
  insertAbove,
  insertBelow,
  color;

  static List<MobileBlockActionType> get standard => [
        MobileBlockActionType.delete,
        MobileBlockActionType.duplicate,
        MobileBlockActionType.insertAbove,
        MobileBlockActionType.insertBelow,
      ];

  static MobileBlockActionType fromActionString(String actionString) {
    return MobileBlockActionType.values.firstWhere(
      (e) => e.actionString == actionString,
      orElse: () => throw Exception('Unknown action string: $actionString'),
    );
  }

  String get actionString => toString();

  UniflowSvgData get icon {
    return switch (this) {
      MobileBlockActionType.delete => UniflowSvgs.m_delete_m,
      MobileBlockActionType.duplicate => UniflowSvgs.m_duplicate_m,
      MobileBlockActionType.insertAbove => UniflowSvgs.arrow_up_s,
      MobileBlockActionType.insertBelow => UniflowSvgs.arrow_down_s,
      MobileBlockActionType.color => UniflowSvgs.m_color_m,
    };
  }

  String get i18n {
    return switch (this) {
      MobileBlockActionType.delete => LocaleKeys.button_delete.tr(),
      MobileBlockActionType.duplicate => LocaleKeys.button_duplicate.tr(),
      MobileBlockActionType.insertAbove => LocaleKeys.button_insertAbove.tr(),
      MobileBlockActionType.insertBelow => LocaleKeys.button_insertBelow.tr(),
      MobileBlockActionType.color =>
        LocaleKeys.document_plugins_optionAction_color.tr(),
    };
  }
}

class MobileBlockSettingsScreen extends StatelessWidget {
  const MobileBlockSettingsScreen({super.key, required this.actions});

  final List<MobileBlockActionType> actions;

  static const routeName = '/block_settings';

  // the action string comes from the enum MobileBlockActionType
  // example: MobileBlockActionType.delete.actionString, MobileBlockActionType.duplicate.actionString, etc.
  static const supportedActions = 'actions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: UniflowText.semibold(
          LocaleKeys.titleBar_actions.tr(),
          fontSize: 14.0,
        ),
        leading: const AppBarBackButton(),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return UniflowButton(
              text: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 18.0,
                ),
                child: UniflowText(action.i18n),
              ),
              leftIcon: UniflowSvg(action.icon),
              leftIconSize: const Size.square(24),
              onTap: () {},
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
