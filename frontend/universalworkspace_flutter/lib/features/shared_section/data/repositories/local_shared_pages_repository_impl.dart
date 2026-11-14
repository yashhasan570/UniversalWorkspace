import 'package:universalworkspace/features/share_tab/data/models/share_access_level.dart';
import 'package:universalworkspace/features/shared_section/data/repositories/shared_pages_repository.dart';
import 'package:universalworkspace/features/shared_section/models/shared_page.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

// Move this file to test folder
class LocalSharedPagesRepositoryImpl implements SharedPagesRepository {
  @override
  Future<UniflowResult<SharedPages, UniflowError>> getSharedPages() async {
    final pages = [
      SharedPage(
        view: ViewPB()
          ..id = '1'
          ..name = 'Welcome Page',
        accessLevel: ShareAccessLevel.fullAccess,
      ),
      SharedPage(
        view: ViewPB()
          ..id = '2'
          ..name = 'Project Plan',
        accessLevel: ShareAccessLevel.readAndWrite,
      ),
      SharedPage(
        view: ViewPB()
          ..id = '3'
          ..name = 'Readme',
        accessLevel: ShareAccessLevel.readOnly,
      ),
    ];
    return UniflowResult.success(pages);
  }

  @override
  Future<UniflowResult<void, UniflowError>> leaveSharedPage(String pageId) async {
    return UniflowResult.success(null);
  }
}
