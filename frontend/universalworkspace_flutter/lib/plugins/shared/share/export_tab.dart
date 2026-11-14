import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/copy_and_paste/clipboard_service.dart';
import 'package:universalworkspace/plugins/shared/share/share_bloc.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/util/string_extension.dart';
import 'package:universalworkspace/util/theme_extension.dart';
import 'package:universalworkspace/workspace/application/export/document_exporter.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/file_picker/file_picker_service.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportTab extends StatelessWidget {
  const ExportTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final view = context.read<ShareBloc>().view;

    if (view.layout == ViewLayoutPB.Document) {
      return _buildDocumentExportTab(context);
    }

    return _buildDatabaseExportTab(context);
  }

  Widget _buildDocumentExportTab(BuildContext context) {
    return Column(
      children: [
        const VSpace(10),
        _ExportButton(
          title: LocaleKeys.shareAction_html.tr(),
          svg: UniflowSvgs.export_html_s,
          onTap: () => _exportHTML(context),
        ),
        const VSpace(10),
        _ExportButton(
          title: LocaleKeys.shareAction_markdown.tr(),
          svg: UniflowSvgs.export_markdown_s,
          onTap: () => _exportMarkdown(context),
        ),
        const VSpace(10),
        _ExportButton(
          title: LocaleKeys.shareAction_clipboard.tr(),
          svg: UniflowSvgs.duplicate_s,
          onTap: () => _exportToClipboard(context),
        ),
        if (kDebugMode) ...[
          const VSpace(10),
          _ExportButton(
            title: 'JSON (Debug Mode)',
            svg: UniflowSvgs.duplicate_s,
            onTap: () => _exportJSON(context),
          ),
        ],
      ],
    );
  }

  Widget _buildDatabaseExportTab(BuildContext context) {
    return Column(
      children: [
        const VSpace(10),
        _ExportButton(
          title: LocaleKeys.shareAction_csv.tr(),
          svg: UniflowSvgs.database_layout_s,
          onTap: () => _exportCSV(context),
        ),
        if (kDebugMode) ...[
          const VSpace(10),
          _ExportButton(
            title: 'Raw Database Data (Debug Mode)',
            svg: UniflowSvgs.duplicate_s,
            onTap: () => _exportRawDatabaseData(context),
          ),
        ],
      ],
    );
  }

  Future<void> _exportHTML(BuildContext context) async {
    final viewName = context.read<ShareBloc>().state.viewName;
    final exportPath = await getIt<FilePickerService>().saveFile(
      dialogTitle: '',
      fileName: '${viewName.toFileName()}.html',
    );
    if (context.mounted && exportPath != null) {
      context.read<ShareBloc>().add(
            ShareEvent.share(
              ShareType.html,
              exportPath,
            ),
          );
    }
  }

  Future<void> _exportMarkdown(BuildContext context) async {
    final viewName = context.read<ShareBloc>().state.viewName;
    final exportPath = await getIt<FilePickerService>().saveFile(
      dialogTitle: '',
      fileName: '${viewName.toFileName()}.zip',
    );
    if (context.mounted && exportPath != null) {
      context.read<ShareBloc>().add(
            ShareEvent.share(
              ShareType.markdown,
              exportPath,
            ),
          );
    }
  }

  Future<void> _exportJSON(BuildContext context) async {
    final viewName = context.read<ShareBloc>().state.viewName;
    final exportPath = await getIt<FilePickerService>().saveFile(
      dialogTitle: '',
      fileName: '${viewName.toFileName()}.json',
    );
    if (context.mounted && exportPath != null) {
      context.read<ShareBloc>().add(
            ShareEvent.share(
              ShareType.json,
              exportPath,
            ),
          );
    }
  }

  Future<void> _exportCSV(BuildContext context) async {
    final viewName = context.read<ShareBloc>().state.viewName;
    final exportPath = await getIt<FilePickerService>().saveFile(
      dialogTitle: '',
      fileName: '${viewName.toFileName()}.csv',
    );
    if (context.mounted && exportPath != null) {
      context.read<ShareBloc>().add(
            ShareEvent.share(
              ShareType.csv,
              exportPath,
            ),
          );
    }
  }

  Future<void> _exportRawDatabaseData(BuildContext context) async {
    final viewName = context.read<ShareBloc>().state.viewName;
    final exportPath = await getIt<FilePickerService>().saveFile(
      dialogTitle: '',
      fileName: '${viewName.toFileName()}.json',
    );
    if (context.mounted && exportPath != null) {
      context.read<ShareBloc>().add(
            ShareEvent.share(
              ShareType.rawDatabaseData,
              exportPath,
            ),
          );
    }
  }

  Future<void> _exportToClipboard(BuildContext context) async {
    final documentExporter = DocumentExporter(context.read<ShareBloc>().view);
    final result = await documentExporter.export(DocumentExportType.markdown);
    result.fold(
      (markdown) {
        getIt<ClipboardService>().setData(
          ClipboardServiceData(plainText: markdown),
        );
        showToastNotification(
          message: LocaleKeys.message_copy_success.tr(),
        );
      },
      (error) => showToastNotification(message: error.msg),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    required this.title,
    required this.svg,
    required this.onTap,
  });

  final String title;
  final UniflowSvgData svg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).isLightMode
        ? const Color(0x1E14171B)
        : Colors.white.withValues(alpha: 0.1);
    final radius = BorderRadius.circular(10.0);
    return UniflowButton(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      iconPadding: 12,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
        ),
        borderRadius: radius,
      ),
      radius: radius,
      text: UniflowText(
        title,
        lineHeight: 1.0,
      ),
      leftIcon: UniflowSvg(svg),
      onTap: onTap,
    );
  }
}
