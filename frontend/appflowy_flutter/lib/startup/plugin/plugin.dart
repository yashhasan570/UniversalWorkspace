library;

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/startup/plugin/plugin.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/workspace/presentation/home/home_stack.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/view.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';
import 'package:flutter/widgets.dart';

export "./src/sandbox.dart";

enum PluginType {
  document,
  blank,
  trash,
  grid,
  board,
  calendar,
  databaseDocument,
  chat,
}

typedef PluginId = String;

abstract class Plugin {
  PluginId get id;

  PluginWidgetBuilder get widgetBuilder;

  PluginNotifier? get notifier => null;

  PluginType get pluginType;

  void init() {}

  void dispose() {
    notifier?.dispose();
  }
}

abstract class PluginNotifier<T> {
  /// Notify if the plugin get deleted
  ValueNotifier<T> get isDeleted;

  void dispose() {}
}

abstract class PluginBuilder {
  Plugin build(dynamic data);

  String get menuName;

  UniflowSvgData get icon;

  /// The type of this [Plugin]. Each [Plugin] should have a unique [PluginType]
  PluginType get pluginType;

  /// The layoutType is used in the backend to determine the layout of the view.
  /// Currently, UniversalWorkspace supports 4 layout types: Document, Grid, Board, Calendar.
  ViewLayoutPB? get layoutType;
}

abstract class PluginConfig {
  // Return false will disable the user to create it. For example, a trash plugin shouldn't be created by the user,
  bool get creatable => true;
}

abstract class PluginWidgetBuilder with NavigationItem {
  List<NavigationItem> get navigationItems;

  EdgeInsets get contentPadding =>
      const EdgeInsets.symmetric(horizontal: 40, vertical: 28);

  Widget buildWidget({
    required PluginContext context,
    required bool shrinkWrap,
    Map<String, dynamic>? data,
  });
}

class PluginContext {
  PluginContext({
    this.userProfile,
    this.onDeleted,
  });

  // calls when widget of the plugin get deleted
  final Function(ViewPB, int?)? onDeleted;
  final UserProfilePB? userProfile;
}

void registerPlugin({required PluginBuilder builder, PluginConfig? config}) {
  getIt<PluginSandbox>()
      .registerPlugin(builder.pluginType, builder, config: config);
}

/// Make the correct plugin from the [pluginType] and [data]. If the plugin
///  is not registered, it will return a blank plugin.
Plugin makePlugin({required PluginType pluginType, dynamic data}) {
  final plugin = getIt<PluginSandbox>().buildPlugin(pluginType, data);
  return plugin;
}

List<PluginBuilder> pluginBuilders() {
  final pluginBuilders = getIt<PluginSandbox>().builders;
  final pluginConfigs = getIt<PluginSandbox>().pluginConfigs;
  return pluginBuilders.where(
    (builder) {
      final config = pluginConfigs[builder.pluginType]?.creatable;
      return config ?? true;
    },
  ).toList();
}

enum UniflowPluginException {
  invalidData,
}
