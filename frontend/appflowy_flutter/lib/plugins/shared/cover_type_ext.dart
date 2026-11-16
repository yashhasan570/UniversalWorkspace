import 'package:universalworkspace/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';

extension IntoCoverTypePB on CoverType {
  CoverTypePB into() => switch (this) {
        CoverType.color => CoverTypePB.ColorCover,
        CoverType.asset => CoverTypePB.AssetCover,
        CoverType.file => CoverTypePB.FileCover,
        _ => CoverTypePB.FileCover,
      };
}
