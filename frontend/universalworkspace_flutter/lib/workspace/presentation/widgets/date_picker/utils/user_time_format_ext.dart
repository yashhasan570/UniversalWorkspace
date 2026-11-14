import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';

extension ToTimeFormat on UserTimeFormatPB {
  TimeFormatPB get simplified => switch (this) {
        UserTimeFormatPB.TwelveHour => TimeFormatPB.TwelveHour,
        UserTimeFormatPB.TwentyFourHour => TimeFormatPB.TwentyFourHour,
        _ => TimeFormatPB.TwentyFourHour,
      };
}
