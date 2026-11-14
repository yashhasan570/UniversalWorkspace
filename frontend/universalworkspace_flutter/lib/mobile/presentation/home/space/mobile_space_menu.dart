import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/animated_gesture.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/home/space/space_menu_bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/home/workspaces/create_workspace_menu.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/icon.dart';
import 'package:universalworkspace/shared/icon_emoji_picker/icon_picker.dart';
import 'package:universalworkspace/util/navigator_context_extension.dart';
import 'package:universalworkspace/util/string_extension.dart';
import 'package:universalworkspace/workspace/application/sidebar/space/space_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/space_action_type.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/space_icon.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/space_icon_popup.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart' hide Icon;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'manage_space_widget.dart';

class MobileSpaceMenu extends StatelessWidget {
  const MobileSpaceMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceBloc, SpaceState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VSpace(4.0),
              for (final space in state.spaces)
                SizedBox(
                  height: SpaceUIConstants.itemHeight,
                  child: MobileSpaceMenuItem(
                    space: space,
                    isSelected: state.currentSpace?.id == space.id,
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  height: 0.5,
                ),
              ),
              const SizedBox(
                height: SpaceUIConstants.itemHeight,
                child: _CreateSpaceButton(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MobileSpaceMenuItem extends StatelessWidget {
  const MobileSpaceMenuItem({
    super.key,
    required this.space,
    required this.isSelected,
  });

  final ViewPB space;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      text: Row(
        children: [
          UniflowText.medium(
            space.name,
            fontSize: 16.0,
          ),
          const HSpace(6.0),
          if (space.spacePermission == SpacePermission.private)
            const UniflowSvg(
              UniflowSvgs.space_lock_s,
              size: Size.square(12),
            ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      iconPadding: 10,
      leftIcon: SpaceIcon(
        dimension: 24,
        space: space,
        svgSize: 14,
        textDimension: 18.0,
        cornerRadius: 6.0,
      ),
      leftIconSize: const Size.square(24),
      rightIcon: SpaceMenuItemTrailing(
        key: ValueKey('${space.id}_space_menu_item_trailing'),
        space: space,
        currentSpace: context.read<SpaceBloc>().state.currentSpace,
      ),
      onTap: () {
        context.read<SpaceBloc>().add(SpaceEvent.open(space: space));
        Navigator.of(context).pop();
      },
    );
  }
}

class _CreateSpaceButton extends StatefulWidget {
  const _CreateSpaceButton();

  @override
  State<_CreateSpaceButton> createState() => _CreateSpaceButtonState();
}

class _CreateSpaceButtonState extends State<_CreateSpaceButton> {
  final controller = TextEditingController();
  final permission = ValueNotifier<SpacePermission>(
    SpacePermission.publicToAll,
  );
  final selectedColor = ValueNotifier<String>(
    builtInSpaceColors.first,
  );
  final selectedIcon = ValueNotifier<Icon?>(
    kIconGroups?.first.icons.first,
  );

  @override
  void dispose() {
    controller.dispose();
    permission.dispose();
    selectedColor.dispose();
    selectedIcon.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      text: UniflowText.regular(LocaleKeys.space_createNewSpace.tr()),
      iconPadding: 10,
      leftIcon: const Padding(
        padding: EdgeInsets.all(2.0),
        child: UniflowSvg(
          UniflowSvgs.space_add_s,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      leftIconSize: const Size.square(24),
      onTap: () => _showCreateSpaceDialog(context),
    );
  }

  Future<void> _showCreateSpaceDialog(BuildContext context) async {
    await showMobileBottomSheet(
      context,
      showHeader: true,
      title: LocaleKeys.space_createSpace.tr(),
      showCloseButton: true,
      showDivider: false,
      showDoneButton: true,
      enableScrollable: true,
      showDragHandle: true,
      bottomSheetPadding: context.bottomSheetPadding(),
      onDone: (bottomSheetContext) {
        final iconPath = selectedIcon.value?.iconPath ?? '';
        context.read<SpaceBloc>().add(
              SpaceEvent.create(
                name: controller.text.orDefault(
                  LocaleKeys.space_defaultSpaceName.tr(),
                ),
                permission: permission.value,
                iconColor: selectedColor.value,
                icon: iconPath,
                createNewPageByDefault: true,
                openAfterCreate: false,
              ),
            );
        Navigator.pop(bottomSheetContext);
        Navigator.pop(context);

        Log.info(
          'create space on mobile, name: ${controller.text}, permission: ${permission.value}, color: ${selectedColor.value}, icon: $iconPath',
        );
      },
      padding: const EdgeInsets.symmetric(horizontal: 16),
      builder: (bottomSheetContext) => ManageSpaceWidget(
        controller: controller,
        permission: permission,
        selectedColor: selectedColor,
        selectedIcon: selectedIcon,
        type: ManageSpaceType.create,
      ),
    );

    _resetState();
  }

  void _resetState() {
    controller.clear();
    permission.value = SpacePermission.publicToAll;
    selectedColor.value = builtInSpaceColors.first;
    selectedIcon.value = kIconGroups?.first.icons.first;
  }
}

class SpaceMenuItemTrailing extends StatefulWidget {
  const SpaceMenuItemTrailing({
    super.key,
    required this.space,
    this.currentSpace,
  });

  final ViewPB space;
  final ViewPB? currentSpace;

  @override
  State<SpaceMenuItemTrailing> createState() => _SpaceMenuItemTrailingState();
}

class _SpaceMenuItemTrailingState extends State<SpaceMenuItemTrailing> {
  final controller = TextEditingController();
  final permission = ValueNotifier<SpacePermission>(
    SpacePermission.publicToAll,
  );
  final selectedColor = ValueNotifier<String>(
    builtInSpaceColors.first,
  );
  final selectedIcon = ValueNotifier<Icon?>(
    kIconGroups?.first.icons.first,
  );

  @override
  void dispose() {
    controller.dispose();
    permission.dispose();
    selectedColor.dispose();
    selectedIcon.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = Size.square(20);
    return Row(
      children: [
        const HSpace(12.0),
        // show the check icon if the space is the current space
        if (widget.space.id == widget.currentSpace?.id)
          const UniflowSvg(
            UniflowSvgs.m_blue_check_s,
            size: iconSize,
            blendMode: null,
          ),
        const HSpace(8.0),
        // more options button
        AnimatedGestureDetector(
          onTapUp: () => _showMoreOptions(context),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: UniflowSvg(
              UniflowSvgs.workspace_three_dots_s,
              size: iconSize,
            ),
          ),
        ),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    final actions = [
      SpaceMoreActionType.rename,
      SpaceMoreActionType.duplicate,
      SpaceMoreActionType.manage,
      SpaceMoreActionType.delete,
    ];

    showMobileBottomSheet(
      context,
      showDragHandle: true,
      showDivider: false,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (bottomSheetContext) {
        return SpaceMenuMoreOptions(
          actions: actions,
          onAction: (action) => _onActions(
            context,
            bottomSheetContext,
            action,
          ),
        );
      },
    );
  }

  void _onActions(
    BuildContext context,
    BuildContext bottomSheetContext,
    SpaceMoreActionType action,
  ) {
    Log.info('execute action in space menu bottom sheet: $action');

    switch (action) {
      case SpaceMoreActionType.rename:
        _showRenameSpaceBottomSheet(context);
        break;
      case SpaceMoreActionType.duplicate:
        _duplicateSpace(context, bottomSheetContext);
        break;
      case SpaceMoreActionType.manage:
        _showManageSpaceBottomSheet(context);
        break;
      case SpaceMoreActionType.delete:
        _deleteSpace(context, bottomSheetContext);
        break;
      default:
        assert(false, 'Unsupported action: $action');
        break;
    }
  }

  void _duplicateSpace(BuildContext context, BuildContext bottomSheetContext) {
    Log.info('duplicate the space: ${widget.space.name}');

    context.read<SpaceBloc>().add(const SpaceEvent.duplicate());

    showToastNotification(
      message: LocaleKeys.space_success_duplicateSpace.tr(),
    );

    Navigator.of(bottomSheetContext).pop();
    Navigator.of(context).pop();
  }

  void _showRenameSpaceBottomSheet(BuildContext context) {
    Navigator.of(context).pop();

    showMobileBottomSheet(
      context,
      showHeader: true,
      title: LocaleKeys.space_renameSpace.tr(),
      showCloseButton: true,
      showDragHandle: true,
      showDivider: false,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      builder: (bottomSheetContext) {
        return EditWorkspaceNameBottomSheet(
          type: EditWorkspaceNameType.edit,
          workspaceName: widget.space.name,
          hintText: LocaleKeys.space_spaceNamePlaceholder.tr(),
          validator: (value) => null,
          onSubmitted: (name) {
            // rename the workspace
            Log.info('rename the space, from: ${widget.space.name}, to: $name');
            bottomSheetContext.popToHome();

            context
                .read<SpaceBloc>()
                .add(SpaceEvent.rename(space: widget.space, name: name));

            showToastNotification(
              message: LocaleKeys.space_success_renameSpace.tr(),
            );
          },
        );
      },
    );
  }

  Future<void> _showManageSpaceBottomSheet(BuildContext context) async {
    controller.text = widget.space.name;
    permission.value = widget.space.spacePermission;
    selectedColor.value =
        widget.space.spaceIconColor ?? builtInSpaceColors.first;
    selectedIcon.value = widget.space.spaceIcon?.icon;

    await showMobileBottomSheet(
      context,
      showHeader: true,
      title: LocaleKeys.space_manageSpace.tr(),
      showCloseButton: true,
      showDivider: false,
      showDoneButton: true,
      enableScrollable: true,
      showDragHandle: true,
      bottomSheetPadding: context.bottomSheetPadding(),
      onDone: (bottomSheetContext) {
        String iconName = '';
        final icon = selectedIcon.value;
        final iconGroup = icon?.iconGroup;
        final iconId = icon?.name;
        if (icon != null && iconGroup != null) {
          iconName = '${iconGroup.name}/$iconId';
        }
        Log.info(
          'update space on mobile, name: ${controller.text}, permission: ${permission.value}, color: ${selectedColor.value}, icon: $iconName',
        );
        context.read<SpaceBloc>().add(
              SpaceEvent.update(
                space: widget.space,
                name: controller.text.orDefault(
                  LocaleKeys.space_defaultSpaceName.tr(),
                ),
                permission: permission.value,
                iconColor: selectedColor.value,
                icon: iconName,
              ),
            );

        showToastNotification(
          message: LocaleKeys.space_success_updateSpace.tr(),
        );

        Navigator.pop(bottomSheetContext);
        Navigator.pop(context);
      },
      padding: const EdgeInsets.symmetric(horizontal: 16),
      builder: (bottomSheetContext) => ManageSpaceWidget(
        controller: controller,
        permission: permission,
        selectedColor: selectedColor,
        selectedIcon: selectedIcon,
        type: ManageSpaceType.edit,
      ),
    );
  }

  void _deleteSpace(
    BuildContext context,
    BuildContext bottomSheetContext,
  ) {
    Navigator.of(bottomSheetContext).pop();

    _showConfirmDialog(
      context,
      '${LocaleKeys.space_delete.tr()}: ${widget.space.name}',
      LocaleKeys.space_deleteConfirmationDescription.tr(),
      LocaleKeys.button_delete.tr(),
      (_) async {
        context.read<SpaceBloc>().add(SpaceEvent.delete(widget.space));

        showToastNotification(
          message: LocaleKeys.space_success_deleteSpace.tr(),
        );

        Navigator.pop(context);
      },
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String content,
    String rightButtonText,
    void Function(BuildContext context)? onRightButtonPressed,
  ) {
    showUniflowCupertinoConfirmDialog(
      title: title,
      content: UniflowText(
        content,
        fontSize: 14,
        maxLines: 10,
      ),
      leftButton: UniflowText(
        LocaleKeys.button_cancel.tr(),
        fontSize: 17.0,
        figmaLineHeight: 24.0,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF007AFF),
      ),
      rightButton: UniflowText(
        rightButtonText,
        fontSize: 17.0,
        figmaLineHeight: 24.0,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFFE0220),
      ),
      onRightButtonPressed: onRightButtonPressed,
    );
  }
}
