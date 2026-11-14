import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/setting_entities.pbenum.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pbenum.dart';
import 'package:easy_localization/easy_localization.dart';

extension DatabaseLayoutExtension on DatabaseLayoutPB {
  String get layoutName {
    return switch (this) {
      DatabaseLayoutPB.Board => LocaleKeys.board_menuName.tr(),
      DatabaseLayoutPB.Calendar => LocaleKeys.calendar_menuName.tr(),
      DatabaseLayoutPB.Grid => LocaleKeys.grid_menuName.tr(),
      _ => "",
    };
  }

  ViewLayoutPB get layoutType {
    return switch (this) {
      DatabaseLayoutPB.Board => ViewLayoutPB.Board,
      DatabaseLayoutPB.Calendar => ViewLayoutPB.Calendar,
      DatabaseLayoutPB.Grid => ViewLayoutPB.Grid,
      _ => throw UnimplementedError(),
    };
  }

  UniflowSvgData get icon {
    return switch (this) {
      DatabaseLayoutPB.Board => UniflowSvgs.board_s,
      DatabaseLayoutPB.Calendar => UniflowSvgs.calendar_s,
      DatabaseLayoutPB.Grid => UniflowSvgs.grid_s,
      _ => throw UnimplementedError(),
    };
  }
}
