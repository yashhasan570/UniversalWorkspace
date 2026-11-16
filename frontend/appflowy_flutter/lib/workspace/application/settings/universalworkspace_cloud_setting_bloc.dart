import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/settings/cloud_setting_listener.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_setting.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/workspace.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'universalworkspace_cloud_setting_bloc.freezed.dart';

class UniversalWorkspaceCloudSettingBloc
    extends Bloc<UniversalWorkspaceCloudSettingEvent, UniversalWorkspaceCloudSettingState> {
  UniversalWorkspaceCloudSettingBloc(CloudSettingPB setting)
      : _listener = UserCloudConfigListener(),
        super(UniversalWorkspaceCloudSettingState.initial(setting, false)) {
    _dispatch();
    _getWorkspaceType();
  }

  final UserCloudConfigListener _listener;

  @override
  Future<void> close() async {
    await _listener.stop();
    return super.close();
  }

  void _getWorkspaceType() {
    UserEventGetUserProfile().send().then((value) {
      if (isClosed) {
        return;
      }

      value.fold(
        (profile) => add(
          UniversalWorkspaceCloudSettingEvent.workspaceTypeChanged(
            profile.workspaceType,
          ),
        ),
        (error) => Log.error(error),
      );
    });
  }

  void _dispatch() {
    on<UniversalWorkspaceCloudSettingEvent>(
      (event, emit) async {
        await event.when(
          initial: () async {
            await getSyncLogEnabled().then((value) {
              emit(state.copyWith(isSyncLogEnabled: value));
            });

            _listener.start(
              onSettingChanged: (result) {
                if (isClosed) {
                  return;
                }
                result.fold(
                  (setting) =>
                      add(UniversalWorkspaceCloudSettingEvent.didReceiveSetting(setting)),
                  (error) => Log.error(error),
                );
              },
            );
          },
          enableSync: (isEnable) async {
            final config = UpdateCloudConfigPB.create()..enableSync = isEnable;
            await UserEventSetCloudConfig(config).send();
          },
          enableSyncLog: (isEnable) async {
            await setSyncLogEnabled(isEnable);
            emit(state.copyWith(isSyncLogEnabled: isEnable));
          },
          didReceiveSetting: (CloudSettingPB setting) {
            emit(
              state.copyWith(
                setting: setting,
                showRestartHint: setting.serverUrl.isNotEmpty,
              ),
            );
          },
          workspaceTypeChanged: (WorkspaceTypePB workspaceType) {
            emit(state.copyWith(workspaceType: workspaceType));
          },
        );
      },
    );
  }
}

@freezed
class UniversalWorkspaceCloudSettingEvent with _$UniversalWorkspaceCloudSettingEvent {
  const factory UniversalWorkspaceCloudSettingEvent.initial() = _Initial;
  const factory UniversalWorkspaceCloudSettingEvent.enableSync(bool isEnable) =
      _EnableSync;
  const factory UniversalWorkspaceCloudSettingEvent.enableSyncLog(bool isEnable) =
      _EnableSyncLog;
  const factory UniversalWorkspaceCloudSettingEvent.didReceiveSetting(
    CloudSettingPB setting,
  ) = _DidUpdateSetting;
  const factory UniversalWorkspaceCloudSettingEvent.workspaceTypeChanged(
    WorkspaceTypePB workspaceType,
  ) = _WorkspaceTypeChanged;
}

@freezed
class UniversalWorkspaceCloudSettingState with _$UniversalWorkspaceCloudSettingState {
  const factory UniversalWorkspaceCloudSettingState({
    required CloudSettingPB setting,
    required bool showRestartHint,
    required bool isSyncLogEnabled,
    required WorkspaceTypePB workspaceType,
  }) = _UniversalWorkspaceCloudSettingState;

  factory UniversalWorkspaceCloudSettingState.initial(
    CloudSettingPB setting,
    bool isSyncLogEnabled,
  ) =>
      UniversalWorkspaceCloudSettingState(
        setting: setting,
        showRestartHint: setting.serverUrl.isNotEmpty,
        isSyncLogEnabled: isSyncLogEnabled,
        workspaceType: WorkspaceTypePB.ServerW,
      );
}

UniflowResult<void, String> validateUrl(String url) {
  try {
    // Use Uri.parse to validate the url.
    final uri = Uri.parse(url);
    if (uri.isScheme('HTTP') || uri.isScheme('HTTPS')) {
      return UniflowResult.success(null);
    } else {
      return UniflowResult.failure(
        LocaleKeys.settings_menu_invalidCloudURLScheme.tr(),
      );
    }
  } catch (e) {
    return UniflowResult.failure(e.toString());
  }
}
