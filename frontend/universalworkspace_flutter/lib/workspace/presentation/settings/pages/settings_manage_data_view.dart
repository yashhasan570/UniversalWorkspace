import 'dart:async';

import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/features/settings/settings.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/universalworkspace_cache_manager.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/util/share_log_files.dart';
import 'package:universalworkspace/workspace/application/settings/setting_file_importer_bloc.dart';
import 'package:universalworkspace/workspace/presentation/home/toast.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/fix_data_widget.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/settings_body.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/settings_category.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/single_setting_action.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/files/settings_export_file_widget.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialog_v2.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/file_picker/file_picker_service.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../shared/setting_action.dart';

class SettingsManageDataView extends StatelessWidget {
  const SettingsManageDataView({
    super.key,
    required this.workspace,
    required this.userProfile,
  });

  final UserWorkspacePB workspace;
  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataLocationBloc>(
      create: (_) => DataLocationBloc(
        repository: const RustSettingsRepositoryImpl(),
      )..add(DataLocationEvent.initial()),
      child: BlocConsumer<DataLocationBloc, DataLocationState>(
        listenWhen: (previous, current) =>
            previous.didResetToDefault != current.didResetToDefault,
        listener: (context, state) {
          if (state.didResetToDefault) {
            Navigator.of(context).pop();
            runUniversalWorkspace(isAnon: true);
          }
        },
        builder: (context, state) {
          // final _ = state.userDataLocation?.isCustom ?? false;
          final isCloudWorkspace =
              workspace.workspaceType == WorkspaceTypePB.ServerW;
          final path = state.userDataLocation?.path;

          return SettingsBody(
            title: LocaleKeys.settings_manageDataPage_title.tr(),
            description: LocaleKeys.settings_manageDataPage_description.tr(),
            children: [
              SettingsCategory(
                title:
                    LocaleKeys.settings_manageDataPage_dataStorage_title.tr(),
                tooltip:
                    LocaleKeys.settings_manageDataPage_dataStorage_tooltip.tr(),
                actions: [
                  if (isCloudWorkspace)
                    SettingAction(
                      tooltip: LocaleKeys
                          .settings_manageDataPage_dataStorage_actions_resetTooltip
                          .tr(),
                      icon: const UniflowSvg(
                        UniflowSvgs.restore_s,
                        size: Size.square(20),
                      ),
                      label: LocaleKeys.settings_common_reset.tr(),
                      onPressed: () {
                        showSimpleAFDialog(
                          context: context,
                          title: LocaleKeys
                              .settings_manageDataPage_dataStorage_resetDialog_title
                              .tr(),
                          content: LocaleKeys
                              .settings_manageDataPage_dataStorage_resetDialog_description
                              .tr(),
                          primaryAction: (
                            LocaleKeys.button_confirm.tr(),
                            (_) {
                              context
                                  .read<DataLocationBloc>()
                                  .add(DataLocationResetToDefault());
                            }
                          ),
                          secondaryAction: (
                            LocaleKeys.button_cancel.tr(),
                            (_) {},
                          ),
                        );
                      },
                    ),
                ],
                children: path == null
                    ? [
                        const CircularProgressIndicator(),
                      ]
                    : [
                        _CurrentPath(path: path),
                        if (isCloudWorkspace) _DataPathActions(path: path),
                      ],
              ),
              SettingsCategory(
                title: LocaleKeys.settings_manageDataPage_importData_title.tr(),
                tooltip:
                    LocaleKeys.settings_manageDataPage_importData_tooltip.tr(),
                children: const [_ImportDataField()],
              ),
              if (kDebugMode) ...[
                SettingsCategory(
                  title: LocaleKeys.settings_files_exportData.tr(),
                  children: const [
                    SettingsExportFileWidget(),
                    FixDataWidget(),
                  ],
                ),
              ],
              SettingsCategory(
                title: LocaleKeys.workspace_errorActions_exportLogFiles.tr(),
                children: [
                  SingleSettingAction(
                    labelMaxLines: 4,
                    label:
                        LocaleKeys.workspace_errorActions_exportLogFiles.tr(),
                    buttonLabel: LocaleKeys.settings_files_export.tr(),
                    onPressed: () {
                      shareLogFiles(context);
                    },
                  ),
                ],
              ),
              SettingsCategory(
                title: LocaleKeys.settings_manageDataPage_cache_title.tr(),
                children: [
                  SingleSettingAction(
                    labelMaxLines: 4,
                    label: LocaleKeys.settings_manageDataPage_cache_description
                        .tr(),
                    buttonLabel:
                        LocaleKeys.settings_manageDataPage_cache_title.tr(),
                    onPressed: () {
                      showCancelAndConfirmDialog(
                        context: context,
                        title: LocaleKeys
                            .settings_manageDataPage_cache_dialog_title
                            .tr(),
                        description: LocaleKeys
                            .settings_manageDataPage_cache_dialog_description
                            .tr(),
                        confirmLabel: LocaleKeys.button_ok.tr(),
                        onConfirm: (_) async {
                          // clear all cache
                          await getIt<UniflowCacheManager>().clearAllCache();

                          // check the workspace and space health
                          await WorkspaceDataManager.checkViewHealth(
                            dryRun: false,
                          );

                          if (context.mounted) {
                            showToastNotification(
                              message: LocaleKeys
                                  .settings_manageDataPage_cache_dialog_successHint
                                  .tr(),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// class _EncryptDataSetting extends StatelessWidget {
//   const _EncryptDataSetting({required this.userProfile});

//   final UserProfilePB userProfile;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<EncryptSecretBloc>.value(
//       value: context.read<EncryptSecretBloc>(),
//       child: BlocBuilder<EncryptSecretBloc, EncryptSecretState>(
//         builder: (context, state) {
//           if (state.loadingState?.isLoading() == true) {
//             return const Row(
//               children: [
//                 SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 3,
//                   ),
//                 ),
//                 HSpace(16),
//                 UniflowText.medium(
//                   'Encrypting data...',
//                   fontSize: 14,
//                 ),
//               ],
//             );
//           }

//           if (userProfile.encryptionType == EncryptionTypePB.NoEncryption) {
//             return Row(
//               children: [
//                 SizedBox(
//                   height: 42,
//                   child: UniflowTextButton(
//                     LocaleKeys.settings_manageDataPage_encryption_action.tr(),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                     fontWeight: FontWeight.w600,
//                     radius: BorderRadius.circular(12),
//                     fillColor: Theme.of(context).colorScheme.primary,
//                     hoverColor: const Color(0xFF005483),
//                     fontHoverColor: Colors.white,
//                     onPressed: () => SettingsAlertDialog(
//                       title: LocaleKeys
//                           .settings_manageDataPage_encryption_dialog_title
//                           .tr(),
//                       subtitle: LocaleKeys
//                           .settings_manageDataPage_encryption_dialog_description
//                           .tr(),
//                       confirmLabel: LocaleKeys
//                           .settings_manageDataPage_encryption_dialog_title
//                           .tr(),
//                       implyLeading: true,
//                       // Generate a secret one time for the user
//                       confirm: () => context
//                           .read<EncryptSecretBloc>()
//                           .add(const EncryptSecretEvent.setEncryptSecret('')),
//                     ).show(context),
//                   ),
//                 ),
//               ],
//             );
//           }
//           // Show encryption secret for copy/save
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

class _ImportDataField extends StatefulWidget {
  const _ImportDataField();

  @override
  State<_ImportDataField> createState() => _ImportDataFieldState();
}

class _ImportDataFieldState extends State<_ImportDataField> {
  final _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
  }

  @override
  void dispose() {
    _fToast.removeQueuedCustomToasts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingFileImportBloc>(
      create: (context) => SettingFileImportBloc(),
      child: BlocConsumer<SettingFileImportBloc, SettingFileImportState>(
        listenWhen: (previous, current) =>
            previous.successOrFail != current.successOrFail,
        listener: (_, state) => state.successOrFail?.fold(
          (_) => _showToast(LocaleKeys.settings_menu_importSuccess.tr()),
          (_) => _showToast(LocaleKeys.settings_menu_importFailed.tr()),
        ),
        builder: (context, state) {
          return SingleSettingAction(
            label:
                LocaleKeys.settings_manageDataPage_importData_description.tr(),
            labelMaxLines: 2,
            buttonLabel:
                LocaleKeys.settings_manageDataPage_importData_action.tr(),
            onPressed: () async {
              final path = await getIt<FilePickerService>().getDirectoryPath();
              if (path == null || !context.mounted) {
                return;
              }

              context
                  .read<SettingFileImportBloc>()
                  .add(SettingFileImportEvent.importUniversalWorkspaceDataFolder(path));
            },
          );
        },
      ),
    );
  }

  void _showToast(String message) {
    _fToast.showToast(
      child: UniflowMessageToast(message: message),
      gravity: ToastGravity.CENTER,
    );
  }
}

class _CurrentPath extends StatefulWidget {
  const _CurrentPath({required this.path});

  final String path;

  @override
  State<_CurrentPath> createState() => _CurrentPathState();
}

class _CurrentPathState extends State<_CurrentPath> {
  Timer? linkCopiedTimer;
  bool showCopyMessage = false;
  bool isHovering = false;

  @override
  void dispose() {
    linkCopiedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UniflowTooltip(
                message: LocaleKeys
                    .settings_manageDataPage_dataStorage_actions_openTooltip
                    .tr(),
                child: GestureDetector(
                  onTap: () => {
                    afLaunchUri(Uri.file(widget.path)),
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isHovering = true),
                    onExit: (_) => setState(() => isHovering = false),
                    child: Text(
                      widget.path,
                      maxLines: 2,
                      style: theme.textStyle.body
                          .standard(color: theme.textColorScheme.action)
                          .copyWith(
                            decoration:
                                isHovering ? TextDecoration.underline : null,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            HSpace(
              theme.spacing.m,
            ),
            IndexedStack(
              alignment: Alignment.centerRight,
              index: showCopyMessage ? 0 : 1,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AFThemeExtension.of(context).tint7,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.l,
                    vertical: theme.spacing.m,
                  ),
                  child: Text(
                    LocaleKeys
                        .settings_manageDataPage_dataStorage_actions_copiedHint
                        .tr(),
                    style: theme.textStyle.body.standard(
                      color: theme.textColorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                UniflowTooltip(
                  message: LocaleKeys
                      .settings_manageDataPage_dataStorage_actions_copy
                      .tr(),
                  child: AFGhostButton.normal(
                    builder: (context, _, __) {
                      return UniflowSvg(
                        UniflowSvgs.copy_s,
                        size: Size.square(20),
                        color: theme.textColorScheme.primary,
                      );
                    },
                    padding: EdgeInsets.all(theme.spacing.m),
                    onTap: () => _copyLink(widget.path),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _copyLink(String? path) {
    UniversalWorkspaceClipboard.setData(text: path);
    setState(() => showCopyMessage = true);
    linkCopiedTimer?.cancel();
    linkCopiedTimer = Timer(
      const Duration(milliseconds: 300),
      () {
        if (mounted) {
          setState(() => showCopyMessage = false);
        }
      },
    );
  }
}

class _DataPathActions extends StatelessWidget {
  const _DataPathActions({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return AFFilledTextButton.primary(
      text: LocaleKeys.settings_manageDataPage_dataStorage_actions_change.tr(),
      onTap: () async {
        final path = await getIt<FilePickerService>().getDirectoryPath();
        if (!context.mounted || path == null || path == path) {
          return;
        }

        context
            .read<DataLocationBloc>()
            .add(DataLocationEvent.setCustomPath(path));
      },
    );
  }
}
