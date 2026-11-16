import 'dart:async';
import 'dart:typed_data';

import 'package:universalworkspace/plugins/ai_chat/application/chat_notification.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-ai/entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-ai/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/subject.pb.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

typedef OnUpdateSelectedModel = void Function(AIModelPB model);

class AIModelSwitchListener {
  AIModelSwitchListener({required this.objectId}) {
    _parser = ChatNotificationParser(id: objectId, callback: _callback);
    _subscription = RustStreamReceiver.listen(
      (observable) => _parser?.parse(observable),
    );
  }

  final String objectId;
  StreamSubscription<SubscribeObject>? _subscription;
  ChatNotificationParser? _parser;

  void start({
    OnUpdateSelectedModel? onUpdateSelectedModel,
  }) {
    this.onUpdateSelectedModel = onUpdateSelectedModel;
  }

  OnUpdateSelectedModel? onUpdateSelectedModel;

  void _callback(
    ChatNotification ty,
    UniflowResult<Uint8List, UniflowError> result,
  ) {
    result.map((r) {
      switch (ty) {
        case ChatNotification.DidUpdateSelectedModel:
          onUpdateSelectedModel?.call(AIModelPB.fromBuffer(r));
          break;
        default:
          break;
      }
    });
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
