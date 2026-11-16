import 'package:universalworkspace/features/shared_section/models/shared_page.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// Abstract repository for sharing pages with users.
///
/// For example, we're using rust events now, but we can still use the http api
/// for the future.
abstract class SharedPagesRepository {
  /// Gets the list of users and their roles for a shared page.
  Future<UniflowResult<SharedPages, UniflowError>> getSharedPages();

  /// Removes a shared page from the repository.
  Future<UniflowResult<void, UniflowError>> leaveSharedPage(String pageId);
}
