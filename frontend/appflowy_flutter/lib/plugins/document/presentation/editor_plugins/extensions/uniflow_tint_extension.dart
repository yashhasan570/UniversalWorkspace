import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:flutter/material.dart';

extension UniflowTintExtension on UniflowTint {
  String tintName(
    AppFlowyEditorLocalizations l10n, {
    ThemeMode? themeMode,
    String? theme,
  }) {
    switch (this) {
      case UniflowTint.tint1:
        return l10n.lightLightTint1;
      case UniflowTint.tint2:
        return l10n.lightLightTint2;
      case UniflowTint.tint3:
        return l10n.lightLightTint3;
      case UniflowTint.tint4:
        return l10n.lightLightTint4;
      case UniflowTint.tint5:
        return l10n.lightLightTint5;
      case UniflowTint.tint6:
        return l10n.lightLightTint6;
      case UniflowTint.tint7:
        return l10n.lightLightTint7;
      case UniflowTint.tint8:
        return l10n.lightLightTint8;
      case UniflowTint.tint9:
        return l10n.lightLightTint9;
    }
  }
}
