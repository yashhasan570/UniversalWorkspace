import 'package:universalworkspace/features/share_tab/data/models/share_access_level.dart';
import 'package:universalworkspace/features/shared_section/data/repositories/shared_pages_repository.dart';
import 'package:universalworkspace/features/shared_section/logic/shared_section_bloc.dart';
import 'package:universalworkspace/features/shared_section/models/shared_page.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharePagesRepository extends Mock implements SharedPagesRepository {}

void main() {
  late MockSharePagesRepository repository;
  late SharedSectionBloc bloc;
  const workspaceId = 'workspace-id';
  final initialPages = <SharedPage>[];
  final updatedPages = <SharedPage>[
    SharedPage(
      view: ViewPB(
        id: '1',
        name: 'Page 1',
      ),
      accessLevel: ShareAccessLevel.readOnly,
    ),
  ];

  setUp(() {
    repository = MockSharePagesRepository();
    when(() => repository.getSharedPages())
        .thenAnswer((_) async => UniflowResult.success(initialPages));
    bloc = SharedSectionBloc(
      workspaceId: workspaceId,
      repository: repository,
    )..add(const SharedSectionEvent.init());
  });

  tearDown(() async {
    await bloc.close();
  });

  blocTest<SharedSectionBloc, SharedSectionState>(
    'emits updated sharedPages on updateSharedPages',
    build: () => bloc,
    act: (bloc) => bloc.add(
      SharedSectionEvent.updateSharedPages(
        sharedPages: updatedPages,
      ),
    ),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      SharedSectionState.initial().copyWith(
        sharedPages: updatedPages,
      ),
    ],
  );
}
