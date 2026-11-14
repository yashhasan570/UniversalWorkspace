import 'package:universalworkspace/features/page_access_level/logic/page_access_level_bloc.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/button.dart';
import 'package:uniflow_infra_ui/style_widget/text.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LockPageAction extends StatefulWidget {
  const LockPageAction({
    super.key,
    required this.view,
  });

  final ViewPB view;

  @override
  State<LockPageAction> createState() => _LockPageActionState();
}

class _LockPageActionState extends State<LockPageAction> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageAccessLevelBloc, PageAccessLevelState>(
      builder: (context, state) {
        return _buildTextButton(context);
      },
    );
  }

  Widget _buildTextButton(
    BuildContext context,
  ) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: UniflowIconTextButton(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        onTap: () => _toggle(context),
        leftIconBuilder: (onHover) => UniflowSvg(
          UniflowSvgs.lock_page_s,
          size: const Size.square(16.0),
        ),
        iconPadding: 10.0,
        textBuilder: (onHover) => UniflowText(
          LocaleKeys.disclosureAction_lockPage.tr(),
          figmaLineHeight: 18.0,
        ),
        rightIconBuilder: (_) => _buildSwitch(
          context,
        ),
      ),
    );
  }

  Widget _buildSwitch(BuildContext context) {
    final lockState = context.read<PageAccessLevelBloc>().state;
    if (lockState.isLoadingLockStatus) {
      return SizedBox.shrink();
    }

    return Container(
      width: 30,
      height: 20,
      margin: const EdgeInsets.only(right: 6),
      child: FittedBox(
        fit: BoxFit.fill,
        child: CupertinoSwitch(
          value: lockState.isLocked,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          onChanged: (_) => _toggle(context),
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context) async {
    final isLocked = context.read<PageAccessLevelBloc>().state.isLocked;

    context.read<PageAccessLevelBloc>().add(
          isLocked
              ? PageAccessLevelEvent.unlock()
              : PageAccessLevelEvent.lock(),
        );

    Log.info('update page(${widget.view.id}) lock status: $isLocked');
  }
}

class LockPageButtonWrapper extends StatelessWidget {
  const LockPageButtonWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UniflowTooltip(
      message: LocaleKeys.lockPage_lockedOperationTooltip.tr(),
      child: IgnorePointer(
        child: child,
      ),
    );
  }
}
