import 'package:universalworkspace/ai/ai.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-ai/entities.pb.dart';
import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/settings/ai/settings_ai_bloc.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/af_dropdown_menu_entry.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/settings_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AIModelSelection extends StatelessWidget {
  const AIModelSelection({super.key});
  static const double height = 49;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsAIBloc, SettingsAIState>(
      builder: (context, state) {
        final models = state.availableModels?.models;
        if (models == null) {
          return const SizedBox(
            // Using same height as SettingsDropdown to avoid layout shift
            height: height,
          );
        }

        final localModels = models.where((model) => model.isLocal).toList();
        final cloudModels = models.where((model) => !model.isLocal).toList();
        final selectedModel = state.availableModels!.selectedModel;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: UniflowText.medium(
                  LocaleKeys.settings_aiPage_keys_llmModelType.tr(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: SettingsDropdown<AIModelPB>(
                  key: ValueKey(selectedModel.name),
                  onChanged: (model) => context
                      .read<SettingsAIBloc>()
                      .add(SettingsAIEvent.selectModel(model)),
                  selectedOption: selectedModel,
                  selectOptionCompare: (left, right) =>
                      left?.name == right?.name,
                  options: [...localModels, ...cloudModels]
                      .map(
                        (model) => buildDropdownMenuEntry<AIModelPB>(
                          context,
                          value: model,
                          label:
                              model.isLocal ? "${model.i18n} 🔐" : model.i18n,
                          subLabel: model.desc,
                          maximumHeight: height,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
