import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/workspace/application/sidebar/space/space_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SpacePermissionBottomSheet extends StatelessWidget {
  const SpacePermissionBottomSheet({
    super.key,
    required this.onAction,
    required this.permission,
  });

  final SpacePermission permission;
  final void Function(SpacePermission action) onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UniflowOptionTile.text(
          text: LocaleKeys.space_publicPermission.tr(),
          leftIcon: const UniflowSvg(
            UniflowSvgs.space_permission_public_s,
          ),
          trailing: permission == SpacePermission.publicToAll
              ? const UniflowSvg(
                  UniflowSvgs.m_blue_check_s,
                  blendMode: null,
                )
              : null,
          onTap: () => onAction(SpacePermission.publicToAll),
        ),
        UniflowOptionTile.text(
          text: LocaleKeys.space_privatePermission.tr(),
          showTopBorder: false,
          leftIcon: const UniflowSvg(
            UniflowSvgs.space_permission_private_s,
          ),
          trailing: permission == SpacePermission.private
              ? const UniflowSvg(
                  UniflowSvgs.m_blue_check_s,
                  blendMode: null,
                )
              : null,
          onTap: () => onAction(SpacePermission.private),
        ),
      ],
    );
  }
}
