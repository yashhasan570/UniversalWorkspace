import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/field/type_option/type_option_data_parser.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace/plugins/database/widgets/field/type_option_editor/builder.dart';
import 'package:universalworkspace/workspace/presentation/widgets/toggle/toggle.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/field_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/media_entities.pb.dart';
import 'package:universalworkspace_popover/universalworkspace_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:protobuf/protobuf.dart';

class MediaTypeOptionEditorFactory implements TypeOptionEditorFactory {
  const MediaTypeOptionEditorFactory();

  @override
  Widget? build({
    required BuildContext context,
    required String viewId,
    required FieldPB field,
    required PopoverMutex popoverMutex,
    required TypeOptionDataCallback onTypeOptionUpdated,
  }) {
    final typeOption = _parseTypeOptionData(field.typeOptionData);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: GridSize.popoverItemHeight,
      alignment: Alignment.centerLeft,
      child: UniflowButton(
        resetHoverOnRebuild: false,
        text: UniflowText(
          LocaleKeys.grid_media_showFileNames.tr(),
          lineHeight: 1.0,
        ),
        onHover: (_) => popoverMutex.close(),
        rightIcon: Toggle(
          value: !typeOption.hideFileNames,
          onChanged: (val) => onTypeOptionUpdated(
            _toggleHideFiles(typeOption, !val).writeToBuffer(),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  MediaTypeOptionPB _parseTypeOptionData(List<int> data) {
    return MediaTypeOptionDataParser().fromBuffer(data);
  }

  MediaTypeOptionPB _toggleHideFiles(
    MediaTypeOptionPB typeOption,
    bool hideFileNames,
  ) {
    typeOption.freeze();
    return typeOption.rebuild((to) => to.hideFileNames = hideFileNames);
  }
}
