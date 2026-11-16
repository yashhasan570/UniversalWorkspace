import 'package:universalworkspace/features/workspace/logic/workspace_bloc.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/shared/af_role_pb_extension.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/uniflow_icon_emoji_picker.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/tab.dart';
import 'package:universalworkspace/workspace/application/sidebar/space/space_bloc.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/space_action_type.dart';
import 'package:universalworkspace/workspace/presentation/widgets/pop_up_action.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpaceMorePopup extends StatelessWidget {
  const SpaceMorePopup({
    super.key,
    required this.space,
    required this.onAction,
    required this.onEditing,
    this.isHovered = false,
  });

  final ViewPB space;
  final void Function(SpaceMoreActionType type, dynamic data) onAction;
  final void Function(bool value) onEditing;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final wrappers = _buildActionTypeWrappers();
    return PopoverActionList<SpaceMoreActionTypeWrapper>(
      direction: PopoverDirection.bottomWithLeftAligned,
      offset: const Offset(0, 8),
      actions: wrappers,
      constraints: const BoxConstraints(
        minWidth: 260,
      ),
      buildChild: (popover) {
        return UniflowIconButton(
          width: 24,
          icon: UniflowSvg(
            UniflowSvgs.workspace_three_dots_s,
            color: isHovered ? Theme.of(context).colorScheme.onSurface : null,
          ),
          tooltipText: LocaleKeys.space_manage.tr(),
          onPressed: () {
            onEditing(true);
            popover.show();
          },
        );
      },
      onSelected: (_, __) {},
      onClosed: () => onEditing(false),
    );
  }

  List<SpaceMoreActionTypeWrapper> _buildActionTypeWrappers() {
    final actionTypes = _buildActionTypes();
    return actionTypes
        .map(
          (e) => SpaceMoreActionTypeWrapper(e, (controller, data) {
            onAction(e, data);
            controller.close();
          }),
        )
        .toList();
  }

  List<SpaceMoreActionType> _buildActionTypes() {
    return [
      SpaceMoreActionType.rename,
      SpaceMoreActionType.changeIcon,
      SpaceMoreActionType.manage,
      SpaceMoreActionType.duplicate,
      SpaceMoreActionType.divider,
      SpaceMoreActionType.addNewSpace,
      SpaceMoreActionType.collapseAllPages,
      SpaceMoreActionType.divider,
      SpaceMoreActionType.delete,
    ];
  }
}

class SpaceMoreActionTypeWrapper extends CustomActionCell {
  SpaceMoreActionTypeWrapper(this.inner, this.onTap);

  final SpaceMoreActionType inner;
  final void Function(PopoverController controller, dynamic data) onTap;

  @override
  Widget buildWithContext(
    BuildContext context,
    PopoverController controller,
    PopoverMutex? mutex,
  ) {
    if (inner == SpaceMoreActionType.divider) {
      return _buildDivider();
    } else if (inner == SpaceMoreActionType.changeIcon) {
      return _buildEmojiActionButton(context, controller);
    } else {
      return _buildNormalActionButton(context, controller);
    }
  }

  Widget _buildNormalActionButton(
    BuildContext context,
    PopoverController controller,
  ) {
    return _buildActionButton(context, () => onTap(controller, null));
  }

  Widget _buildEmojiActionButton(
    BuildContext context,
    PopoverController controller,
  ) {
    final child = _buildActionButton(context, null);
    return UniversalWorkspacePopover(
      constraints: BoxConstraints.loose(const Size(360, 432)),
      margin: const EdgeInsets.all(0),
      clickHandler: PopoverClickHandler.gestureDetector,
      offset: const Offset(0, -40),
      popupBuilder: (context) {
        return UniflowIconEmojiPicker(
          tabs: const [PickerTabType.icon],
          onSelectedEmoji: (r) => onTap(controller, r),
        );
      },
      child: child,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: UniflowDivider(),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    VoidCallback? onTap,
  ) {
    final spaceBloc = context.read<SpaceBloc>();
    final spaces = spaceBloc.state.spaces;
    final currentSpace = spaceBloc.state.currentSpace;

    final isOwner = context
            .read<UserWorkspaceBloc?>()
            ?.state
            .currentWorkspace
            ?.role
            .isOwner ??
        false;
    final isPageCreator =
        currentSpace?.createdBy == context.read<UserProfilePB>().id;
    final allowToDelete = isOwner || isPageCreator;

    bool disable = false;
    var message = '';
    if (inner == SpaceMoreActionType.delete) {
      if (spaces.length <= 1) {
        disable = true;
        message = LocaleKeys.space_unableToDeleteLastSpace.tr();
      } else if (!allowToDelete) {
        disable = true;
        message = LocaleKeys.space_unableToDeleteSpaceNotCreatedByYou.tr();
      }
    }

    final child = Container(
      height: 34,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Opacity(
        opacity: disable ? 0.3 : 1.0,
        child: UniflowIconTextButton(
          disable: disable,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          iconPadding: 10.0,
          onTap: onTap,
          leftIconBuilder: (onHover) => UniflowSvg(
            inner.leftIconSvg,
            color: inner == SpaceMoreActionType.delete && onHover
                ? Theme.of(context).colorScheme.error
                : null,
          ),
          rightIconBuilder: (_) => inner.rightIcon,
          textBuilder: (onHover) => UniflowText.regular(
            inner.name,
            fontSize: 14.0,
            figmaLineHeight: 18.0,
            color: inner == SpaceMoreActionType.delete && onHover
                ? Theme.of(context).colorScheme.error
                : null,
          ),
        ),
      ),
    );

    if (inner == SpaceMoreActionType.delete) {
      return UniflowTooltip(
        message: message,
        child: child,
      );
    }

    return child;
  }
}
