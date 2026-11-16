import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/favorite/favorite_bloc.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/style_widget/hover.dart';
import 'package:uniflow_infra_ui/widget/uniflow_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewFavoriteButton extends StatelessWidget {
  const ViewFavoriteButton({
    super.key,
    required this.view,
  });

  final ViewPB view;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state.views.any((v) => v.item.id == view.id);
        return Listener(
          onPointerDown: (_) =>
              context.read<FavoriteBloc>().add(FavoriteEvent.toggle(view)),
          child: UniflowTooltip(
            message: isFavorite
                ? LocaleKeys.button_removeFromFavorites.tr()
                : LocaleKeys.button_addToFavorites.tr(),
            child: UniflowHover(
              resetHoverOnRebuild: false,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: UniflowSvg(
                  isFavorite ? UniflowSvgs.favorited_s : UniflowSvgs.favorite_s,
                  size: const Size.square(18),
                  blendMode: isFavorite ? null : BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
