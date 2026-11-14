import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/row_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'translate_row_bloc.freezed.dart';

class TranslateRowBloc extends Bloc<TranslateRowEvent, TranslateRowState> {
  TranslateRowBloc({
    required this.viewId,
    required this.rowId,
    required this.fieldId,
  }) : super(TranslateRowState.initial()) {
    _dispatch();
  }

  final String viewId;
  final String rowId;
  final String fieldId;

  void _dispatch() {
    on<TranslateRowEvent>(
      (event, emit) async {
        event.when(
          startTranslate: () {
            final params = TranslateRowPB(
              viewId: viewId,
              rowId: rowId,
              fieldId: fieldId,
            );
            emit(
              state.copyWith(
                loadingState: const LoadingState.loading(),
                error: null,
              ),
            );

            DatabaseEventTranslateRow(params).send().then(
                  (result) => {
                    if (!isClosed)
                      add(TranslateRowEvent.finishTranslate(result)),
                  },
                );
          },
          finishTranslate: (result) {
            result.fold(
              (s) => {
                emit(
                  state.copyWith(
                    loadingState: const LoadingState.finish(),
                    error: null,
                  ),
                ),
              },
              (err) => {
                emit(
                  state.copyWith(
                    loadingState: const LoadingState.finish(),
                    error: err,
                  ),
                ),
              },
            );
          },
        );
      },
    );
  }
}

@freezed
class TranslateRowEvent with _$TranslateRowEvent {
  const factory TranslateRowEvent.startTranslate() = _DidStartTranslate;
  const factory TranslateRowEvent.finishTranslate(
    UniflowResult<void, UniflowError> result,
  ) = _DidFinishTranslate;
}

@freezed
class TranslateRowState with _$TranslateRowState {
  const factory TranslateRowState({
    required LoadingState loadingState,
    required UniflowError? error,
  }) = _TranslateRowState;

  factory TranslateRowState.initial() {
    return const TranslateRowState(
      loadingState: LoadingState.finish(),
      error: null,
    );
  }
}

@freezed
class LoadingState with _$LoadingState {
  const factory LoadingState.loading() = _Loading;
  const factory LoadingState.finish() = _Finish;
}
