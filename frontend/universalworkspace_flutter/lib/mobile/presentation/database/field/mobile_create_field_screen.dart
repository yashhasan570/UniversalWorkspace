import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar.dart';
import 'package:universalworkspace/mobile/presentation/database/field/mobile_full_field_editor.dart';
import 'package:universalworkspace/util/field_type_extension.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/field_entities.pbenum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileNewPropertyScreen extends StatefulWidget {
  const MobileNewPropertyScreen({
    super.key,
    required this.viewId,
    this.fieldType,
  });

  final String viewId;
  final FieldType? fieldType;

  static const routeName = '/new_property';
  static const argViewId = 'view_id';
  static const argFieldTypeId = 'field_type_id';

  @override
  State<MobileNewPropertyScreen> createState() =>
      _MobileNewPropertyScreenState();
}

class _MobileNewPropertyScreenState extends State<MobileNewPropertyScreen> {
  late FieldOptionValues optionValues;

  @override
  void initState() {
    super.initState();

    final type = widget.fieldType ?? FieldType.RichText;
    optionValues = FieldOptionValues(
      type: type,
      icon: "",
      name: type.i18n,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniflowAppBar(
        centerTitle: true,
        titleText: LocaleKeys.grid_field_newProperty.tr(),
        leadingType: UniflowAppBarLeadingType.cancel,
        actions: [
          _SaveButton(
            onSave: () {
              context.pop(optionValues);
            },
          ),
        ],
      ),
      body: MobileFieldEditor(
        mode: FieldOptionMode.add,
        defaultValues: optionValues,
        onOptionValuesChanged: (optionValues) {
          this.optionValues = optionValues;
        },
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.onSave,
  });

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Align(
        child: GestureDetector(
          onTap: onSave,
          child: UniflowText.medium(
            LocaleKeys.button_save.tr(),
            color: const Color(0xFF00ADDC),
          ),
        ),
      ),
    );
  }
}
