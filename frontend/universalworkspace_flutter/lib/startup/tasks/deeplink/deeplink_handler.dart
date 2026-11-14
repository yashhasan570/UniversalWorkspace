import 'dart:async';

import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

typedef DeepLinkResultHandler = void Function(
  DeepLinkHandler handler,
  UniflowResult<dynamic, UniflowError> result,
);

typedef DeepLinkStateHandler = void Function(
  DeepLinkHandler handler,
  DeepLinkState state,
);

typedef DeepLinkErrorHandler = void Function(
  UniflowError error,
);

abstract class DeepLinkHandler<T> {
  /// Checks if this handler should handle the given URI
  bool canHandle(Uri uri);

  /// Handles the deep link URI

  Future<UniflowResult<T, UniflowError>> handle({
    required Uri uri,
    required DeepLinkStateHandler onStateChange,
  });
}

class DeepLinkHandlerRegistry {
  DeepLinkHandlerRegistry._();
  static final instance = DeepLinkHandlerRegistry._();

  final List<DeepLinkHandler> _handlers = [];

  /// Register a new DeepLink handler
  void register(DeepLinkHandler handler) {
    _handlers.add(handler);
  }

  Future<void> processDeepLink({
    required Uri uri,
    required DeepLinkStateHandler onStateChange,
    required DeepLinkResultHandler onResult,
    required DeepLinkErrorHandler onError,
  }) async {
    Log.info('Processing DeepLink: ${uri.toString()}');

    bool handled = false;

    for (final handler in _handlers) {
      if (handler.canHandle(uri)) {
        Log.info('Handler ${handler.runtimeType} will handle the DeepLink');

        final result = await handler.handle(
          uri: uri,
          onStateChange: onStateChange,
        );

        onResult(handler, result);

        handled = true;
        break;
      }
    }

    if (!handled) {
      Log.error('No handler found for DeepLink: ${uri.toString()}');

      onError(
        UniflowError(msg: 'No handler found for DeepLink: ${uri.toString()}'),
      );
    }
  }
}

class DeepLinkResult<T> {
  DeepLinkResult({
    required this.state,
    this.result,
  });
  final DeepLinkState state;
  final UniflowResult<T, UniflowError>? result;
}

enum DeepLinkState {
  none,
  loading,
  finish,
  error,
}
