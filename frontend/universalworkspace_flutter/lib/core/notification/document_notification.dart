import 'package:universalworkspace/core/notification/notification_helper.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-document/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';

// This value should be the same as the DOCUMENT_OBSERVABLE_SOURCE value
const String _source = 'Document';

class DocumentNotificationParser
    extends NotificationParser<DocumentNotification, UniflowError> {
  DocumentNotificationParser({
    super.id,
    required super.callback,
  }) : super(
          tyParser: (ty, source) =>
              source == _source ? DocumentNotification.valueOf(ty) : null,
          errorParser: (bytes) => UniflowError.fromBuffer(bytes),
        );
}
