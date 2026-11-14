abstract class UniflowResult<S, F extends Object> {
  const UniflowResult();

  factory UniflowResult.success(S s) => UniflowSuccess(s);

  factory UniflowResult.failure(F f) => UniflowFailure(f);

  T fold<T>(T Function(S s) onSuccess, T Function(F f) onFailure);

  UniflowResult<T, F> map<T>(T Function(S success) fn);
  UniflowResult<S, T> mapError<T extends Object>(T Function(F failure) fn);

  bool get isSuccess;
  bool get isFailure;

  S? toNullable();

  T? onSuccess<T>(T? Function(S s) onSuccess);
  T? onFailure<T>(T? Function(F f) onFailure);

  S getOrElse(S Function(F failure) onFailure);
  S getOrThrow();

  F getFailure();
}

class UniflowSuccess<S, F extends Object> implements UniflowResult<S, F> {
  final S _value;

  UniflowSuccess(this._value);

  S get value => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniflowSuccess &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Success(value: $_value)';

  @override
  T fold<T>(T Function(S s) onSuccess, T Function(F e) onFailure) =>
      onSuccess(_value);

  @override
  map<T>(T Function(S success) fn) {
    return UniflowSuccess(fn(_value));
  }

  @override
  UniflowResult<S, T> mapError<T extends Object>(T Function(F error) fn) {
    return UniflowSuccess(_value);
  }

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  S? toNullable() {
    return _value;
  }

  @override
  T? onSuccess<T>(T? Function(S success) onSuccess) {
    return onSuccess(_value);
  }

  @override
  T? onFailure<T>(T? Function(F failure) onFailure) {
    return null;
  }

  @override
  S getOrElse(S Function(F failure) onFailure) {
    return _value;
  }

  @override
  S getOrThrow() {
    return _value;
  }

  @override
  F getFailure() {
    throw UnimplementedError();
  }
}

class UniflowFailure<S, F extends Object> implements UniflowResult<S, F> {
  final F _value;

  UniflowFailure(this._value);

  F get error => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniflowFailure &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Failure(error: $_value)';

  @override
  T fold<T>(T Function(S s) onSuccess, T Function(F e) onFailure) =>
      onFailure(_value);

  @override
  map<T>(T Function(S success) fn) {
    return UniflowFailure(_value);
  }

  @override
  UniflowResult<S, T> mapError<T extends Object>(T Function(F error) fn) {
    return UniflowFailure(fn(_value));
  }

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  S? toNullable() {
    return null;
  }

  @override
  T? onSuccess<T>(T? Function(S success) onSuccess) {
    return null;
  }

  @override
  T? onFailure<T>(T? Function(F failure) onFailure) {
    return onFailure(_value);
  }

  @override
  S getOrElse(S Function(F failure) onFailure) {
    return onFailure(_value);
  }

  @override
  S getOrThrow() {
    throw _value;
  }

  @override
  F getFailure() {
    return _value;
  }
}
