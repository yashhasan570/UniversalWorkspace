import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/sidebar/space/space_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace/workspace/presentation/home/home_sizes.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/create_space_popup.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/space_icon.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarSpaceMenu extends StatelessWidget {
  const SidebarSpaceMenu({
    super.key,
    required this.showCreateButton,
  });

  final bool showCreateButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceBloc, SpaceState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VSpace(4.0),
            for (final space in state.spaces)
              SizedBox(
                height: HomeSpaceViewSizes.viewHeight,
                child: SidebarSpaceMenuItem(
                  space: space,
                  isSelected: state.currentSpace?.id == space.id,
                ),
              ),
            if (showCreateButton) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: UniflowDivider(),
              ),
              const SizedBox(
                height: HomeSpaceViewSizes.viewHeight,
                child: _CreateSpaceButton(),
              ),
            ],
          ],
        );
      },
    );
  }
}

class SidebarSpaceMenuItem extends StatelessWidget {
  const SidebarSpaceMenuItem({
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
          Flexible(
            child: UniflowText.regular(
              space.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const HSpace(6.0),
          if (space.spacePermission == SpacePermission.private)
            UniflowTooltip(
              message: LocaleKeys.space_privatePermissionDescription.tr(),
              child: const UniflowSvg(
                UniflowSvgs.space_lock_s,
              ),
            ),
        ],
      ),
      iconPadding: 10,
      leftIcon: SpaceIcon(
        dimension: 20,
        space: space,
        svgSize: 12.0,
        cornerRadius: 6.0,
      ),
      leftIconSize: const Size.square(20),
      rightIcon: isSelected
          ? const UniflowSvg(
              UniflowSvgs.workspace_selected_s,
              blendMode: null,
            )
          : null,
      onTap: () {
        context.read<SpaceBloc>().add(SpaceEvent.open(space: space));
        PopoverContainer.of(context).close();
      },
    );
  }
}

class _CreateSpaceButton extends StatelessWidget {
  const _CreateSpaceButton();

  @override
  Widget build(BuildContext context) {
    return UniflowButton(
      text: UniflowText.regular(LocaleKeys.space_createNewSpace.tr()),
      iconPadding: 10,
      leftIcon: const UniflowSvg(
        UniflowSvgs.space_add_s,
      ),
      onTap: () {
        PopoverContainer.of(context).close();
        _showCreateSpaceDialog(context);
      },
    );
  }

  void _showCreateSpaceDialog(BuildContext context) {
    final spaceBloc = context.read<SpaceBloc>();
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: BlocProvider.value(
            value: spaceBloc,
            child: const CreateSpacePopup(),
          ),
        );
      },
    );
  }
}
