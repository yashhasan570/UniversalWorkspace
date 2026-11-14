import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/util/field_type_extension.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/field_entities.pb.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';

typedef SelectFieldCallback = void Function(FieldType);

const List<FieldType> _supportedFieldTypes = [
  FieldType.RichText,
  FieldType.Number,
  FieldType.SingleSelect,
  FieldType.MultiSelect,
  FieldType.DateTime,
  FieldType.Media,
  FieldType.URL,
  FieldType.Checkbox,
  FieldType.Checklist,
  FieldType.LastEditedTime,
  FieldType.CreatedTime,
  FieldType.Relation,
  FieldType.Summary,
  FieldType.Translate,
  // FieldType.Time,
];

class FieldTypeList extends StatelessWidget with UniflowOverlayDelegate {
  const FieldTypeList({required this.onSelectField, super.key});

  final SelectFieldCallback onSelectField;

  @override
  Widget build(BuildContext context) {
    final cells = _supportedFieldTypes.map((fieldType) {
      return FieldTypeCell(
        fieldType: fieldType,
        onSelectField: (fieldType) {
          onSelectField(fieldType);
          PopoverContainer.of(context).closeAll();
        },
      );
    }).toList();

    return SizedBox(
      width: 140,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: cells.length,
        separatorBuilder: (context, index) {
          return VSpace(GridSize.typeOptionSeparatorHeight);
        },
        physics: StyledScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return cells[index];
        },
      ),
    );
  }
}

class FieldTypeCell extends StatelessWidget {
  const FieldTypeCell({
    super.key,
    required this.fieldType,
    required this.onSelectField,
  });

  final FieldType fieldType;
  final SelectFieldCallback onSelectField;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(fieldType.i18n, lineHeight: 1.0),
        onTap: () => onSelectField(fieldType),
        leftIcon: UniflowSvg(
          fieldType.svgData,
        ),
      ),
    );
  }
}
