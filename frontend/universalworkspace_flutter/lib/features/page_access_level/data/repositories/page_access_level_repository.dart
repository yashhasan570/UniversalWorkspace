import 'package:universalworkspace/features/share_tab/data/models/models.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// Abstract repository for managing view lock status.
///
/// For example, we're using rust events now, but we can still use the http api
/// for the future.
abstract class PageAccessLevelRepository {
  /// Gets the current view from the backend.
  Future<UniflowResult<ViewPB, UniflowError>> getView(String pageId);

  /// Locks the view.
  Future<UniflowResult<void, UniflowError>> lockView(String pageId);

  /// Unlocks the view.
  Future<UniflowResult<void, UniflowError>> unlockView(String pageId);

  /// Gets the access level of the current user.
  Future<UniflowResult<ShareAccessLevel, UniflowError>> getAccessLevel(
    String pageId,
  );

  /// Gets the section type of the shared section.
  Future<UniflowResult<SharedSectionType, UniflowError>> getSectionType(
    String pageId,
  );

  /// Get current workspace
  Future<UniflowResult<UserWorkspacePB, UniflowError>> getCurrentWorkspace();
}
