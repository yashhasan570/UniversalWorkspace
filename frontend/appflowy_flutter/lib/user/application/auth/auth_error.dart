import 'package:universalworkspace_backend/protobuf/uniflow-error/code.pbenum.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';

class AuthError {
  static final signInWithOauthError = UniflowError()
    ..msg = 'sign in with oauth error -10003'
    ..code = ErrorCode.UserUnauthorized;

  static final emptyDeepLink = UniflowError()
    ..msg = 'Unexpected empty DeepLink'
    ..code = ErrorCode.UnexpectedCalendarFieldType;

  static final deepLinkError = UniflowError()
    ..msg = 'DeepLink error'
    ..code = ErrorCode.Internal;

  static final unableToGetDeepLink = UniflowError()
    ..msg = 'Unable to get the deep link'
    ..code = ErrorCode.Internal;
}
