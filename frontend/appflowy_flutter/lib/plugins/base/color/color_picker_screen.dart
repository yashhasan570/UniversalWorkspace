import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar.dart';
import 'package:universalworkspace/plugins/base/color/color_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileColorPickerScreen extends StatelessWidget {
  const MobileColorPickerScreen({super.key, this.title});

  final String? title;

  static const routeName = '/color_picker';
  static const pageTitle = 'title';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniflowAppBar(
        titleText: title ?? LocaleKeys.titleBar_pageIcon.tr(),
      ),
      body: SafeArea(
        child: UniflowMobileColorPicker(
          onSelectedColor: (option) => context.pop(option),
        ),
      ),
    );
  }
}
