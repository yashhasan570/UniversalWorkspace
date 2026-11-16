import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/plugins/bloc/dynamic_plugin_bloc.dart';
import 'package:uniflow_infra/plugins/bloc/dynamic_plugin_event.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_upload_view.dart';

class ThemeUploadButton extends StatelessWidget {
  const ThemeUploadButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: ThemeUploadWidget.buttonSize,
      child: UniflowButton(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        hoverColor: color,
        text: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UniflowText.medium(
              fontSize: ThemeUploadWidget.buttonFontSize,
              color: Theme.of(context).colorScheme.onPrimary,
              LocaleKeys.settings_appearance_themeUpload_button.tr(),
            ),
          ],
        ),
        onTap: () => BlocProvider.of<DynamicPluginBloc>(context)
            .add(DynamicPluginEvent.addPlugin()),
      ),
    );
  }
}
