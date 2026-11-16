import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class FieldSettingsBackendService {
  FieldSettingsBackendService({required this.viewId});

  final String viewId;

  Future<UniflowResult<FieldSettingsPB, UniflowError>> getFieldSettings(
    String fieldId,
  ) {
    final id = FieldIdPB(fieldId: fieldId);
    final ids = RepeatedFieldIdPB()..items.add(id);
    final payload = FieldIdsPB()
      ..viewId = viewId
      ..fieldIds = ids;

    return DatabaseEventGetFieldSettings(payload).send().then((result) {
      return result.fold(
        (repeatedFieldSettings) {
          final fieldSetting = repeatedFieldSettings.items.first;
          if (!fieldSetting.hasVisibility()) {
            fieldSetting.visibility = FieldVisibility.AlwaysShown;
          }

          return UniflowResult.success(fieldSetting);
        },
        (r) => UniflowResult.failure(r),
      );
    });
  }

  Future<UniflowResult<List<FieldSettingsPB>, UniflowError>> getAllFieldSettings() {
    final payload = DatabaseViewIdPB()..value = viewId;

    return DatabaseEventGetAllFieldSettings(payload).send().then((result) {
      return result.fold(
        (repeatedFieldSettings) {
          final fieldSettings = <FieldSettingsPB>[];

          for (final fieldSetting in repeatedFieldSettings.items) {
            if (!fieldSetting.hasVisibility()) {
              fieldSetting.visibility = FieldVisibility.AlwaysShown;
            }
            fieldSettings.add(fieldSetting);
          }

          return UniflowResult.success(fieldSettings);
        },
        (r) => UniflowResult.failure(r),
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> updateFieldSettings({
    required String fieldId,
    FieldVisibility? fieldVisibility,
    double? width,
    bool? wrapCellContent,
  }) {
    final FieldSettingsChangesetPB payload = FieldSettingsChangesetPB.create()
      ..viewId = viewId
      ..fieldId = fieldId;

    if (fieldVisibility != null) {
      payload.visibility = fieldVisibility;
    }

    if (width != null) {
      payload.width = width.round();
    }

    if (wrapCellContent != null) {
      payload.wrapCellContent = wrapCellContent;
    }

    return DatabaseEventUpdateFieldSettings(payload).send();
  }
}
