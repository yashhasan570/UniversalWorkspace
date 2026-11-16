import 'package:universalworkspace/env/backend_env.dart';
import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'universalworkspace_cloud_urls_bloc.freezed.dart';

class UniversalWorkspaceCloudURLsBloc
    extends Bloc<UniversalWorkspaceCloudURLsEvent, UniversalWorkspaceCloudURLsState> {
  UniversalWorkspaceCloudURLsBloc() : super(UniversalWorkspaceCloudURLsState.initial()) {
    on<UniversalWorkspaceCloudURLsEvent>((event, emit) async {
      await event.when(
        initial: () async {},
        updateServerUrl: (url) {
          emit(
            state.copyWith(
              updatedServerUrl: url,
              urlError: null,
              showRestartHint: url.isNotEmpty,
            ),
          );
        },
        updateBaseWebDomain: (url) {
          emit(
            state.copyWith(
              updatedBaseWebDomain: url,
              urlError: null,
              showRestartHint: url.isNotEmpty,
            ),
          );
        },
        confirmUpdate: () async {
          if (state.updatedServerUrl.isEmpty) {
            emit(
              state.copyWith(
                updatedServerUrl: "",
                urlError:
                    LocaleKeys.settings_menu_appUniflowCloudUrlCanNotBeEmpty.tr(),
                restartApp: false,
              ),
            );
          } else {
            bool isSuccess = false;

            await validateUrl(state.updatedServerUrl).fold(
              (url) async {
                await useSelfHostedUniversalWorkspaceCloud(url);
                isSuccess = true;
              },
              (err) async => emit(state.copyWith(urlError: err)),
            );

            await validateUrl(state.updatedBaseWebDomain).fold(
              (url) async {
                await useBaseWebDomain(url);
                isSuccess = true;
              },
              (err) async => emit(state.copyWith(urlError: err)),
            );

            if (isSuccess) {
              add(const UniversalWorkspaceCloudURLsEvent.didSaveConfig());
            }
          }
        },
        didSaveConfig: () {
          emit(
            state.copyWith(
              urlError: null,
              restartApp: true,
            ),
          );
        },
      );
    });
  }
}

@freezed
class UniversalWorkspaceCloudURLsEvent with _$UniversalWorkspaceCloudURLsEvent {
  const factory UniversalWorkspaceCloudURLsEvent.initial() = _Initial;
  const factory UniversalWorkspaceCloudURLsEvent.updateServerUrl(String text) =
      _ServerUrl;
  const factory UniversalWorkspaceCloudURLsEvent.updateBaseWebDomain(String text) =
      _UpdateBaseWebDomain;
  const factory UniversalWorkspaceCloudURLsEvent.confirmUpdate() = _UpdateConfig;
  const factory UniversalWorkspaceCloudURLsEvent.didSaveConfig() = _DidSaveConfig;
}

@freezed
class UniversalWorkspaceCloudURLsState with _$UniversalWorkspaceCloudURLsState {
  const factory UniversalWorkspaceCloudURLsState({
    required UniversalWorkspaceCloudConfiguration config,
    required String updatedServerUrl,
    required String updatedBaseWebDomain,
    required String? urlError,
    required bool restartApp,
    required bool showRestartHint,
  }) = _UniversalWorkspaceCloudURLsState;

  factory UniversalWorkspaceCloudURLsState.initial() => UniversalWorkspaceCloudURLsState(
        config: getIt<UniversalWorkspaceCloudSharedEnv>().universalworkspaceCloudConfig,
        urlError: null,
        updatedServerUrl:
            getIt<UniversalWorkspaceCloudSharedEnv>().universalworkspaceCloudConfig.base_url,
        updatedBaseWebDomain:
            getIt<UniversalWorkspaceCloudSharedEnv>().universalworkspaceCloudConfig.base_web_domain,
        showRestartHint: getIt<UniversalWorkspaceCloudSharedEnv>()
            .universalworkspaceCloudConfig
            .base_url
            .isNotEmpty,
        restartApp: false,
      );
}

UniflowResult<String, String> validateUrl(String url) {
  try {
    // Use Uri.parse to validate the url.
    final uri = Uri.parse(removeTrailingSlash(url));
    if (uri.isScheme('HTTP') || uri.isScheme('HTTPS')) {
      return UniflowResult.success(uri.toString());
    } else {
      return UniflowResult.failure(
        LocaleKeys.settings_menu_invalidCloudURLScheme.tr(),
      );
    }
  } catch (e) {
    return UniflowResult.failure(e.toString());
  }
}

String removeTrailingSlash(String input) {
  if (input.endsWith('/')) {
    return input.substring(0, input.length - 1);
  }
  return input;
}
