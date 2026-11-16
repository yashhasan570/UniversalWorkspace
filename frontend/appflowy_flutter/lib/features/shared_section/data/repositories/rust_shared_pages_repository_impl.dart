import 'package:universalworkspace/features/shared_section/data/repositories/shared_pages_repository.dart';
import 'package:universalworkspace/features/shared_section/models/shared_page.dart';
import 'package:universalworkspace/features/util/extensions.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class RustSharePagesRepositoryImpl implements SharedPagesRepository {
  @override
  Future<UniflowResult<SharedPages, UniflowError>> getSharedPages() async {
    final result = await FolderEventGetSharedViews().send();
    return result.fold(
      (success) {
        final sharedPages = success.sharedPages;

        Log.debug('get shared pages success, len: ${sharedPages.length}');

        return UniflowResult.success(sharedPages);
      },
      (error) {
        Log.error('failed to get shared pages, error: $error');

        return UniflowResult.failure(error);
      },
    );
  }

  @override
  Future<UniflowResult<void, UniflowError>> leaveSharedPage(String pageId) async {
    final user = await UserEventGetUserProfile().send();
    final userEmail = user.fold(
      (success) => success.email,
      (error) => null,
    );

    if (userEmail == null) {
      return UniflowResult.failure(UniflowError(msg: 'User email is null'));
    }

    final request = RemoveUserFromSharedPagePayloadPB(
      viewId: pageId,
      emails: [userEmail],
    );
    final result = await FolderEventRemoveUserFromSharedPage(request).send();

    return result.fold(
      (success) {
        Log.debug('remove user($userEmail) from shared page($pageId)');

        return UniflowSuccess(success);
      },
      (failure) {
        Log.error(
          'remove user($userEmail) from shared page($pageId): $failure',
        );

        return UniflowFailure(failure);
      },
    );
  }
}
