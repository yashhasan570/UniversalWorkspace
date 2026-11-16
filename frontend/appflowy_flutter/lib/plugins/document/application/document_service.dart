import 'package:universalworkspace/plugins/document/application/document_data_pb_extension.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-document/entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart';

class DocumentService {
  // unused now.
  Future<UniflowResult<void, UniflowError>> createDocument({
    required ViewPB view,
  }) async {
    final canOpen = await openDocument(documentId: view.id);
    if (canOpen.isSuccess) {
      return UniflowResult.success(null);
    }
    final payload = CreateDocumentPayloadPB()..documentId = view.id;
    final result = await DocumentEventCreateDocument(payload).send();
    return result;
  }

  Future<UniflowResult<DocumentDataPB, UniflowError>> openDocument({
    required String documentId,
  }) async {
    final payload = OpenDocumentPayloadPB()..documentId = documentId;
    final result = await DocumentEventOpenDocument(payload).send();
    return result;
  }

  Future<UniflowResult<DocumentDataPB, UniflowError>> getDocument({
    required String documentId,
  }) async {
    final payload = OpenDocumentPayloadPB()..documentId = documentId;
    final result = await DocumentEventGetDocumentData(payload).send();
    return result;
  }

  Future<UniflowResult<(DocumentDataPB, BlockPB, Node), UniflowError>>
      getDocumentNode({
    required String documentId,
    required String blockId,
  }) async {
    final documentResult = await getDocument(documentId: documentId);
    final document = documentResult.fold((l) => l, (f) => null);
    if (document == null) {
      Log.error('unable to get the document for page $documentId');
      return UniflowResult.failure(UniflowError(msg: 'Document not found'));
    }

    final blockResult = await getBlockFromDocument(
      document: document,
      blockId: blockId,
    );
    final block = blockResult.fold((l) => l, (f) => null);
    if (block == null) {
      Log.error(
        'unable to get the block $blockId from the document $documentId',
      );
      return UniflowResult.failure(UniflowError(msg: 'Block not found'));
    }

    final node = document.buildNode(blockId);
    if (node == null) {
      Log.error(
        'unable to get the node for block $blockId in document $documentId',
      );
      return UniflowResult.failure(UniflowError(msg: 'Node not found'));
    }

    return UniflowResult.success((document, block, node));
  }

  Future<UniflowResult<BlockPB, UniflowError>> getBlockFromDocument({
    required DocumentDataPB document,
    required String blockId,
  }) async {
    final block = document.blocks[blockId];

    if (block != null) {
      return UniflowResult.success(block);
    }

    return UniflowResult.failure(
      UniflowError(
        msg: 'Block($blockId) not found in Document(${document.pageId})',
      ),
    );
  }

  Future<UniflowResult<void, UniflowError>> closeDocument({
    required String viewId,
  }) async {
    final payload = ViewIdPB()..value = viewId;
    final result = await FolderEventCloseView(payload).send();
    return result;
  }

  Future<UniflowResult<void, UniflowError>> applyAction({
    required String documentId,
    required Iterable<BlockActionPB> actions,
  }) async {
    final payload = ApplyActionPayloadPB(
      documentId: documentId,
      actions: actions,
    );
    final result = await DocumentEventApplyAction(payload).send();
    return result;
  }

  /// Creates a new external text.
  ///
  /// Normally, it's used to the block that needs sync long text.
  ///
  /// the delta parameter is the json representation of the delta.
  Future<UniflowResult<void, UniflowError>> createExternalText({
    required String documentId,
    required String textId,
    String? delta,
  }) async {
    final payload = TextDeltaPayloadPB(
      documentId: documentId,
      textId: textId,
      delta: delta,
    );
    final result = await DocumentEventCreateText(payload).send();
    return result;
  }

  /// Updates the external text.
  ///
  /// this function is compatible with the [createExternalText] function.
  ///
  /// the delta parameter is the json representation of the delta too.
  Future<UniflowResult<void, UniflowError>> updateExternalText({
    required String documentId,
    required String textId,
    String? delta,
  }) async {
    final payload = TextDeltaPayloadPB(
      documentId: documentId,
      textId: textId,
      delta: delta,
    );
    final result = await DocumentEventApplyTextDeltaEvent(payload).send();
    return result;
  }

  /// Upload a file to the cloud storage.
  Future<UniflowResult<UploadedFilePB, UniflowError>> uploadFile({
    required String localFilePath,
    required String documentId,
  }) async {
    final workspace = await FolderEventReadCurrentWorkspace().send();
    return workspace.fold(
      (l) async {
        final payload = UploadFileParamsPB(
          workspaceId: l.id,
          localFilePath: localFilePath,
          documentId: documentId,
        );
        return DocumentEventUploadFile(payload).send();
      },
      (r) async {
        return UniflowResult.failure(UniflowError(msg: 'Workspace not found'));
      },
    );
  }

  /// Download a file from the cloud storage.
  Future<UniflowResult<void, UniflowError>> downloadFile({
    required String url,
  }) async {
    final workspace = await FolderEventReadCurrentWorkspace().send();
    return workspace.fold((l) async {
      final payload = DownloadFilePB(
        url: url,
      );
      final result = await DocumentEventDownloadFile(payload).send();
      return result;
    }, (r) async {
      return UniflowResult.failure(UniflowError(msg: 'Workspace not found'));
    });
  }

  /// Sync the awareness states
  /// For example, the cursor position, selection, who is viewing the document.
  Future<UniflowResult<void, UniflowError>> syncAwarenessStates({
    required String documentId,
    Selection? selection,
    String? metadata,
  }) async {
    final payload = UpdateDocumentAwarenessStatePB(
      documentId: documentId,
      selection: convertSelectionToAwarenessSelection(selection),
      metadata: metadata,
    );

    final result = await DocumentEventSetAwarenessState(payload).send();
    return result;
  }

  DocumentAwarenessSelectionPB? convertSelectionToAwarenessSelection(
    Selection? selection,
  ) {
    if (selection == null) {
      return null;
    }
    return DocumentAwarenessSelectionPB(
      start: DocumentAwarenessPositionPB(
        offset: Int64(selection.startIndex),
        path: selection.start.path.map((e) => Int64(e)),
      ),
      end: DocumentAwarenessPositionPB(
        offset: Int64(selection.endIndex),
        path: selection.end.path.map((e) => Int64(e)),
      ),
    );
  }
}
