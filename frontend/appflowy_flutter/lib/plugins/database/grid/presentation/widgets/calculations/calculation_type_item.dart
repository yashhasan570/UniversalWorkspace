import 'package:flutter/material.dart';

import 'package:universalworkspace/plugins/database/application/calculations/calculation_type_ext.dart';
import 'package:universalworkspace/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/calculation_entities.pbenum.dart';
import 'package:universalworkspace_popover/universalworkspace_popover.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';

class CalculationTypeItem extends StatelessWidget {
  const CalculationTypeItem({
    super.key,
    required this.type,
    required this.onTap,
  });

  final CalculationType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: UniflowButton(
        text: UniflowText(
          type.label,
          overflow: TextOverflow.ellipsis,
          lineHeight: 1.0,
        ),
        onTap: () {
          onTap();
          PopoverContainer.of(context).close();
        },
      ),
    );
  }
}
