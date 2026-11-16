import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/database_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/share_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class BackendExportService {
  static Future<UniflowResult<DatabaseExportDataPB, UniflowError>>
      exportDatabaseAsCSV(
    String viewId,
  ) async {
    final payload = DatabaseViewIdPB.create()..value = viewId;
    return DatabaseEventExportCSV(payload).send();
  }

  static Future<UniflowResult<DatabaseExportDataPB, UniflowError>>
      exportDatabaseAsRawData(
    String viewId,
  ) async {
    final payload = DatabaseViewIdPB.create()..value = viewId;
    return DatabaseEventExportRawDatabaseData(payload).send();
  }
}
