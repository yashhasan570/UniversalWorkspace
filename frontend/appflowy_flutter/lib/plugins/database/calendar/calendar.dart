import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/database/tab_bar/tab_bar_view.dart';
import 'package:universalworkspace/startup/plugin/plugin.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';

class CalendarPluginBuilder extends PluginBuilder {
  @override
  Plugin build(dynamic data) {
    if (data is ViewPB) {
      return DatabaseTabBarViewPlugin(pluginType: pluginType, view: data);
    } else {
      throw UniflowPluginException.invalidData;
    }
  }

  @override
  String get menuName => LocaleKeys.calendar_menuName.tr();

  @override
  UniflowSvgData get icon => UniflowSvgs.icon_calendar_s;

  @override
  PluginType get pluginType => PluginType.calendar;

  @override
  ViewLayoutPB get layoutType => ViewLayoutPB.Calendar;
}

class CalendarPluginConfig implements PluginConfig {
  @override
  bool get creatable => true;
}
