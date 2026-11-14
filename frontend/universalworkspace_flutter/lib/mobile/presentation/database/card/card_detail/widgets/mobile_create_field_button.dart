import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/database/field/mobile_field_bottom_sheets.dart';
import 'package:universalworkspace/plugins/database/application/field/field_controller.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

class MobileRowDetailCreateFieldButton extends StatelessWidget {
  const MobileRowDetailCreateFieldButton({
    super.key,
    required this.viewId,
    required this.fieldController,
  });

  final String viewId;
  final FieldController fieldController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        maxHeight: GridSize.headerHeight,
      ),
      child: TextButton.icon(
        style: Theme.of(context).textButtonTheme.style?.copyWith(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              overlayColor: WidgetStateProperty.all<Color>(
                Theme.of(context).hoverColor,
              ),
              alignment: AlignmentDirectional.centerStart,
              splashFactory: NoSplash.splashFactory,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              ),
            ),
        label: UniflowText.medium(
          LocaleKeys.grid_field_newProperty.tr(),
          fontSize: 15,
        ),
        onPressed: () => mobileCreateFieldWorkflow(context, viewId),
        icon: const UniflowSvg(UniflowSvgs.add_m),
      ),
    );
  }
}
