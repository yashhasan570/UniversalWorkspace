import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/presentation/screens/workspace_start_screen/desktop_workspace_start_screen.dart';
import 'package:universalworkspace/user/presentation/screens/workspace_start_screen/mobile_workspace_start_screen.dart';
import 'package:universalworkspace/workspace/application/workspace/workspace_bloc.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_platform/universal_platform.dart';

// For future use
class WorkspaceStartScreen extends StatelessWidget {
  /// To choose which screen is going to open
  const WorkspaceStartScreen({super.key, required this.userProfile});

  final UserProfilePB userProfile;

  static const routeName = "/WorkspaceStartScreen";
  static const argUserProfile = "userProfile";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkspaceBloc>(param1: userProfile)
        ..add(const WorkspaceEvent.initial()),
      child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
        builder: (context, state) {
          if (UniversalPlatform.isMobile) {
            return MobileWorkspaceStartScreen(
              workspaceState: state,
            );
          }
          return DesktopWorkspaceStartScreen(
            workspaceState: state,
          );
        },
      ),
    );
  }
}
