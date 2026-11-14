import 'package:universalworkspace/startup/launch_configuration.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/application/user_service.dart';
import 'package:universalworkspace/workspace/application/workspace/workspace_service.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/workspace.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:uniflow_infra/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UniversalWorkspaceUnitTest {
  late UserProfilePB userProfile;
  late UserBackendService userService;
  late WorkspaceService workspaceService;
  late WorkspacePB workspace;

  static Future<UniversalWorkspaceUnitTest> ensureInitialized() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    _pathProviderInitialized();

    await UniflowRunner.run(
      UniversalWorkspaceApplicationUnitTest(),
      IntegrationMode.unitTest,
    );

    final test = UniversalWorkspaceUnitTest();
    await test._signIn();
    await test._loadWorkspace();

    await test._initialServices();
    return test;
  }

  Future<void> _signIn() async {
    final authService = getIt<AuthService>();
    const password = "UniversalWorkspace123@";
    final uid = uuid();
    final userEmail = "$uid@universalworkspace.io";
    final result = await authService.signUp(
      name: "TestUser",
      password: password,
      email: userEmail,
    );
    result.fold(
      (user) {
        userProfile = user;
        userService = UserBackendService(userId: userProfile.id);
      },
      (error) {
        assert(false, 'Error: $error');
      },
    );
  }

  WorkspacePB get currentWorkspace => workspace;
  Future<void> _loadWorkspace() async {
    final result = await UserBackendService.getCurrentWorkspace();
    result.fold(
      (value) => workspace = value,
      (error) {
        throw Exception(error);
      },
    );
  }

  Future<void> _initialServices() async {
    workspaceService = WorkspaceService(
      workspaceId: currentWorkspace.id,
      userId: userProfile.id,
    );
  }

  Future<ViewPB> createWorkspace() async {
    final result = await workspaceService.createView(
      name: "Test App",
      viewSection: ViewSectionPB.Public,
    );
    return result.fold(
      (app) => app,
      (error) => throw Exception(error),
    );
  }
}

void _pathProviderInitialized() {
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return '.';
  });
}

class UniversalWorkspaceApplicationUnitTest implements EntryPoint {
  @override
  Widget create(LaunchConfiguration config) {
    return const SizedBox.shrink();
  }
}

Future<void> blocResponseFuture({int millisecond = 200}) {
  return Future.delayed(Duration(milliseconds: millisecond));
}

Duration blocResponseDuration({int milliseconds = 200}) {
  return Duration(milliseconds: milliseconds);
}
