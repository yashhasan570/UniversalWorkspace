import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/util/theme_extension.dart';
import 'package:universalworkspace/workspace/application/sidebar/space/space_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpaceMigration extends StatefulWidget {
  const SpaceMigration({super.key});

  @override
  State<SpaceMigration> createState() => _SpaceMigrationState();
}

class _SpaceMigrationState extends State<SpaceMigration> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Theme.of(context).isLightMode
            ? const Color(0x66F5EAFF)
            : const Color(0x1AFFFFFF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0x339327FF),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isExpanded
          ? _buildExpandedMigrationContent()
          : _buildCollapsedMigrationContent(),
    );
  }

  Widget _buildExpandedMigrationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MigrationTitle(
          onClose: () => setState(() => _isExpanded = false),
        ),
        const VSpace(6.0),
        Opacity(
          opacity: 0.7,
          child: UniflowText.regular(
            LocaleKeys.space_upgradeSpaceDescription.tr(),
            maxLines: null,
            fontSize: 13.0,
            lineHeight: 1.3,
          ),
        ),
        const VSpace(12.0),
        _ExpandedUpgradeButton(
          onUpgrade: () =>
              context.read<SpaceBloc>().add(const SpaceEvent.migrate()),
        ),
      ],
    );
  }

  Widget _buildCollapsedMigrationContent() {
    const linearGradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8032FF), Color(0xFFEF35FF)],
      stops: [0.1545, 0.8225],
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => setState(() => _isExpanded = true),
      child: Row(
        children: [
          const UniflowSvg(
            UniflowSvgs.upgrade_s,
            blendMode: null,
          ),
          const HSpace(8.0),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) =>
                  linearGradient.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: UniflowText(
                LocaleKeys.space_upgradeYourSpace.tr(),
              ),
            ),
          ),
          const UniflowSvg(
            UniflowSvgs.space_arrow_right_s,
            blendMode: null,
          ),
        ],
      ),
    );
  }
}

class _MigrationTitle extends StatelessWidget {
  const _MigrationTitle({required this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UniflowSvg(
          UniflowSvgs.upgrade_s,
          blendMode: null,
        ),
        const HSpace(8.0),
        Expanded(
          child: UniflowText(
            LocaleKeys.space_upgradeSpaceTitle.tr(),
            maxLines: 3,
            lineHeight: 1.2,
          ),
        ),
      ],
    );
  }
}

class _ExpandedUpgradeButton extends StatelessWidget {
  const _ExpandedUpgradeButton({required this.onUpgrade});

  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onUpgrade,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: ShapeDecoration(
          color: const Color(0xFFA44AFD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: UniflowText(
          LocaleKeys.space_upgrade.tr(),
          color: Colors.white,
          fontSize: 12.0,
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
      ),
    );
  }
}
