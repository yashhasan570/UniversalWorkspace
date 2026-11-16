import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-notification/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/notification.pbenum.dart';
import 'package:universalworkspace_backend/rust_stream.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

import 'notification_helper.dart';

// This value must be identical to the value in the backend (SEARCH_OBSERVABLE_SOURCE)
const _source = 'Search';

class SearchNotificationParser
    extends NotificationParser<SearchNotification, UniflowError> {
  SearchNotificationParser({
    super.id,
    required super.callback,
    String? channel,
  }) : super(
          tyParser: (ty, source) => source == "$_source$channel"
              ? SearchNotification.valueOf(ty)
              : null,
          errorParser: (bytes) => UniflowError.fromBuffer(bytes),
        );
}

typedef SearchNotificationHandler = Function(
  SearchNotification ty,
  UniflowResult<Uint8List, UniflowError> result,
);

class SearchNotificationListener {
  SearchNotificationListener({
    required String objectId,
    required SearchNotificationHandler handler,
    String? channel,
  }) : _parser = SearchNotificationParser(
          id: objectId,
          callback: handler,
          channel: channel,
        ) {
    _subscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  StreamSubscription<SubscribeObject>? _subscription;
  SearchNotificationParser? _parser;

  Future<void> stop() async {
    _parser = null;
    await _subscription?.cancel();
    _subscription = null;
  }
}
