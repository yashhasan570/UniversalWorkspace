import 'dart:io';

import 'package:universalworkspace/workspace/application/settings/share/export_service.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-document/entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_bloc.freezed.dart';

class DatabaseShareBloc extends Bloc<DatabaseShareEvent, DatabaseShareState> {
  DatabaseShareBloc({
    required this.view,
  }) : super(const DatabaseShareState.initial()) {
    on<ShareCSV>(_onShareCSV);
  }

  final ViewPB view;

  Future<void> _onShareCSV(
    ShareCSV event,
    Emitter<DatabaseShareState> emit,
  ) async {
    emit(const DatabaseShareState.loading());

    final result = await BackendExportService.exportDatabaseAsCSV(view.id);
    result.fold(
      (l) => _saveCSVToPath(l.data, event.path),
      (r) => Log.error(r),
    );

    emit(
      DatabaseShareState.finish(
        result.fold(
          (l) {
            _saveCSVToPath(l.data, event.path);
            return UniflowResult.success(null);
          },
          (r) => UniflowResult.failure(r),
        ),
      ),
    );
  }

  ExportDataPB _saveCSVToPath(String markdown, String path) {
    File(path).writeAsStringSync(markdown);
    return ExportDataPB()
      ..data = markdown
      ..exportType = ExportType.Markdown;
  }
}

@freezed
class DatabaseShareEvent with _$DatabaseShareEvent {
  const factory DatabaseShareEvent.shareCSV(String path) = ShareCSV;
}

@freezed
class DatabaseShareState with _$DatabaseShareState {
  const factory DatabaseShareState.initial() = _Initial;
  const factory DatabaseShareState.loading() = _Loading;
  const factory DatabaseShareState.finish(
    UniflowResult<void, UniflowError> successOrFail,
  ) = _Finish;
}
