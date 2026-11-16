import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/show_mobile_bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/setting/widgets/mobile_setting_group_widget.dart';
import 'package:universalworkspace/mobile/presentation/setting/widgets/mobile_setting_item_widget.dart';
import 'package:universalworkspace/mobile/presentation/setting/widgets/mobile_setting_trailing.dart';
import 'package:universalworkspace/mobile/presentation/widgets/uniflow_option_tile.dart';
import 'package:universalworkspace/workspace/application/settings/ai/settings_ai_bloc.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AiSettingsGroup extends StatelessWidget {
  const AiSettingsGroup({
    super.key,
    required this.userProfile,
    required this.workspaceId,
  });

  final UserProfilePB userProfile;
  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsAIBloc(
        userProfile,
        workspaceId,
      )..add(const SettingsAIEvent.started()),
      child: BlocBuilder<SettingsAIBloc, SettingsAIState>(
        builder: (context, state) {
          return MobileSettingGroup(
            groupTitle: LocaleKeys.settings_aiPage_title.tr(),
            settingItemList: [
              MobileSettingItem(
                name: LocaleKeys.settings_aiPage_keys_llmModelType.tr(),
                trailing: MobileSettingTrailing(
                  text: state.availableModels?.selectedModel.name ?? "",
                ),
                onTap: () => _onLLMModelTypeTap(context, state),
              ),
              // enable AI search if needed
              // MobileSettingItem(
              //   name: LocaleKeys.settings_aiPage_keys_enableAISearchTitle.tr(),
              //   trailing: const Icon(
              //     Icons.chevron_right,
              //   ),
              //   onTap: () => context.push(UniversalWorkspaceCloudPage.routeName),
              // ),
            ],
          );
        },
      ),
    );
  }

  void _onLLMModelTypeTap(BuildContext context, SettingsAIState state) {
    final availableModels = state.availableModels;
    showMobileBottomSheet(
      context,
      showHeader: true,
      showDragHandle: true,
      showDivider: false,
      title: LocaleKeys.settings_aiPage_keys_llmModelType.tr(),
      builder: (_) {
        return Column(
          children: (availableModels?.models ?? [])
              .asMap()
              .entries
              .map(
                (entry) => UniflowOptionTile.checkbox(
                  text: entry.value.name,
                  showTopBorder: entry.key == 0,
                  isSelected:
                      availableModels?.selectedModel.name == entry.value.name,
                  onTap: () {
                    context
                        .read<SettingsAIBloc>()
                        .add(SettingsAIEvent.selectModel(entry.value));
                    context.pop();
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
