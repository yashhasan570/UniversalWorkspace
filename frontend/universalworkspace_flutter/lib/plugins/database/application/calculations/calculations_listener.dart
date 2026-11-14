import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/core/notification/grid_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:uniflow_infra/notifier.dart';

typedef UpdateCalculationValue
    = UniflowResult<CalculationChangesetNotificationPB, UniflowError>;

class CalculationsListener {
  CalculationsListener({required this.viewId});

  final String viewId;

  PublishNotifier<UpdateCalculationValue>? _calculationNotifier =
      PublishNotifier();
  DatabaseNotificationListener? _listener;

  void start({
    required void Function(UpdateCalculationValue) onCalculationChanged,
  }) {
    _calculationNotifier?.addPublishListener(onCalculationChanged);
    _listener = DatabaseNotificationListener(
      objectId: viewId,
      handler: _handler,
    );
  }

  void _handler(
    DatabaseNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    switch (ty) {
      case DatabaseNotification.DidUpdateCalculation:
        _calculationNotifier?.value = result.fold(
          (payload) => UniflowResult.success(
            CalculationChangesetNotificationPB.fromBuffer(payload),
          ),
          (err) => UniflowResult.failure(err),
        );
      default:
        break;
    }
  }

  Future<void> stop() async {
    await _listener?.stop();
    _calculationNotifier?.dispose();
    _calculationNotifier = null;
  }
}
