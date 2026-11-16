import 'package:universalworkspace/workspace/application/settings/ai/ollama_setting_bloc.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/style_widget/text_field.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:universalworkspace/ai/ai.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-ai/entities.pb.dart';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/af_dropdown_menu_entry.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/settings_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';

class OllamaSettingPage extends StatelessWidget {
  const OllamaSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OllamaSettingBloc()..add(const OllamaSettingEvent.started()),
      child: BlocBuilder<OllamaSettingBloc, OllamaSettingState>(
        buildWhen: (previous, current) =>
            previous.inputItems != current.inputItems ||
            previous.isEdited != current.isEdited,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                for (final item in state.inputItems)
                  _SettingItemWidget(item: item),
                const LocalAIModelSelection(),
                _SaveButton(isEdited: state.isEdited),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingItemWidget extends StatelessWidget {
  const _SettingItemWidget({required this.item});

  final SettingItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(item.content + item.settingType.title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UniflowText(
          item.settingType.title,
          fontSize: 12,
          figmaLineHeight: 16,
        ),
        const VSpace(4),
        SizedBox(
          height: 32,
          child: UniflowTooltip(
            message: item.editable
                ? null
                : LocaleKeys.settings_aiPage_keys_readOnlyField.tr(),
            child: UniflowTextField(
              autoFocus: false,
              hintText: item.hintText,
              text: item.content,
              readOnly: !item.editable,
              onChanged: item.editable
                  ? (content) {
                      context.read<OllamaSettingBloc>().add(
                            OllamaSettingEvent.onEdit(
                              content,
                              item.settingType,
                            ),
                          );
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isEdited});

  final bool isEdited;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: UniflowTooltip(
        message: isEdited ? null : 'No changes',
        child: SizedBox(
          child: UniflowButton(
            text: UniflowText(
              'Apply',
              figmaLineHeight: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            disable: !isEdited,
            expandText: false,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            backgroundColor: Theme.of(context).colorScheme.primary,
            hoverColor: Theme.of(context).colorScheme.primary.withAlpha(200),
            onTap: () {
              if (isEdited) {
                context
                    .read<OllamaSettingBloc>()
                    .add(const OllamaSettingEvent.submit());
              }
            },
          ),
        ),
      ),
    );
  }
}

class LocalAIModelSelection extends StatelessWidget {
  const LocalAIModelSelection({super.key});
  static const double height = 49;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OllamaSettingBloc, OllamaSettingState>(
      buildWhen: (previous, current) =>
          previous.localModels != current.localModels,
      builder: (context, state) {
        final models = state.localModels;
        if (models == null) {
          return const SizedBox(
            // Using same height as SettingsDropdown to avoid layout shift
            height: height,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UniflowText.medium(
              LocaleKeys.settings_aiPage_keys_globalLLMModel.tr(),
              fontSize: 12,
              figmaLineHeight: 16,
            ),
            const VSpace(4),
            SizedBox(
              height: 40,
              child: SettingsDropdown<AIModelPB>(
                key: const Key('_AIModelSelection'),
                textStyle: Theme.of(context).textTheme.bodySmall,
                onChanged: (model) => context
                    .read<OllamaSettingBloc>()
                    .add(OllamaSettingEvent.setDefaultModel(model)),
                selectedOption: models.selectedModel,
                selectOptionCompare: (left, right) => left?.name == right?.name,
                options: models.models
                    .map(
                      (model) => buildDropdownMenuEntry<AIModelPB>(
                        context,
                        value: model,
                        label: model.i18n,
                        subLabel: model.desc,
                        maximumHeight: height,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
