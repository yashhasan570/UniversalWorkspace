import 'package:universalworkspace/features/shared_section/data/repositories/rust_shared_pages_repository_impl.dart';
import 'package:universalworkspace/features/shared_section/logic/shared_section_bloc.dart';
import 'package:universalworkspace/features/shared_section/presentation/widgets/refresh_button.dart';
import 'package:universalworkspace/features/shared_section/presentation/widgets/shared_page_list.dart';
import 'package:universalworkspace/features/shared_section/presentation/widgets/shared_section_error.dart';
import 'package:universalworkspace/features/shared_section/presentation/widgets/shared_section_header.dart';
import 'package:universalworkspace/features/shared_section/presentation/widgets/shared_section_loading.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/workspace/application/favorite/favorite_bloc.dart';
import 'package:universalworkspace/workspace/application/tabs/tabs_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_bloc.dart';
import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace/workspace/application/view/view_service.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/sidebar/space/shared_widget.dart';
import 'package:universalworkspace/workspace/presentation/home/menu/view/view_action_type.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialog_v2.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/widget/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharedSection extends StatelessWidget {
  const SharedSection({
    super.key,
    required this.workspaceId,
  });

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    final theme = UniversalWorkspaceTheme.of(context);
    final repository = RustSharePagesRepositoryImpl();

    return BlocProvider(
      create: (_) => SharedSectionBloc(
        workspaceId: workspaceId,
        repository: repository,
        enablePolling: true,
      )..add(const SharedSectionInitEvent()),
      child: BlocBuilder<SharedSectionBloc, SharedSectionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SharedSectionLoading();
          }

          if (state.errorMessage.isNotEmpty) {
            return SharedSectionError(errorMessage: state.errorMessage);
          }

          // hide the shared section if there are no shared pages
          if (state.sharedPages.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shared header
              SharedSectionHeader(
                onTap: () {
                  // expand or collapse the shared section
                  context.read<SharedSectionBloc>().add(
                        const SharedSectionToggleExpandedEvent(),
                      );
                },
              ),

              // Shared pages list
              if (state.isExpanded)
                SharedPageList(
                  sharedPages: state.sharedPages,
                  onSetEditing: (context, value) {
                    context.read<ViewBloc>().add(ViewEvent.setIsEditing(value));
                  },
                  onAction: (action, view, data) async {
                    switch (action) {
                      case ViewMoreActionType.favorite:
                      case ViewMoreActionType.unFavorite:
                        context
                            .read<FavoriteBloc>()
                            .add(FavoriteEvent.toggle(view));
                        break;
                      case ViewMoreActionType.openInNewTab:
                        context.read<TabsBloc>().openTab(view);
                        break;
                      case ViewMoreActionType.rename:
                        await showAFTextFieldDialog(
                          context: context,
                          title: LocaleKeys.disclosureAction_rename.tr(),
                          initialValue: view.nameOrDefault,
                          maxLength: 256,
                          onConfirm: (newValue) {
                            // can not use bloc here because it has been disposed.
                            ViewBackendService.updateView(
                              viewId: view.id,
                              name: newValue,
                            );
                          },
                        );
                        break;
                      case ViewMoreActionType.leaveSharedPage:
                        // show a dialog to confirm the action
                        await showConfirmDialog(
                          context: context,
                          title: 'Remove your own access',
                          titleStyle: theme.textStyle.body.standard(
                            color: theme.textColorScheme.primary,
                          ),
                          description: '',
                          style: ConfirmPopupStyle.cancelAndOk,
                          confirmLabel: 'Remove',
                          onConfirm: (_) {
                            context.read<SharedSectionBloc>().add(
                                  SharedSectionEvent.leaveSharedPage(
                                    pageId: view.id,
                                  ),
                                );
                          },
                        );
                        break;
                      default:
                        // Other actions are not allowed for read-only access
                        break;
                    }
                  },
                  onSelected: (context, view) {
                    if (HardwareKeyboard.instance.isControlPressed) {
                      context.read<TabsBloc>().openTab(view);
                    }
                    context.read<TabsBloc>().openPlugin(view);
                  },
                  onTertiarySelected: (context, view) {
                    context.read<TabsBloc>().openTab(view);
                  },
                ),

              // Refresh button, for debugging only
              if (kDebugMode)
                RefreshSharedSectionButton(
                  onTap: () {
                    context.read<SharedSectionBloc>().add(
                          const SharedSectionEvent.refresh(),
                        );
                  },
                ),

              const VSpace(16.0),
            ],
          );
        },
      ),
    );
  }
}
