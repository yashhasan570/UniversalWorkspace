import 'package:universalworkspace/features/workspace/logic/workspace_bloc.dart';
import 'package:universalworkspace/mobile/presentation/home/mobile_folders.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileHomeSpace extends StatefulWidget {
  const MobileHomeSpace({super.key, required this.userProfile});

  final UserProfilePB userProfile;

  @override
  State<MobileHomeSpace> createState() => _MobileHomeSpaceState();
}

class _MobileHomeSpaceState extends State<MobileHomeSpace>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final workspaceId =
        context.read<UserWorkspaceBloc>().state.currentWorkspace?.workspaceId ??
            '';
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: HomeSpaceViewSizes.mVerticalPadding,
          bottom: HomeSpaceViewSizes.mVerticalPadding +
              MediaQuery.of(context).padding.bottom,
        ),
        child: MobileFolders(
          user: widget.userProfile,
          workspaceId: workspaceId,
          showFavorite: false,
        ),
      ),
    );
  }
}
