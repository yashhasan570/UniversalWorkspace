import 'package:universalworkspace/plugins/ai_chat/chat.dart';
import 'package:universalworkspace/plugins/database/calendar/calendar.dart';
import 'package:universalworkspace/plugins/database/board/board.dart';
import 'package:universalworkspace/plugins/database/grid/grid.dart';
import 'package:universalworkspace/plugins/database_document/database_document_plugin.dart';
import 'package:universalworkspace/startup/plugin/plugin.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/plugins/blank/blank.dart';
import 'package:universalworkspace/plugins/document/document.dart';
import 'package:universalworkspace/plugins/trash/trash.dart';

class PluginLoadTask extends LaunchTask {
  const PluginLoadTask();

  @override
  LaunchTaskType get type => LaunchTaskType.dataProcessing;

  @override
  Future<void> initialize(LaunchContext context) async {
    await super.initialize(context);

    registerPlugin(builder: BlankPluginBuilder(), config: BlankPluginConfig());
    registerPlugin(builder: TrashPluginBuilder(), config: TrashPluginConfig());
    registerPlugin(builder: DocumentPluginBuilder());
    registerPlugin(builder: GridPluginBuilder(), config: GridPluginConfig());
    registerPlugin(builder: BoardPluginBuilder(), config: BoardPluginConfig());
    registerPlugin(
      builder: CalendarPluginBuilder(),
      config: CalendarPluginConfig(),
    );
    registerPlugin(
      builder: DatabaseDocumentPluginBuilder(),
      config: DatabaseDocumentPluginConfig(),
    );
    registerPlugin(
      builder: DatabaseDocumentPluginBuilder(),
      config: DatabaseDocumentPluginConfig(),
    );
    registerPlugin(
      builder: AIChatPluginBuilder(),
      config: AIChatPluginConfig(),
    );
  }
}
