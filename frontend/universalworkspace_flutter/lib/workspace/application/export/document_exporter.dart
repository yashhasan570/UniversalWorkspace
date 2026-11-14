import 'dart:convert';

import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/application/document_data_pb_extension.dart';
import 'package:universalworkspace/plugins/document/application/prelude.dart';
import 'package:universalworkspace/shared/markdown_to_document.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';

enum DocumentExportType {
  json,
  markdown,
  text,
  html,
}

class DocumentExporter {
  const DocumentExporter(
    this.view,
  );

  final ViewPB view;

  Future<UniflowResult<String, UniflowError>> export(
    DocumentExportType type, {
    String? path,
  }) async {
    final documentService = DocumentService();
    final result = await documentService.openDocument(documentId: view.id);
    return result.fold(
      (r) async {
        final document = r.toDocument();
        if (document == null) {
          return UniflowResult.failure(
            UniflowError(
              msg: LocaleKeys.settings_files_exportFileFail.tr(),
            ),
          );
        }
        switch (type) {
          case DocumentExportType.json:
            return UniflowResult.success(jsonEncode(document));
          case DocumentExportType.markdown:
            if (path != null) {
              await customDocumentToMarkdown(document, path: path);
              return UniflowResult.success('');
            } else {
              return UniflowResult.success(
                await customDocumentToMarkdown(document),
              );
            }
          case DocumentExportType.text:
            throw UnimplementedError();
          case DocumentExportType.html:
            final html = documentToHTML(
              document,
            );
            return UniflowResult.success(html);
        }
      },
      (error) => UniflowResult.failure(error),
    );
  }
}
