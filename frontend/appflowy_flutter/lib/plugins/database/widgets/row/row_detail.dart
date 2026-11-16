import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/application/database_controller.dart';
import 'package:universalworkspace/plugins/database/application/row/row_controller.dart';
import 'package:universalworkspace/plugins/database/domain/database_view_service.dart';
import 'package:universalworkspace/plugins/database/grid/application/row/row_detail_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/row/row_document.dart';
import 'package:universalworkspace/plugins/database_document/database_document_plugin.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_drop_manager.dart';
import 'package:universalworkspace/startup/plugin/plugin.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/reminder/reminder_bloc.dart';
import 'package:universalworkspace/workspace/application/tabs/tabs_bloc.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../cell/editable_cell_builder.dart';
import 'row_banner.dart';
import 'row_property.dart';

class RowDetailPage extends StatefulWidget with UniflowOverlayDelegate {
  const RowDetailPage({
    super.key,
    required this.rowController,
    required this.databaseController,
    this.allowOpenAsFullPage = true,
    this.userProfile,
  });

  final RowController rowController;
  final DatabaseController databaseController;
  final bool allowOpenAsFullPage;
  final UserProfilePB? userProfile;

  @override
  State<RowDetailPage> createState() => _RowDetailPageState();
}

class _RowDetailPageState extends State<RowDetailPage> {
  // To allow blocking drop target in RowDocument from Field dialogs
  final dropManagerState = EditorDropManagerState();

  late final cellBuilder = EditableCellBuilder(
    databaseController: widget.databaseController,
  );
  late final ScrollController scrollController;

  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(onAttach: (_) => attachScrollListener());
  }

  void attachScrollListener() => scrollController.addListener(onScrollChanged);

  @override
  void dispose() {
    scrollController.removeListener(onScrollChanged);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UniflowDialog(
      child: ChangeNotifierProvider.value(
        value: dropManagerState,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => RowDetailBloc(
                fieldController: widget.databaseController.fieldController,
                rowController: widget.rowController,
              ),
            ),
            BlocProvider.value(value: getIt<ReminderBloc>()),
          ],
          child: BlocBuilder<RowDetailBloc, RowDetailState>(
            builder: (context, state) => Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              RowBanner(
                                databaseController: widget.databaseController,
                                rowController: widget.rowController,
                                cellBuilder: cellBuilder,
                                allowOpenAsFullPage: widget.allowOpenAsFullPage,
                                userProfile: widget.userProfile,
                              ),
                              const VSpace(16),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 60),
                                child: RowPropertyList(
                                  cellBuilder: cellBuilder,
                                  viewId: widget.databaseController.viewId,
                                  fieldController:
                                      widget.databaseController.fieldController,
                                ),
                              ),
                              const VSpace(20),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60),
                                child: Divider(height: 1.0),
                              ),
                              const VSpace(20),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: RowDocument(
                      viewId: widget.rowController.viewId,
                      rowId: widget.rowController.rowId,
                    ),
                  ),
                ),
                Positioned(
                  top: calculateActionsOffset(
                    state.rowMeta.cover.data.isNotEmpty,
                  ),
                  right: 12,
                  child: Row(children: actions(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onScrollChanged() {
    if (scrollOffset != scrollController.offset) {
      setState(() => scrollOffset = scrollController.offset);
    }
  }

  double calculateActionsOffset(bool hasCover) {
    if (!hasCover) {
      return 12;
    }

    final offsetByScroll = clampDouble(
      rowCoverHeight - scrollOffset,
      0,
      rowCoverHeight,
    );
    return 12 + offsetByScroll;
  }

  List<Widget> actions(BuildContext context) {
    return [
      if (widget.allowOpenAsFullPage) ...[
        UniflowTooltip(
          message: LocaleKeys.grid_rowPage_openAsFullPage.tr(),
          child: UniflowIconButton(
            width: 20,
            height: 20,
            icon: const UniflowSvg(UniflowSvgs.full_view_s),
            iconColorOnHover: Theme.of(context).colorScheme.onSurface,
            onPressed: () async {
              Navigator.of(context).pop();
              final databaseId = await DatabaseViewBackendService(
                viewId: widget.databaseController.viewId,
              )
                  .getDatabaseId()
                  .then((value) => value.fold((s) => s, (f) => null));
              final documentId = widget.rowController.rowMeta.documentId;
              if (databaseId != null) {
                getIt<TabsBloc>().add(
                  TabsEvent.openPlugin(
                    plugin: DatabaseDocumentPlugin(
                      data: DatabaseDocumentContext(
                        view: widget.databaseController.view,
                        databaseId: databaseId,
                        rowId: widget.rowController.rowId,
                        documentId: documentId,
                      ),
                      pluginType: PluginType.databaseDocument,
                    ),
                    setLatest: false,
                  ),
                );
              }
            },
          ),
        ),
        const HSpace(4),
      ],
      RowActionButton(rowController: widget.rowController),
    ];
  }
}
