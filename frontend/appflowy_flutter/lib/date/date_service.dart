import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-date/entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class DateService {
  static Future<UniflowResult<DateTime, UniflowError>> queryDate(
    String search,
  ) async {
    final query = DateQueryPB.create()..query = search;
    final result = await DateEventQueryDate(query).send();
    return result.fold(
      (s) {
        final date = DateTime.tryParse(s.date);
        if (date != null) {
          return UniflowResult.success(date);
        }
        return UniflowResult.failure(
          UniflowError(msg: 'Could not parse Date (NLP) from String'),
        );
      },
      (e) => UniflowResult.failure(e),
    );
  }
}
