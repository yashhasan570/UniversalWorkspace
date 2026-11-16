import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/startup/tasks/rust_sdk.dart';
import 'package:universalworkspace/user/application/user_settings_service.dart';
import 'package:universalworkspace/workspace/application/settings/prelude.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import '../models/user_data_location.dart';
import 'settings_repository.dart';

class RustSettingsRepositoryImpl implements SettingsRepository {
  const RustSettingsRepositoryImpl();

  final _userBackendService = const UserSettingsBackendService();

  @override
  Future<UniflowResult<UserDataLocation, UniflowError>>
      getUserDataLocation() async {
    final defaultDirectory = (await appUniflowApplicationDataDirectory()).path;
    final result = await _userBackendService.getUserSetting();

    return result.map(
      (settings) {
        final userDirectory = settings.userFolder;
        return UserDataLocation(
          path: userDirectory,
          isCustom: userDirectory.contains(defaultDirectory),
        );
      },
    );
  }

  @override
  Future<UniflowResult<UserDataLocation, UniflowError>>
      resetUserDataLocation() async {
    final directory = await appUniflowApplicationDataDirectory();
    await getIt<ApplicationDataStorage>().setPath(directory.path);

    return UniflowResult.success(
      UserDataLocation(
        path: directory.path,
        isCustom: false,
      ),
    );
  }

  @override
  Future<UniflowResult<UserDataLocation, UniflowError>> setCustomLocation(
    String path,
  ) async {
    final defaultDirectory = (await appUniflowApplicationDataDirectory()).path;
    await getIt<ApplicationDataStorage>().setCustomPath(path);

    return UniflowResult.success(
      UserDataLocation(
        path: path,
        isCustom: path.contains(defaultDirectory),
      ),
    );
  }
}
