import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/database/card/card_detail/widgets/widgets.dart';
import 'package:universalworkspace/mobile/presentation/database/field/mobile_field_bottom_sheets.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/plugins/database/application/field/field_controller.dart';
import 'package:universalworkspace/plugins/database/application/field/field_editor_bloc.dart';
import 'package:universalworkspace/plugins/database/application/field/field_info.dart';
import 'package:universalworkspace/plugins/database/domain/field_backend_service.dart';
import 'package:universalworkspace/plugins/database/widgets/setting/field_visibility_extension.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuickEditField extends StatefulWidget {
  const QuickEditField({
    super.key,
    required this.viewId,
    required this.fieldController,
    required this.fieldInfo,
  });

  final String viewId;
  final FieldController fieldController;
  final FieldInfo fieldInfo;

  @override
  State<QuickEditField> createState() => _QuickEditFieldState();
}

class _QuickEditFieldState extends State<QuickEditField> {
  final TextEditingController controller = TextEditingController();

  late final FieldServices service = FieldServices(
    viewId: widget.viewId,
    fieldId: widget.fieldInfo.field.id,
  );

  late FieldVisibility fieldVisibility;

  @override
  void initState() {
    super.initState();
    fieldVisibility =
        widget.fieldInfo.visibility ?? FieldVisibility.AlwaysShown;
    controller.text = widget.fieldInfo.field.name;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FieldEditorBloc(
        viewId: widget.viewId,
        fieldController: widget.fieldController,
        fieldInfo: widget.fieldInfo,
        isNew: false,
      ),
      child: BlocConsumer<FieldEditorBloc, FieldEditorState>(
        listenWhen: (previous, current) =>
            previous.field.name != current.field.name,
        listener: (context, state) => controller.text = state.field.name,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(16),
              OptionTextField(
                controller: controller,
                isPrimary: state.field.isPrimary,
                fieldType: state.field.fieldType,
                onTextChanged: (text) {
                  context
                      .read<FieldEditorBloc>()
                      .add(FieldEditorEvent.renameField(text));
                },
                onFieldTypeChanged: (fieldType) {
                  context
                      .read<FieldEditorBloc>()
                      .add(FieldEditorEvent.switchFieldType(fieldType));
                },
              ),
              const _Divider(),
              UniflowOptionTile.text(
                text: LocaleKeys.grid_field_editProperty.tr(),
                leftIcon: const UniflowSvg(UniflowSvgs.m_field_edit_s),
                onTap: () {
                  showEditFieldScreen(
                    context,
                    widget.viewId,
                    state.field,
                  );
                  context.pop();
                },
              ),
              if (!widget.fieldInfo.isPrimary) ...[
                UniflowOptionTile.text(
                  showTopBorder: false,
                  text: fieldVisibility.isVisibleState()
                      ? LocaleKeys.grid_field_hide.tr()
                      : LocaleKeys.grid_field_show.tr(),
                  leftIcon: const UniflowSvg(UniflowSvgs.m_field_hide_s),
                  onTap: () async {
                    context.pop();
                    if (fieldVisibility.isVisibleState()) {
                      await service.hide();
                    } else {
                      await service.hide();
                    }
                  },
                ),
                UniflowOptionTile.text(
                  showTopBorder: false,
                  text: LocaleKeys.grid_field_insertLeft.tr(),
                  leftIcon: const UniflowSvg(UniflowSvgs.m_filed_insert_left_s),
                  onTap: () {
                    context.pop();
                    mobileCreateFieldWorkflow(
                      context,
                      widget.viewId,
                      position: OrderObjectPositionPB(
                        position: OrderObjectPositionTypePB.Before,
                        objectId: widget.fieldInfo.id,
                      ),
                    );
                  },
                ),
              ],
              UniflowOptionTile.text(
                showTopBorder: false,
                text: LocaleKeys.grid_field_insertRight.tr(),
                leftIcon: const UniflowSvg(UniflowSvgs.m_filed_insert_right_s),
                onTap: () {
                  context.pop();
                  mobileCreateFieldWorkflow(
                    context,
                    widget.viewId,
                    position: OrderObjectPositionPB(
                      position: OrderObjectPositionTypePB.After,
                      objectId: widget.fieldInfo.id,
                    ),
                  );
                },
              ),
              if (!widget.fieldInfo.isPrimary) ...[
                UniflowOptionTile.text(
                  showTopBorder: false,
                  text: LocaleKeys.button_duplicate.tr(),
                  leftIcon: const UniflowSvg(UniflowSvgs.m_field_copy_s),
                  onTap: () {
                    context.pop();
                    service.duplicate();
                  },
                ),
                UniflowOptionTile.text(
                  showTopBorder: false,
                  text: LocaleKeys.button_delete.tr(),
                  textColor: Theme.of(context).colorScheme.error,
                  leftIcon: UniflowSvg(
                    UniflowSvgs.m_field_delete_s,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onTap: () {
                    context.pop();
                    service.delete();
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const VSpace(20);
  }
}
