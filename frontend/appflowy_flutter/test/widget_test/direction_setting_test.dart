import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/document/application/document_appearance_cubit.dart';
import 'package:universalworkspace/user/application/user_settings_service.dart';
import 'package:universalworkspace/workspace/application/settings/appearance/appearance_cubit.dart';
import 'package:universalworkspace/workspace/presentation/settings/pages/settings_workspace_view.dart';
import 'package:universalworkspace/workspace/presentation/settings/shared/settings_radio_select.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_setting.pb.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../util.dart';

class MockAppearanceSettingsBloc
    extends MockBloc<AppearanceSettingsCubit, AppearanceSettingsState>
    implements AppearanceSettingsCubit {}

class MockDocumentAppearanceCubit extends Mock
    implements DocumentAppearanceCubit {}

class MockDocumentAppearance extends Mock implements DocumentAppearance {}

void main() {
  late AppearanceSettingsPB appearanceSettings;
  late DateTimeSettingsPB dateTimeSettings;

  setUp(() async {
    await UniversalWorkspaceUnitTest.ensureInitialized();
    appearanceSettings =
        await UserSettingsBackendService().getAppearanceSetting();
    dateTimeSettings = await UserSettingsBackendService().getDateTimeSettings();
    registerFallbackValue(UniversalWorkspaceTextDirection.ltr);
  });

  testWidgets('TextDirectionSelect update default text direction setting',
      (WidgetTester tester) async {
    final appearanceSettingsState = AppearanceSettingsState.initial(
      AppTheme.fallback,
      appearanceSettings.themeMode,
      appearanceSettings.font,
      appearanceSettings.layoutDirection,
      appearanceSettings.textDirection,
      appearanceSettings.enableRtlToolbarItems,
      appearanceSettings.locale,
      appearanceSettings.isMenuCollapsed,
      appearanceSettings.menuOffset,
      dateTimeSettings.dateFormat,
      dateTimeSettings.timeFormat,
      dateTimeSettings.timezoneId,
      appearanceSettings.documentSetting.cursorColor.isEmpty
          ? null
          : Color(
              int.parse(appearanceSettings.documentSetting.cursorColor),
            ),
      appearanceSettings.documentSetting.selectionColor.isEmpty
          ? null
          : Color(
              int.parse(
                appearanceSettings.documentSetting.selectionColor,
              ),
            ),
      1.0,
    );
    final mockAppearanceSettingsBloc = MockAppearanceSettingsBloc();
    when(() => mockAppearanceSettingsBloc.state).thenReturn(
      appearanceSettingsState,
    );

    final mockDocumentAppearanceCubit = MockDocumentAppearanceCubit();
    when(() => mockDocumentAppearanceCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([MockDocumentAppearance()]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppearanceSettingsCubit>.value(
            value: mockAppearanceSettingsBloc,
          ),
          BlocProvider<DocumentAppearanceCubit>.value(
            value: mockDocumentAppearanceCubit,
          ),
        ],
        child: MaterialApp(
          theme: appearanceSettingsState.lightTheme,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AppearanceSettingsCubit>.value(
                value: mockAppearanceSettingsBloc,
              ),
              BlocProvider<DocumentAppearanceCubit>.value(
                value: mockDocumentAppearanceCubit,
              ),
            ],
            child: const Scaffold(
              body: TextDirectionSelect(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        LocaleKeys.settings_workspacePage_textDirection_leftToRight.tr(),
      ),
      findsOne,
    );
    expect(
      find.text(
        LocaleKeys.settings_workspacePage_textDirection_rightToLeft.tr(),
      ),
      findsOne,
    );
    expect(
      find.text(
        LocaleKeys.settings_workspacePage_textDirection_auto.tr(),
      ),
      findsOne,
    );

    final radioSelectFinder =
        find.byType(SettingsRadioSelect<UniversalWorkspaceTextDirection>);
    expect(radioSelectFinder, findsOne);

    when(
      () => mockAppearanceSettingsBloc.setTextDirection(
        any<UniversalWorkspaceTextDirection>(),
      ),
    ).thenAnswer((_) async => {});
    when(
      () => mockDocumentAppearanceCubit.syncDefaultTextDirection(
        any<String?>(),
      ),
    ).thenAnswer((_) async {});

    final radioSelect = tester.widget(radioSelectFinder)
        as SettingsRadioSelect<UniversalWorkspaceTextDirection>;
    final rtlSelect = radioSelect.items
        .firstWhere((select) => select.value == UniversalWorkspaceTextDirection.rtl);
    radioSelect.onChanged(rtlSelect);

    verify(
      () => mockAppearanceSettingsBloc.setTextDirection(
        any<UniversalWorkspaceTextDirection>(),
      ),
    ).called(1);
    verify(
      () => mockDocumentAppearanceCubit.syncDefaultTextDirection(
        any<String?>(),
      ),
    ).called(1);
  });
}
