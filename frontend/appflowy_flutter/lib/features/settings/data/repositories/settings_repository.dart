import 'package:universalworkspace_backend/protobuf/uniflow-error/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import '../models/user_data_location.dart';

abstract class SettingsRepository {
  Future<UniflowResult<UserDataLocation, UniflowError>> getUserDataLocation();

  Future<UniflowResult<UserDataLocation, UniflowError>> resetUserDataLocation();

  Future<UniflowResult<UserDataLocation, UniflowError>> setCustomLocation(
    String path,
  );
}
