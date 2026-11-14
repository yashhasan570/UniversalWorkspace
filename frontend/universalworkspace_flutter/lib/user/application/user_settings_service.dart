import 'package:universalworkspace_backend/universalworkspace_backend.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_setting.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class UserSettingsBackendService {
  const UserSettingsBackendService();

  Future<AppearanceSettingsPB> getAppearanceSetting() async {
    final result = await UserEventGetAppearanceSetting().send();

    return result.fold(
      (AppearanceSettingsPB setting) => setting,
      (error) =>
          throw UniflowSDKException(ExceptionType.AppearanceSettingsIsEmpty),
    );
  }

  Future<UniflowResult<UserSettingPB, UniflowError>> getUserSetting() {
    return UserEventGetUserSetting().send();
  }

  Future<UniflowResult<void, UniflowError>> setAppearanceSetting(
    AppearanceSettingsPB setting,
  ) {
    return UserEventSetAppearanceSetting(setting).send();
  }

  Future<DateTimeSettingsPB> getDateTimeSettings() async {
    final result = await UserEventGetDateTimeSettings().send();

    return result.fold(
      (DateTimeSettingsPB setting) => setting,
      (error) =>
          throw UniflowSDKException(ExceptionType.AppearanceSettingsIsEmpty),
    );
  }

  Future<UniflowResult<void, UniflowError>> setDateTimeSettings(
    DateTimeSettingsPB settings,
  ) async {
    return UserEventSetDateTimeSettings(settings).send();
  }

  Future<UniflowResult<void, UniflowError>> setNotificationSettings(
    NotificationSettingsPB settings,
  ) async {
    return UserEventSetNotificationSettings(settings).send();
  }

  Future<NotificationSettingsPB> getNotificationSettings() async {
    final result = await UserEventGetNotificationSettings().send();

    return result.fold(
      (NotificationSettingsPB setting) => setting,
      (error) =>
          throw UniflowSDKException(ExceptionType.AppearanceSettingsIsEmpty),
    );
  }
}
