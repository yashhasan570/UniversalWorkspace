import 'package:universalworkspace/plugins/database/domain/cell_service.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/protobuf.dart';

import 'cell_controller.dart';

/// Save the cell data to disk
/// You can extend this class to do custom operations.
abstract class CellDataPersistence<D> {
  Future<UniflowError?> save({
    required String viewId,
    required CellContext cellContext,
    required D data,
  });
}

class TextCellDataPersistence implements CellDataPersistence<String> {
  TextCellDataPersistence();

  @override
  Future<UniflowError?> save({
    required String viewId,
    required CellContext cellContext,
    required String data,
  }) async {
    final fut = CellBackendService.updateCell(
      viewId: viewId,
      cellContext: cellContext,
      data: data,
    );
    return fut.then((result) {
      return result.fold(
        (l) => null,
        (err) => err,
      );
    });
  }
}
