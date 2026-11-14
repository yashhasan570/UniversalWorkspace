import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/icon_button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/trash.pb.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

import 'sizes.dart';

class TrashCell extends StatelessWidget {
  const TrashCell({
    super.key,
    required this.object,
    required this.onRestore,
    required this.onDelete,
  });

  final VoidCallback onRestore;
  final VoidCallback onDelete;
  final TrashPB object;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: TrashSizes.fileNameWidth,
          child: UniflowText(
            object.name.isEmpty
                ? LocaleKeys.menuAppHeader_defaultNewPageName.tr()
                : object.name,
          ),
        ),
        SizedBox(
          width: TrashSizes.lashModifyWidth,
          child: UniflowText(dateFormatter(object.modifiedTime)),
        ),
        SizedBox(
          width: TrashSizes.createTimeWidth,
          child: UniflowText(dateFormatter(object.createTime)),
        ),
        const Spacer(),
        UniflowIconButton(
          iconColorOnHover: Theme.of(context).colorScheme.onSurface,
          width: TrashSizes.actionIconWidth,
          onPressed: onRestore,
          iconPadding: const EdgeInsets.all(5),
          icon: const UniflowSvg(UniflowSvgs.restore_s),
        ),
        const HSpace(20),
        UniflowIconButton(
          iconColorOnHover: Theme.of(context).colorScheme.onSurface,
          width: TrashSizes.actionIconWidth,
          onPressed: onDelete,
          iconPadding: const EdgeInsets.all(5),
          icon: const UniflowSvg(UniflowSvgs.delete_s),
        ),
      ],
    );
  }

  String dateFormatter($fixnum.Int64 inputTimestamps) {
    final outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    final date =
        DateTime.fromMillisecondsSinceEpoch(inputTimestamps.toInt() * 1000);
    final outputDate = outputFormat.format(date);
    return outputDate;
  }
}
