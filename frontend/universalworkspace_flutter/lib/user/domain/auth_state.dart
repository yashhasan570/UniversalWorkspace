import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart'
    show UserProfilePB;
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated(UserProfilePB userProfile) =
      Authenticated;
  const factory AuthState.unauthenticated(UniflowError error) = Unauthenticated;
  const factory AuthState.initial() = _Initial;
}
