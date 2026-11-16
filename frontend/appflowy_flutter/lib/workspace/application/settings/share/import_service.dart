import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class ImportPayload {
  ImportPayload({
    required this.name,
    required this.data,
    required this.layout,
  });

  final String name;
  final List<int> data;
  final ViewLayoutPB layout;
}

class ImportBackendService {
  static Future<UniflowResult<RepeatedViewPB, UniflowError>> importPages(
    String parentViewId,
    List<ImportItemPayloadPB> values,
  ) async {
    final request = ImportPayloadPB(
      parentViewId: parentViewId,
      items: values,
    );

    return FolderEventImportData(request).send();
  }

  static Future<UniflowResult<void, UniflowError>> importZipFiles(
    List<ImportZipPB> values,
  ) async {
    for (final value in values) {
      final result = await FolderEventImportZipFile(value).send();
      if (result.isFailure) {
        return result;
      }
    }
    return UniflowResult.success(null);
  }
}
