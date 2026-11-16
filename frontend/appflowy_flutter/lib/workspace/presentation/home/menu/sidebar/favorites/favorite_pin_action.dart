import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/favorite/favorite_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritePinAction extends StatelessWidget {
  const FavoritePinAction({super.key, required this.view});

  final ViewPB view;

  @override
  Widget build(BuildContext context) {
    final tooltip = view.isPinned
        ? LocaleKeys.favorite_removeFromSidebar.tr()
        : LocaleKeys.favorite_addToSidebar.tr();
    final icon = UniflowSvg(
      view.isPinned
          ? UniflowSvgs.favorite_section_unpin_s
          : UniflowSvgs.favorite_section_pin_s,
    );
    return UniflowTooltip(
      message: tooltip,
      child: UniflowIconButton(
        width: 24,
        icon: icon,
        onPressed: () {
          view.isPinned
              ? context.read<FavoriteBloc>().add(FavoriteEvent.unpin(view))
              : context.read<FavoriteBloc>().add(FavoriteEvent.pin(view));
        },
      ),
    );
  }
}
