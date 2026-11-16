import 'package:universalworkspace/core/config/kv.dart';
import 'package:universalworkspace/core/config/kv_keys.dart';
import 'package:universalworkspace/plugins/database/application/defines.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/import_data.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_file_importer_bloc.freezed.dart';

class SettingFileImportBloc
    extends Bloc<SettingFileImportEvent, SettingFileImportState> {
  SettingFileImportBloc() : super(SettingFileImportState.initial()) {
    on<SettingFileImportEvent>(
      (event, emit) async {
        await event.when(
          importUniversalWorkspaceDataFolder: (String path) async {
            final formattedDate =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
            final spaceId =
                await getIt<KeyValueStorage>().get(KVKeys.lastOpenedSpaceId);

            final payload = ImportUniversalWorkspaceDataPB.create()
              ..path = path
              ..importContainerName = "import_$formattedDate";

            if (spaceId != null) {
              payload.parentViewId = spaceId;
            }

            emit(
              state.copyWith(loadingState: const LoadingState.loading()),
            );
            final result =
                await UserEventImportUniversalWorkspaceDataFolder(payload).send();
            if (!isClosed) {
              add(SettingFileImportEvent.finishImport(result));
            }
          },
          finishImport: (result) {
            result.fold(
              (l) {
                emit(
                  state.copyWith(
                    successOrFail: UniflowResult.success(null),
                    loadingState:
                        LoadingState.finish(UniflowResult.success(null)),
                  ),
                );
              },
              (err) {
                Log.error(err);
                emit(
                  state.copyWith(
                    successOrFail: UniflowResult.failure(err),
                    loadingState: LoadingState.finish(UniflowResult.failure(err)),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

@freezed
class SettingFileImportEvent with _$SettingFileImportEvent {
  const factory SettingFileImportEvent.importUniversalWorkspaceDataFolder(String path) =
      _ImportUniversalWorkspaceDataFolder;
  const factory SettingFileImportEvent.finishImport(
    UniflowResult<void, UniflowError> result,
  ) = _ImportResult;
}

@freezed
class SettingFileImportState with _$SettingFileImportState {
  const factory SettingFileImportState({
    required LoadingState loadingState,
    required UniflowResult<void, UniflowError>? successOrFail,
  }) = _SettingFileImportState;

  factory SettingFileImportState.initial() => const SettingFileImportState(
        loadingState: LoadingState.idle(),
        successOrFail: null,
      );
}
