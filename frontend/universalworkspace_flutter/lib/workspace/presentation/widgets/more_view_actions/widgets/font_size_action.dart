import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/application/document_appearance_cubit.dart';
import 'package:universalworkspace/workspace/presentation/widgets/more_view_actions/widgets/font_size_stepper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FontSizeAction extends StatelessWidget {
  const FontSizeAction({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalWorkspacePopover(
      direction: PopoverDirection.leftWithCenterAligned,
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 240),
      offset: const Offset(-10, 0),
      popupBuilder: (context) {
        return BlocBuilder<DocumentAppearanceCubit, DocumentAppearance>(
          builder: (_, state) => FontSizeStepper(
            minimumValue: 10,
            maximumValue: 24,
            value: state.fontSize,
            divisions: 8,
            onChanged: (newFontSize) => context
                .read<DocumentAppearanceCubit>()
                .syncFontSize(newFontSize),
          ),
        );
      },
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: UniflowButton(
          text: UniflowText.regular(
            LocaleKeys.moreAction_fontSize.tr(),
            fontSize: 14.0,
            lineHeight: 1.0,
            figmaLineHeight: 18.0,
            color: AFThemeExtension.of(context).textColor,
          ),
          leftIcon: Icon(
            Icons.format_size_sharp,
            color: Theme.of(context).iconTheme.color,
            size: 18,
          ),
          leftIconSize: const Size(18, 18),
          hoverColor: AFThemeExtension.of(context).lightGreyHover,
        ),
      ),
    );
  }
}
