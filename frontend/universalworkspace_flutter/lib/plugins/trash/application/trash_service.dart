import 'dart:async';

import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/trash.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class TrashService {
  Future<UniflowResult<RepeatedTrashPB, UniflowError>> readTrash() {
    return FolderEventListTrashItems().send();
  }

  static Future<UniflowResult<void, UniflowError>> putback(String trashId) {
    final id = TrashIdPB.create()..id = trashId;

    return FolderEventRestoreTrashItem(id).send();
  }

  Future<UniflowResult<void, UniflowError>> deleteViews(List<String> trash) {
    final items = trash.map((trash) {
      return TrashIdPB.create()..id = trash;
    });

    final ids = RepeatedTrashIdPB(items: items);
    return FolderEventPermanentlyDeleteTrashItem(ids).send();
  }

  Future<UniflowResult<void, UniflowError>> restoreAll() {
    return FolderEventRecoverAllTrashItems().send();
  }

  Future<UniflowResult<void, UniflowError>> deleteAll() {
    return FolderEventPermanentlyDeleteAllTrashItem().send();
  }
}
