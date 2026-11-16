import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/database/field/mobile_field_bottom_sheets.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/util/field_type_extension.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OptionTextField extends StatelessWidget {
  const OptionTextField({
    super.key,
    required this.controller,
    this.autoFocus = false,
    required this.isPrimary,
    required this.fieldType,
    required this.onTextChanged,
    required this.onFieldTypeChanged,
  });

  final TextEditingController controller;
  final bool autoFocus;
  final bool isPrimary;
  final FieldType fieldType;
  final void Function(String value) onTextChanged;
  final void Function(FieldType value) onFieldTypeChanged;

  @override
  Widget build(BuildContext context) {
    return UniflowOptionTile.textField(
      controller: controller,
      autofocus: autoFocus,
      textFieldPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      onTextChanged: onTextChanged,
      leftIcon: GestureDetector(
        onTap: () async {
          if (isPrimary) {
            return;
          }
          final fieldType = await showFieldTypeGridBottomSheet(
            context,
            title: LocaleKeys.grid_field_editProperty.tr(),
          );
          if (fieldType != null) {
            onFieldTypeChanged(fieldType);
          }
        },
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).brightness == Brightness.light
                ? fieldType.mobileIconBackgroundColor
                : fieldType.mobileIconBackgroundColorDark,
          ),
          child: Center(
            child: UniflowSvg(
              fieldType.svgData,
              size: const Size.square(22),
            ),
          ),
        ),
      ),
    );
  }
}
