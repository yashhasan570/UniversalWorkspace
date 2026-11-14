import 'dart:typed_data';

import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// FieldService provides many field-related interfaces event functions. Check out
/// `rust-lib/uniflow-database/event_map.rs` for a list of events and their
/// implementations.
class FieldBackendService {
  FieldBackendService({required this.viewId, required this.fieldId});

  final String viewId;
  final String fieldId;

  /// Create a field in a database view. The position will only be applicable
  /// in this view; for other views it will be appended to the end
  static Future<UniflowResult<FieldPB, UniflowError>> createField({
    required String viewId,
    FieldType fieldType = FieldType.RichText,
    String? fieldName,
    String? icon,
    Uint8List? typeOptionData,
    OrderObjectPositionPB? position,
  }) {
    final payload = CreateFieldPayloadPB(
      viewId: viewId,
      fieldType: fieldType,
      fieldName: fieldName,
      typeOptionData: typeOptionData,
      fieldPosition: position,
    );

    return DatabaseEventCreateField(payload).send();
  }

  /// Reorder a field within a database view
  static Future<UniflowResult<void, UniflowError>> moveField({
    required String viewId,
    required String fromFieldId,
    required String toFieldId,
  }) {
    final payload = MoveFieldPayloadPB(
      viewId: viewId,
      fromFieldId: fromFieldId,
      toFieldId: toFieldId,
    );

    return DatabaseEventMoveField(payload).send();
  }

  /// Delete a field
  static Future<UniflowResult<void, UniflowError>> deleteField({
    required String viewId,
    required String fieldId,
  }) {
    final payload = DeleteFieldPayloadPB(
      viewId: viewId,
      fieldId: fieldId,
    );

    return DatabaseEventDeleteField(payload).send();
  }

  // Clear all data of all cells in a Field
  static Future<UniflowResult<void, UniflowError>> clearField({
    required String viewId,
    required String fieldId,
  }) {
    final payload = ClearFieldPayloadPB(
      viewId: viewId,
      fieldId: fieldId,
    );

    return DatabaseEventClearField(payload).send();
  }

  /// Duplicate a field
  static Future<UniflowResult<void, UniflowError>> duplicateField({
    required String viewId,
    required String fieldId,
  }) {
    final payload = DuplicateFieldPayloadPB(viewId: viewId, fieldId: fieldId);

    return DatabaseEventDuplicateField(payload).send();
  }

  /// Update a field's properties
  Future<UniflowResult<void, UniflowError>> updateField({
    String? name,
    String? icon,
    bool? frozen,
  }) {
    final payload = FieldChangesetPB.create()
      ..viewId = viewId
      ..fieldId = fieldId;

    if (name != null) {
      payload.name = name;
    }

    if (icon != null) {
      payload.icon = icon;
    }

    if (frozen != null) {
      payload.frozen = frozen;
    }

    return DatabaseEventUpdateField(payload).send();
  }

  /// Change a field's type
  static Future<UniflowResult<void, UniflowError>> updateFieldType({
    required String viewId,
    required String fieldId,
    required FieldType fieldType,
    String? fieldName,
  }) {
    final payload = UpdateFieldTypePayloadPB()
      ..viewId = viewId
      ..fieldId = fieldId
      ..fieldType = fieldType;

    // Only set if fieldName is not null
    if (fieldName != null) {
      payload.fieldName = fieldName;
    }

    return DatabaseEventUpdateFieldType(payload).send();
  }

  /// Update a field's type option data
  static Future<UniflowResult<void, UniflowError>> updateFieldTypeOption({
    required String viewId,
    required String fieldId,
    required List<int> typeOptionData,
  }) {
    final payload = TypeOptionChangesetPB.create()
      ..viewId = viewId
      ..fieldId = fieldId
      ..typeOptionData = typeOptionData;

    return DatabaseEventUpdateFieldTypeOption(payload).send();
  }

  static Future<UniflowResult<List<FieldPB>, UniflowError>> getFields({
    required String viewId,
  }) {
    final payload = GetFieldPayloadPB.create()..viewId = viewId;

    return DatabaseEventGetFields(payload).send().fold(
          (repeated) => UniflowSuccess(repeated.items),
          (error) => UniflowFailure(error),
        );
  }

  /// Returns the primary field of the view.
  static Future<UniflowResult<FieldPB, UniflowError>> getPrimaryField({
    required String viewId,
  }) {
    final payload = DatabaseViewIdPB.create()..value = viewId;
    return DatabaseEventGetPrimaryField(payload).send();
  }

  Future<UniflowResult<FieldPB, UniflowError>> createBefore({
    FieldType fieldType = FieldType.RichText,
    String? fieldName,
    Uint8List? typeOptionData,
  }) {
    return createField(
      viewId: viewId,
      fieldType: fieldType,
      fieldName: fieldName,
      typeOptionData: typeOptionData,
      position: OrderObjectPositionPB(
        position: OrderObjectPositionTypePB.Before,
        objectId: fieldId,
      ),
    );
  }

  Future<UniflowResult<FieldPB, UniflowError>> createAfter({
    FieldType fieldType = FieldType.RichText,
    String? fieldName,
    Uint8List? typeOptionData,
  }) {
    return createField(
      viewId: viewId,
      fieldType: fieldType,
      fieldName: fieldName,
      typeOptionData: typeOptionData,
      position: OrderObjectPositionPB(
        position: OrderObjectPositionTypePB.After,
        objectId: fieldId,
      ),
    );
  }

  Future<UniflowResult<void, UniflowError>> updateType({
    required FieldType fieldType,
    String? fieldName,
  }) =>
      updateFieldType(
        viewId: viewId,
        fieldId: fieldId,
        fieldType: fieldType,
        fieldName: fieldName,
      );

  Future<UniflowResult<void, UniflowError>> delete() =>
      deleteField(viewId: viewId, fieldId: fieldId);

  Future<UniflowResult<void, UniflowError>> duplicate() =>
      duplicateField(viewId: viewId, fieldId: fieldId);
}
