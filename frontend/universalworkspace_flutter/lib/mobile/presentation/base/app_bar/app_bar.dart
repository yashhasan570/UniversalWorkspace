import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar_actions.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

enum UniflowAppBarLeadingType {
  back,
  close,
  cancel;

  Widget getWidget(VoidCallback? onTap) {
    switch (this) {
      case UniflowAppBarLeadingType.back:
        return AppBarImmersiveBackButton(onTap: onTap);
      case UniflowAppBarLeadingType.close:
        return AppBarCloseButton(onTap: onTap);
      case UniflowAppBarLeadingType.cancel:
        return AppBarCancelButton(onTap: onTap);
    }
  }

  double? get width {
    switch (this) {
      case UniflowAppBarLeadingType.back:
        return 40.0;
      case UniflowAppBarLeadingType.close:
        return 40.0;
      case UniflowAppBarLeadingType.cancel:
        return 120;
    }
  }
}

class UniflowAppBar extends AppBar {
  UniflowAppBar({
    super.key,
    super.actions,
    Widget? title,
    String? titleText,
    UniflowAppBarLeadingType leadingType = UniflowAppBarLeadingType.back,
    double? leadingWidth,
    Widget? leading,
    super.centerTitle,
    VoidCallback? onTapLeading,
    bool showDivider = true,
    super.backgroundColor,
  }) : super(
          title: title ??
              UniflowText(
                titleText ?? '',
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
          titleSpacing: 0,
          elevation: 0,
          leading: leading ?? leadingType.getWidget(onTapLeading),
          leadingWidth: leadingWidth ?? leadingType.width,
          toolbarHeight: 44.0,
          bottom: showDivider
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(0.5),
                  child: Divider(
                    height: 0.5,
                  ),
                )
              : null,
        );
}
