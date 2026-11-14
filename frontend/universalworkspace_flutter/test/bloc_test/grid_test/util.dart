import 'dart:convert';

import 'package:universalworkspace/plugins/database/application/cell/cell_controller.dart';
import 'package:universalworkspace/plugins/database/application/cell/cell_controller_builder.dart';
import 'package:universalworkspace/plugins/database/application/field/field_controller.dart';
import 'package:universalworkspace/plugins/database/application/field/field_editor_bloc.dart';
import 'package:universalworkspace/plugins/database/domain/field_service.dart';
import 'package:universalworkspace/plugins/database/application/row/row_cache.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/workspace/application/settings/share/import_service.dart';
import 'package:universalworkspace/workspace/application/view/view_service.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/field_entities.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:flutter/services.dart';

import '../../util.dart';

const v020GridFileName = "v020.afdb";
const v069GridFileName = "v069.afdb";

class GridTestContext {
  GridTestContext(this.view, this.databaseController);

  final ViewPB view;
  final DatabaseController databaseController;

  String get viewId => view.id;

  List<RowInfo> get rowInfos {
    return databaseController.rowCache.rowInfos;
  }

  FieldController get fieldController => databaseController.fieldController;

  Future<FieldEditorBloc> createField(FieldType fieldType) async {
    final editorBloc =
        await createFieldEditor(databaseController: databaseController);
    await gridResponseFuture();
    editorBloc.add(FieldEditorEvent.switchFieldType(fieldType));
    await gridResponseFuture();
    return editorBloc;
  }

  CellController makeGridCellController(int fieldIndex, int rowIndex) {
    return makeCellController(
      databaseController,
      CellContext(
        fieldId: fieldController.fieldInfos[fieldIndex].id,
        rowId: rowInfos[rowIndex].rowId,
      ),
    ).as();
  }
}

Future<FieldEditorBloc> createFieldEditor({
  required DatabaseController databaseController,
}) async {
  final result = await FieldBackendService.createField(
    viewId: databaseController.viewId,
  );
  await gridResponseFuture();
  return result.fold(
    (field) {
      return FieldEditorBloc(
        viewId: databaseController.viewId,
        fieldController: databaseController.fieldController,
        fieldInfo: databaseController.fieldController.getField(field.id)!,
        isNew: true,
      );
    },
    (err) => throw Exception(err),
  );
}

/// Create a empty Grid for test
class UniversalWorkspaceGridTest {
  UniversalWorkspaceGridTest({required this.unitTest});

  final UniversalWorkspaceUnitTest unitTest;

  static Future<UniversalWorkspaceGridTest> ensureInitialized() async {
    final inner = await UniversalWorkspaceUnitTest.ensureInitialized();
    return UniversalWorkspaceGridTest(unitTest: inner);
  }

  Future<GridTestContext> makeDefaultTestGrid() async {
    final workspace = await unitTest.createWorkspace();
    final context = await ViewBackendService.createView(
      parentViewId: workspace.id,
      name: "Test Grid",
      layoutType: ViewLayoutPB.Grid,
      openAfterCreate: true,
    ).fold(
      (view) async {
        final databaseController = DatabaseController(view: view);
        await databaseController
            .open()
            .fold((l) => null, (r) => throw Exception(r));
        return GridTestContext(
          view,
          databaseController,
        );
      },
      (error) => throw Exception(),
    );

    return context;
  }

  Future<GridTestContext> makeTestGridFromImportedData(
    String fileName,
  ) async {
    final workspace = await unitTest.createWorkspace();

    // Don't use the p.join to build the path that used in loadString. It
    // is not working on windows.
    final data = await rootBundle
        .loadString("assets/test/workspaces/database/$fileName");

    final context = await ImportBackendService.importPages(
      workspace.id,
      [
        ImportItemPayloadPB()
          ..name = fileName
          ..data = utf8.encode(data)
          ..viewLayout = ViewLayoutPB.Grid
          ..importType = ImportTypePB.AFDatabase,
      ],
    ).fold(
      (views) async {
        final view = views.items.first;
        final databaseController = DatabaseController(view: view);
        await databaseController
            .open()
            .fold((l) => null, (r) => throw Exception(r));
        return GridTestContext(
          view,
          databaseController,
        );
      },
      (err) => throw Exception(),
    );

    return context;
  }
}

Future<void> gridResponseFuture({int milliseconds = 300}) {
  return Future.delayed(
    gridResponseDuration(milliseconds: milliseconds),
  );
}

Duration gridResponseDuration({int milliseconds = 300}) {
  return Duration(milliseconds: milliseconds);
}
