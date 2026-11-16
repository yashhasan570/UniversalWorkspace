import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/uniflow_error_page.dart';
import 'package:universalworkspace/workspace/application/workspace/prelude.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/workspace.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DesktopWorkspaceStartScreen extends StatelessWidget {
  const DesktopWorkspaceStartScreen({super.key, required this.workspaceState});

  final WorkspaceState workspaceState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            _renderBody(workspaceState),
            _renderCreateButton(context),
          ],
        ),
      ),
    );
  }
}

Widget _renderBody(WorkspaceState state) {
  final body = state.successOrFailure.fold(
    (_) => _renderList(state.workspaces),
    (error) => Center(
      child: UniversalWorkspaceErrorPage(
        error: error,
      ),
    ),
  );
  return body;
}

Widget _renderList(List<WorkspacePB> workspaces) {
  return Expanded(
    child: StyledListView(
      itemBuilder: (BuildContext context, int index) {
        final workspace = workspaces[index];
        return _WorkspaceItem(
          workspace: workspace,
          onPressed: (workspace) => _popToWorkspace(context, workspace),
        );
      },
      itemCount: workspaces.length,
    ),
  );
}

class _WorkspaceItem extends StatelessWidget {
  const _WorkspaceItem({
    required this.workspace,
    required this.onPressed,
  });

  final WorkspacePB workspace;
  final void Function(WorkspacePB workspace) onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: UniflowTextButton(
        workspace.name,
        hoverColor: AFThemeExtension.of(context).lightGreyHover,
        fontSize: 14,
        onPressed: () => onPressed(workspace),
      ),
    );
  }
}

Widget _renderCreateButton(BuildContext context) {
  return SizedBox(
    width: 200,
    height: 40,
    child: UniflowTextButton(
      LocaleKeys.workspace_create.tr(),
      fontSize: 14,
      hoverColor: AFThemeExtension.of(context).lightGreyHover,
      onPressed: () {
        // same method as in mobile
        context.read<WorkspaceBloc>().add(
              WorkspaceEvent.createWorkspace(
                LocaleKeys.workspace_hint.tr(),
                "",
              ),
            );
      },
    ),
  );
}

// same method as in mobile
void _popToWorkspace(BuildContext context, WorkspacePB workspace) {
  context.pop(workspace.id);
}
