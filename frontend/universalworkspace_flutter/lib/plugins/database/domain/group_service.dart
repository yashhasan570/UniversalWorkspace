import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class GroupBackendService {
  GroupBackendService(this.viewId);

  final String viewId;

  Future<UniflowResult<void, UniflowError>> groupByField({
    required String fieldId,
    required List<int> settingContent,
  }) {
    final payload = GroupByFieldPayloadPB.create()
      ..viewId = viewId
      ..fieldId = fieldId
      ..settingContent = settingContent;

    return DatabaseEventSetGroupByField(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> updateGroup({
    required String groupId,
    String? name,
    bool? visible,
  }) {
    final payload = UpdateGroupPB.create()
      ..viewId = viewId
      ..groupId = groupId;

    if (name != null) {
      payload.name = name;
    }
    if (visible != null) {
      payload.visible = visible;
    }
    return DatabaseEventUpdateGroup(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> createGroup({
    required String name,
    String groupConfigId = "",
  }) {
    final payload = CreateGroupPayloadPB.create()
      ..viewId = viewId
      ..name = name;

    return DatabaseEventCreateGroup(payload).send();
  }

  Future<UniflowResult<void, UniflowError>> deleteGroup({
    required String groupId,
  }) {
    final payload = DeleteGroupPayloadPB.create()
      ..viewId = viewId
      ..groupId = groupId;

    return DatabaseEventDeleteGroup(payload).send();
  }
}
