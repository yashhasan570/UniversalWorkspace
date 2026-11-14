import 'package:universalworkspace/features/share_tab/data/models/share_access_level.dart';
import 'package:universalworkspace/features/shared_section/models/shared_page.dart';
import 'package:universalworkspace/features/shared_section/presentation/widgets/shared_page_actions_button.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/workspace/application/sidebar/folder/folder_bloc.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/view/view_item.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';

/// Shared pages on desktop
class SharedPageList extends StatelessWidget {
  const SharedPageList({
    super.key,
    required this.sharedPages,
    required this.onAction,
    required this.onSelected,
    required this.onTertiarySelected,
    required this.onSetEditing,
  });

  final SharedPages sharedPages;
  final ViewItemOnSelected onSelected;
  final ViewItemOnSelected onTertiarySelected;
  final SharedPageActionsButtonCallback onAction;
  final SharedPageActionsButtonSetEditingCallback onSetEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sharedPages.map((sharedPage) {
        final view = sharedPage.view;
        final accessLevel = sharedPage.accessLevel;
        return ViewItem(
          key: ValueKey(view.id),
          spaceType: FolderSpaceType.public,
          isFirstChild: view.id == sharedPages.first.view.id,
          view: view,
          level: 0,
          isDraggable: false, // disable draggable for shared pages
          leftPadding: HomeSpaceViewSizes.leftPadding,
          isFeedback: false,
          onSelected: onSelected,
          onTertiarySelected: onTertiarySelected,
          rightIconsBuilder: (context, view) => [
            IntrinsicWidth(
              child: _buildSharedPageMoreActionButton(
                context,
                view,
                accessLevel,
              ),
            ),
            const SizedBox(width: 4.0),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSharedPageMoreActionButton(
    BuildContext context,
    ViewPB view,
    ShareAccessLevel accessLevel,
  ) {
    return SharedPageActionsButton(
      view: view,
      accessLevel: accessLevel,
      onAction: onAction,
      onSetEditing: onSetEditing,
      buildChild: (controller) => UniflowIconButton(
        width: 24,
        icon: const UniflowSvg(UniflowSvgs.workspace_three_dots_s),
        onPressed: () {
          onSetEditing(context, true);
          controller.show();
        },
      ),
    );
  }
}
