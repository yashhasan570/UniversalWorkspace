import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/domain/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial()) {
    on<SplashEvent>((event, emit) async {
      await event.map(
        getUser: (val) async {
          final response = await getIt<AuthService>().getUser();
          final authState = response.fold(
            (user) => AuthState.authenticated(user),
            (error) => AuthState.unauthenticated(error),
          );
          emit(state.copyWith(auth: authState));
        },
      );
    });
  }
}

@freezed
class SplashEvent with _$SplashEvent {
  const factory SplashEvent.getUser() = _GetUser;
}

@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    required AuthState auth,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState(
        auth: AuthState.initial(),
      );
}
