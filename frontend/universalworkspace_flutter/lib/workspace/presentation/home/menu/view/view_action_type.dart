import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ViewMoreActionType {
  delete,
  favorite,
  unFavorite,
  duplicate,
  copyLink, // not supported yet.
  rename,
  moveTo,
  openInNewTab,
  changeIcon,
  collapseAllPages, // including sub pages
  divider,
  lastModified,
  created,
  lockPage,
  leaveSharedPage;

  static const disableInLockedView = [
    delete,
    rename,
    moveTo,
    changeIcon,
  ];
}

extension ViewMoreActionTypeExtension on ViewMoreActionType {
  String get name {
    switch (this) {
      case ViewMoreActionType.delete:
        return LocaleKeys.disclosureAction_delete.tr();
      case ViewMoreActionType.favorite:
        return LocaleKeys.disclosureAction_favorite.tr();
      case ViewMoreActionType.unFavorite:
        return LocaleKeys.disclosureAction_unfavorite.tr();
      case ViewMoreActionType.duplicate:
        return LocaleKeys.disclosureAction_duplicate.tr();
      case ViewMoreActionType.copyLink:
        return LocaleKeys.disclosureAction_copyLink.tr();
      case ViewMoreActionType.rename:
        return LocaleKeys.disclosureAction_rename.tr();
      case ViewMoreActionType.moveTo:
        return LocaleKeys.disclosureAction_moveTo.tr();
      case ViewMoreActionType.openInNewTab:
        return LocaleKeys.disclosureAction_openNewTab.tr();
      case ViewMoreActionType.changeIcon:
        return LocaleKeys.disclosureAction_changeIcon.tr();
      case ViewMoreActionType.collapseAllPages:
        return LocaleKeys.disclosureAction_collapseAllPages.tr();
      case ViewMoreActionType.lockPage:
        return LocaleKeys.disclosureAction_lockPage.tr();
      case ViewMoreActionType.leaveSharedPage:
        return 'Leave';
      case ViewMoreActionType.divider:
      case ViewMoreActionType.lastModified:
      case ViewMoreActionType.created:
        return '';
    }
  }

  UniflowSvgData get leftIconSvg {
    switch (this) {
      case ViewMoreActionType.delete:
        return UniflowSvgs.trash_s;
      case ViewMoreActionType.favorite:
        return UniflowSvgs.favorite_s;
      case ViewMoreActionType.unFavorite:
        return UniflowSvgs.unfavorite_s;
      case ViewMoreActionType.duplicate:
        return UniflowSvgs.duplicate_s;
      case ViewMoreActionType.rename:
        return UniflowSvgs.view_item_rename_s;
      case ViewMoreActionType.moveTo:
        return UniflowSvgs.move_to_s;
      case ViewMoreActionType.openInNewTab:
        return UniflowSvgs.view_item_open_in_new_tab_s;
      case ViewMoreActionType.changeIcon:
        return UniflowSvgs.change_icon_s;
      case ViewMoreActionType.collapseAllPages:
        return UniflowSvgs.collapse_all_page_s;
      case ViewMoreActionType.lockPage:
        return UniflowSvgs.lock_page_s;
      case ViewMoreActionType.leaveSharedPage:
        return UniflowSvgs.leave_workspace_s;
      case ViewMoreActionType.divider:
      case ViewMoreActionType.lastModified:
      case ViewMoreActionType.copyLink:
      case ViewMoreActionType.created:
        throw UnsupportedError('No left icon for $this');
    }
  }

  Widget get rightIcon {
    switch (this) {
      case ViewMoreActionType.changeIcon:
      case ViewMoreActionType.moveTo:
      case ViewMoreActionType.favorite:
      case ViewMoreActionType.unFavorite:
      case ViewMoreActionType.duplicate:
      case ViewMoreActionType.copyLink:
      case ViewMoreActionType.rename:
      case ViewMoreActionType.openInNewTab:
      case ViewMoreActionType.collapseAllPages:
      case ViewMoreActionType.divider:
      case ViewMoreActionType.delete:
      case ViewMoreActionType.lastModified:
      case ViewMoreActionType.created:
      case ViewMoreActionType.lockPage:
      case ViewMoreActionType.leaveSharedPage:
        return const SizedBox.shrink();
    }
  }
}
