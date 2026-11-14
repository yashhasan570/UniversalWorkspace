import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/application/document_bloc.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/insert_page_command.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/base/selectable_svg_widget.dart';
import 'package:universalworkspace/workspace/application/view/view_service.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';

SelectionMenuItem inlineGridMenuItem(DocumentBloc documentBloc) =>
    SelectionMenuItem(
      getName: LocaleKeys.document_slashMenu_grid_createANewGrid.tr,
      icon: (editorState, onSelected, style) => SelectableSvgWidget(
        data: UniflowSvgs.grid_s,
        isSelected: onSelected,
        style: style,
      ),
      keywords: ['grid', 'database'],
      handler: (editorState, menuService, context) async {
        // create the view inside current page
        final parentViewId = documentBloc.documentId;
        final value = await ViewBackendService.createView(
          parentViewId: parentViewId,
          name: LocaleKeys.menuAppHeader_defaultNewPageName.tr(),
          layoutType: ViewLayoutPB.Grid,
        );
        value.map((r) => editorState.insertInlinePage(parentViewId, r));
      },
    );

SelectionMenuItem inlineBoardMenuItem(DocumentBloc documentBloc) =>
    SelectionMenuItem(
      getName: LocaleKeys.document_slashMenu_board_createANewBoard.tr,
      icon: (editorState, onSelected, style) => SelectableSvgWidget(
        data: UniflowSvgs.board_s,
        isSelected: onSelected,
        style: style,
      ),
      keywords: ['board', 'kanban', 'database'],
      handler: (editorState, menuService, context) async {
        // create the view inside current page
        final parentViewId = documentBloc.documentId;
        final value = await ViewBackendService.createView(
          parentViewId: parentViewId,
          name: LocaleKeys.menuAppHeader_defaultNewPageName.tr(),
          layoutType: ViewLayoutPB.Board,
        );
        value.map((r) => editorState.insertInlinePage(parentViewId, r));
      },
    );

SelectionMenuItem inlineCalendarMenuItem(DocumentBloc documentBloc) =>
    SelectionMenuItem(
      getName: LocaleKeys.document_slashMenu_calendar_createANewCalendar.tr,
      icon: (editorState, onSelected, style) => SelectableSvgWidget(
        data: UniflowSvgs.date_s,
        isSelected: onSelected,
        style: style,
      ),
      keywords: ['calendar', 'database'],
      handler: (editorState, menuService, context) async {
        // create the view inside current page
        final parentViewId = documentBloc.documentId;
        final value = await ViewBackendService.createView(
          parentViewId: parentViewId,
          name: LocaleKeys.menuAppHeader_defaultNewPageName.tr(),
          layoutType: ViewLayoutPB.Calendar,
        );
        value.map((r) => editorState.insertInlinePage(parentViewId, r));
      },
    );
