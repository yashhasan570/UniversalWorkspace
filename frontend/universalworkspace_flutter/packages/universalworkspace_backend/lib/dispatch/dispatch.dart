import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:universalworkspace_backend/ffi.dart' as ffi;
import 'package:universalworkspace_backend/log.dart';
// ignore: unnecessary_import
import 'package:universalworkspace_backend/protobuf/dart-ffi/ffi_response.pb.dart';
import 'package:universalworkspace_backend/protobuf/dart-ffi/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-document/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-ai/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-storage/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:ffi/ffi.dart';
import 'package:isolates/isolates.dart';
import 'package:isolates/ports.dart';
import 'package:protobuf/protobuf.dart';

import '../protobuf/uniflow-date/entities.pb.dart';
import '../protobuf/uniflow-date/event_map.pb.dart';

import 'error.dart';

part 'dart_event/uniflow-folder/dart_event.dart';
part 'dart_event/uniflow-user/dart_event.dart';
part 'dart_event/uniflow-database2/dart_event.dart';
part 'dart_event/uniflow-document/dart_event.dart';
part 'dart_event/uniflow-date/dart_event.dart';
part 'dart_event/uniflow-search/dart_event.dart';
part 'dart_event/uniflow-ai/dart_event.dart';
part 'dart_event/uniflow-storage/dart_event.dart';

enum FFIException {
  RequestIsEmpty,
}

class DispatchException implements Exception {
  FFIException type;
  DispatchException(this.type);
}

class Dispatch {
  static bool enableTracing = false;

  static Future<UniflowResult<Uint8List, Uint8List>> asyncRequest(
    FFIRequest request,
  ) async {
    Future<UniflowResult<Uint8List, Uint8List>> _asyncRequest() async {
      final bytesFuture = _sendToRust(request);
      final response = await _extractResponse(bytesFuture);
      final payload = _extractPayload(response);
      return payload;
    }

    if (enableTracing) {
      final start = DateTime.now();
      final result = await _asyncRequest();
      final duration = DateTime.now().difference(start);
      Log.debug('Dispatch ${request.event} took ${duration.inMilliseconds}ms');
      return result;
    }

    return _asyncRequest();
  }
}

UniflowResult<Uint8List, Uint8List> _extractPayload(
  UniflowResult<FFIResponse, UniflowInternalError> response,
) {
  return response.fold(
    (response) {
      switch (response.code) {
        case FFIStatusCode.Ok:
          return UniflowSuccess(Uint8List.fromList(response.payload));
        case FFIStatusCode.Err:
          final errorBytes = Uint8List.fromList(response.payload);
          GlobalErrorCodeNotifier.receiveErrorBytes(errorBytes);
          return UniflowFailure(errorBytes);
        case FFIStatusCode.Internal:
          final error = utf8.decode(response.payload);
          Log.error("Dispatch internal error: $error");
          return UniflowFailure(emptyBytes());
        default:
          Log.error("Impossible to here");
          return UniflowFailure(emptyBytes());
      }
    },
    (error) {
      Log.error("Response should not be empty $error");
      return UniflowFailure(emptyBytes());
    },
  );
}

Future<UniflowResult<FFIResponse, UniflowInternalError>> _extractResponse(
  Completer<Uint8List> bytesFuture,
) async {
  final bytes = await bytesFuture.future;
  try {
    final response = FFIResponse.fromBuffer(bytes);
    return UniflowSuccess(response);
  } catch (e, s) {
    final error = StackTraceError(e, s);
    Log.error('Deserialize response failed. ${error.toString()}');
    return UniflowFailure(error.asUniflowError());
  }
}

Completer<Uint8List> _sendToRust(FFIRequest request) {
  Uint8List bytes = request.writeToBuffer();
  assert(bytes.isEmpty == false);
  if (bytes.isEmpty) {
    throw DispatchException(FFIException.RequestIsEmpty);
  }

  final Pointer<Uint8> input = calloc.allocate<Uint8>(bytes.length);
  final list = input.asTypedList(bytes.length);
  list.setAll(0, bytes);

  final completer = Completer<Uint8List>();
  final port = singleCompletePort(completer);
  ffi.async_event(port.nativePort, input, bytes.length);
  calloc.free(input);

  return completer;
}

Uint8List requestToBytes<T extends GeneratedMessage>(T? message) {
  try {
    if (message != null) {
      return message.writeToBuffer();
    } else {
      return emptyBytes();
    }
  } catch (e, s) {
    final error = StackTraceError(e, s);
    Log.error('Serial request failed. ${error.toString()}');
    return emptyBytes();
  }
}

Uint8List emptyBytes() {
  return Uint8List.fromList([]);
}
