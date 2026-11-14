import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/application/mobile_router.dart';
import 'package:universalworkspace/mobile/presentation/home/favorite_folder/mobile_home_favorite_folder.dart';
import 'package:universalworkspace/mobile/presentation/widgets/uniflow_mobile_state_container.dart';
import 'package:universalworkspace/workspace/application/favorite/favorite_bloc.dart';
import 'package:universalworkspace/workspace/application/menu/sidebar_sections_bloc.dart';
import 'package:universalworkspace/features/workspace/logic/workspace_bloc.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MobileFavoritePageFolder extends StatelessWidget {
  const MobileFavoritePageFolder({
    super.key,
    required this.userProfile,
  });

  final UserProfilePB userProfile;

  @override
  Widget build(BuildContext context) {
    final workspaceId =
        context.read<UserWorkspaceBloc>().state.currentWorkspace?.workspaceId ??
            '';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SidebarSectionsBloc()
            ..add(SidebarSectionsEvent.initial(userProfile, workspaceId)),
        ),
        BlocProvider(
          create: (_) => FavoriteBloc()..add(const FavoriteEvent.initial()),
        ),
      ],
      child: BlocListener<UserWorkspaceBloc, UserWorkspaceState>(
        listener: (context, state) =>
            context.read<FavoriteBloc>().add(const FavoriteEvent.initial()),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SidebarSectionsBloc, SidebarSectionsState>(
              listenWhen: (p, c) =>
                  p.lastCreatedRootView?.id != c.lastCreatedRootView?.id,
              listener: (context, state) =>
                  context.pushView(state.lastCreatedRootView!),
            ),
          ],
          child: Builder(
            builder: (context) {
              final favoriteState = context.watch<FavoriteBloc>().state;
              if (favoriteState.views.isEmpty) {
                return UniflowMobileStateContainer.info(
                  emoji: '😁',
                  title: LocaleKeys.favorite_noFavorite.tr(),
                  description: LocaleKeys.favorite_noFavoriteHintText.tr(),
                );
              }
              return Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlidableAutoCloseBehavior(
                      child: Column(
                        children: [
                          MobileFavoriteFolder(
                            showHeader: false,
                            forceExpanded: true,
                            views:
                                favoriteState.views.map((e) => e.item).toList(),
                          ),
                          const VSpace(100.0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
