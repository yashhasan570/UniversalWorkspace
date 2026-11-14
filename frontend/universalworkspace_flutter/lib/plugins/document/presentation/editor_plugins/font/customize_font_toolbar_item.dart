import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/application/document_appearance_cubit.dart';
import 'package:universalworkspace/shared/google_fonts_extension.dart';
import 'package:universalworkspace/util/font_family_extension.dart';
import 'package:universalworkspace/util/levenshtein.dart';
import 'package:universalworkspace/workspace/application/appearance_defaults.dart';
import 'package:universalworkspace/workspace/application/settings/appearance/appearance_cubit.dart';
import 'package:universalworkspace/workspace/application/settings/appearance/base_appearance.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/setting_list_tile.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/setting_value_dropdown.dart';
import 'package:universalworkspace_popover/universalworkspace_popover.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/style_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeFontFamilySetting extends StatefulWidget {
  const ThemeFontFamilySetting({
    super.key,
    required this.currentFontFamily,
  });

  final String currentFontFamily;
  static Key textFieldKey = const Key('FontFamilyTextField');
  static Key resetButtonKey = const Key('FontFamilyResetButton');
  static Key popoverKey = const Key('FontFamilyPopover');

  @override
  State<ThemeFontFamilySetting> createState() => _ThemeFontFamilySettingState();
}

class _ThemeFontFamilySettingState extends State<ThemeFontFamilySetting> {
  @override
  Widget build(BuildContext context) {
    return SettingListTile(
      label: LocaleKeys.settings_appearance_fontFamily_label.tr(),
      resetButtonKey: ThemeFontFamilySetting.resetButtonKey,
      onResetRequested: () {
        context.read<AppearanceSettingsCubit>().resetFontFamily();
        context
            .read<DocumentAppearanceCubit>()
            .syncFontFamily(DefaultAppearanceSettings.kDefaultFontFamily);
      },
      trailing: [
        FontFamilyDropDown(currentFontFamily: widget.currentFontFamily),
      ],
    );
  }
}

class FontFamilyDropDown extends StatefulWidget {
  const FontFamilyDropDown({
    super.key,
    required this.currentFontFamily,
    this.onOpen,
    this.onClose,
    this.onFontFamilyChanged,
    this.child,
    this.popoverController,
    this.offset,
    this.onResetFont,
  });

  final String currentFontFamily;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final void Function(String fontFamily)? onFontFamilyChanged;
  final Widget? child;
  final PopoverController? popoverController;
  final Offset? offset;
  final VoidCallback? onResetFont;

  @override
  State<FontFamilyDropDown> createState() => _FontFamilyDropDownState();
}

class _FontFamilyDropDownState extends State<FontFamilyDropDown> {
  final List<String> availableFonts = [
    defaultFontFamily,
    ...GoogleFonts.asMap().keys,
  ];
  final ValueNotifier<String> query = ValueNotifier('');

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentValue = widget.currentFontFamily.fontFamilyDisplayName;
    return SettingValueDropDown(
      popoverKey: ThemeFontFamilySetting.popoverKey,
      popoverController: widget.popoverController,
      currentValue: currentValue,
      margin: EdgeInsets.zero,
      boxConstraints: const BoxConstraints(
        maxWidth: 240,
        maxHeight: 420,
      ),
      onClose: () {
        query.value = '';
        widget.onClose?.call();
      },
      offset: widget.offset,
      child: widget.child,
      popupBuilder: (_) {
        widget.onOpen?.call();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UniflowTextField(
                key: ThemeFontFamilySetting.textFieldKey,
                hintText: LocaleKeys.settings_appearance_fontFamily_search.tr(),
                debounceDuration: const Duration(milliseconds: 300),
                onChanged: (value) {
                  setState(() {
                    query.value = value;
                  });
                },
              ),
            ),
            Container(height: 1, color: Theme.of(context).dividerColor),
            ValueListenableBuilder(
              valueListenable: query,
              builder: (context, value, child) {
                var displayed = availableFonts;
                if (value.isNotEmpty) {
                  displayed = availableFonts
                      .where(
                        (font) => font
                            .toLowerCase()
                            .contains(value.toLowerCase().toString()),
                      )
                      .sorted((a, b) => levenshtein(a, b))
                      .toList();
                }
                return displayed.length >= 10
                    ? Flexible(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemBuilder: (context, index) =>
                              _fontFamilyItemButton(
                            context,
                            getGoogleFontSafely(displayed[index]),
                          ),
                          itemCount: displayed.length,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            displayed.length,
                            (index) => _fontFamilyItemButton(
                              context,
                              getGoogleFontSafely(displayed[index]),
                            ),
                          ),
                        ),
                      );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _fontFamilyItemButton(
    BuildContext context,
    TextStyle style,
  ) {
    final buttonFontFamily =
        style.fontFamily?.parseFontFamilyName() ?? defaultFontFamily;
    return Tooltip(
      message: buttonFontFamily,
      waitDuration: const Duration(milliseconds: 150),
      child: SizedBox(
        key: ValueKey(buttonFontFamily),
        height: 36,
        child: UniflowButton(
          onHover: (_) => FocusScope.of(context).unfocus(),
          text: UniflowText(
            buttonFontFamily.fontFamilyDisplayName,
            fontFamily: buttonFontFamily,
            figmaLineHeight: 20,
            fontWeight: FontWeight.w400,
          ),
          rightIcon:
              buttonFontFamily == widget.currentFontFamily.parseFontFamilyName()
                  ? const UniflowSvg(UniflowSvgs.toolbar_check_m)
                  : null,
          onTap: () {
            if (widget.onFontFamilyChanged != null) {
              widget.onFontFamilyChanged!(buttonFontFamily);
            } else {
              if (widget.currentFontFamily.parseFontFamilyName() !=
                  buttonFontFamily) {
                context
                    .read<AppearanceSettingsCubit>()
                    .setFontFamily(buttonFontFamily);
                context
                    .read<DocumentAppearanceCubit>()
                    .syncFontFamily(buttonFontFamily);
              }
            }
            PopoverContainer.of(context).close();
          },
        ),
      ),
    );
  }
}
