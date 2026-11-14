import 'dart:convert';

import 'package:universalworkspace/workspace/application/view/view_ext.dart';
import 'package:universalworkspace/workspace/application/view/view_service.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:collection/collection.dart';

class FavoriteService {
  Future<UniflowResult<RepeatedFavoriteViewPB, UniflowError>> readFavorites() {
    final result = FolderEventReadFavorites().send();
    return result.then((result) {
      return result.fold(
        (favoriteViews) {
          return UniflowResult.success(
            RepeatedFavoriteViewPB(
              items: favoriteViews.items.where((e) => !e.item.isSpace),
            ),
          );
        },
        (error) => UniflowResult.failure(error),
      );
    });
  }

  Future<UniflowResult<void, UniflowError>> toggleFavorite(String viewId) async {
    final id = RepeatedViewIdPB.create()..items.add(viewId);
    return FolderEventToggleFavorite(id).send();
  }

  Future<UniflowResult<void, UniflowError>> pinFavorite(ViewPB view) async {
    return pinOrUnpinFavorite(view, true);
  }

  Future<UniflowResult<void, UniflowError>> unpinFavorite(ViewPB view) async {
    return pinOrUnpinFavorite(view, false);
  }

  Future<UniflowResult<void, UniflowError>> pinOrUnpinFavorite(
    ViewPB view,
    bool isPinned,
  ) async {
    try {
      final current =
          view.extra.isNotEmpty ? jsonDecode(view.extra) : <String, dynamic>{};
      final merged = mergeMaps(
        current,
        <String, dynamic>{ViewExtKeys.isPinnedKey: isPinned},
      );
      await ViewBackendService.updateView(
        viewId: view.id,
        extra: jsonEncode(merged),
      );
    } catch (e) {
      return UniflowResult.failure(UniflowError(msg: 'Failed to pin favorite: $e'));
    }

    return UniflowResult.success(null);
  }
}
