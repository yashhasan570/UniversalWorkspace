import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/database_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/setting_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class SettingBackendService {
  const SettingBackendService({required this.viewId});

  final String viewId;

  Future<UniflowResult<DatabaseViewSettingPB, UniflowError>> getSetting() {
    final payload = DatabaseViewIdPB.create()..value = viewId;
    return DatabaseEventGetDatabaseSetting(payload).send();
  }
}
