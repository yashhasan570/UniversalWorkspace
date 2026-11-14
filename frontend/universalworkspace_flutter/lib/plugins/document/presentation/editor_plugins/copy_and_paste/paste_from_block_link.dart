import 'package:universalworkspace/plugins/document/presentation/editor_plugins/mention/mention_block.dart';
import 'package:universalworkspace/shared/patterns/common_patterns.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

extension PasteFromBlockLink on EditorState {
  Future<bool> pasteUniversalWorkspaceSharePageLink(String? sharePageLink) async {
    if (sharePageLink == null || sharePageLink.isEmpty) {
      return false;
    }

    // Check if the link matches the universalworkspace block link format
    final match = universalworkspaceSharePageLinkRegex.firstMatch(sharePageLink);

    if (match == null) {
      return false;
    }

    final workspaceId = match.group(1);
    final pageId = match.group(2);
    final blockId = match.group(3);

    if (workspaceId == null || pageId == null) {
      Log.error(
        'Failed to extract information from block link: $sharePageLink',
      );
      return false;
    }

    final selection = this.selection;
    if (selection == null) {
      return false;
    }

    final node = getNodesInSelection(selection).firstOrNull;
    if (node == null) {
      return false;
    }

    // todo: if the current link is not from current workspace.
    final transaction = this.transaction;
    transaction.insertText(
      node,
      selection.startIndex,
      MentionBlockKeys.mentionChar,
      attributes: MentionBlockKeys.buildMentionPageAttributes(
        mentionType: MentionType.page,
        pageId: pageId,
        blockId: blockId,
      ),
    );
    await apply(transaction);

    return true;
  }
}
