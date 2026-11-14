import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_popover/universalworkspace_popover.dart';
import 'package:flutter/material.dart';
import 'builder.dart';

class URLTypeOptionEditorFactory implements TypeOptionEditorFactory {
  const URLTypeOptionEditorFactory();

  @override
  Widget? build({
    required BuildContext context,
    required String viewId,
    required FieldPB field,
    required PopoverMutex popoverMutex,
    required TypeOptionDataCallback onTypeOptionUpdated,
  }) =>
      null;
}
