import 'package:universalworkspace/plugins/ai_chat/chat.dart';
import 'package:universalworkspace/workspace/application/view/view_service.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';

import '../../util.dart';

class UniversalWorkspaceChatTest {
  UniversalWorkspaceChatTest({required this.unitTest});

  final UniversalWorkspaceUnitTest unitTest;

  static Future<UniversalWorkspaceChatTest> ensureInitialized() async {
    final inner = await UniversalWorkspaceUnitTest.ensureInitialized();
    return UniversalWorkspaceChatTest(unitTest: inner);
  }

  Future<ViewPB> createChat() async {
    final app = await unitTest.createWorkspace();
    final builder = AIChatPluginBuilder();
    return ViewBackendService.createView(
      parentViewId: app.id,
      name: "Test Chat",
      layoutType: builder.layoutType,
      openAfterCreate: true,
    ).then((result) {
      return result.fold(
        (view) async {
          return view;
        },
        (error) {
          throw Exception();
        },
      );
    });
  }
}
