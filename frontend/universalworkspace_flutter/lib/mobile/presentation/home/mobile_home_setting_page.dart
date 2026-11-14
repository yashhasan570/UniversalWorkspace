import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/env/env.dart';
import 'package:universalworkspace/features/workspace/data/repositories/rust_workspace_repository_impl.dart';
import 'package:universalworkspace/features/workspace/logic/workspace_bloc.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/base/app_bar/app_bar.dart';
import 'package:universalworkspace/mobile/presentation/presentation.dart';
import 'package:universalworkspace/mobile/presentation/setting/ai/ai_settings_group.dart';
import 'package:universalworkspace/mobile/presentation/setting/cloud/cloud_setting_group.dart';
import 'package:universalworkspace/mobile/presentation/setting/user_session_setting_group.dart';
import 'package:universalworkspace/mobile/presentation/setting/workspace/workspace_setting_group.dart';
import 'package:universalworkspace/mobile/presentation/widgets/uniflow_mobile_state_container.dart';
import 'package:universalworkspace/mobile/presentation/widgets/widgets.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/workspace/application/user/user_workspace_bloc.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileHomeSettingPage extends StatefulWidget {
  const MobileHomeSettingPage({
    super.key,
  });

  static const routeName = '/settings';

  @override
  State<MobileHomeSettingPage> createState() => _MobileHomeSettingPageState();
}

class _MobileHomeSettingPageState extends State<MobileHomeSettingPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt<AuthService>().getUser(),
      builder: (context, snapshot) {
        String? errorMsg;
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final userProfile = snapshot.data?.fold(
          (userProfile) {
            return userProfile;
          },
          (error) {
            errorMsg = error.msg;
            return null;
          },
        );

        return Scaffold(
          appBar: UniflowAppBar(
            titleText: LocaleKeys.settings_title.tr(),
          ),
          body: userProfile == null
              ? _buildErrorWidget(errorMsg)
              : _buildSettingsWidget(userProfile),
        );
      },
    );
  }

  Widget _buildErrorWidget(String? errorMsg) {
    return UniflowMobileStateContainer.error(
      emoji: '🛸',
      title: LocaleKeys.settings_mobile_userprofileError.tr(),
      description: LocaleKeys.settings_mobile_userprofileErrorDescription.tr(),
      errorMsg: errorMsg,
    );
  }

  Widget _buildSettingsWidget(UserProfilePB userProfile) {
    return BlocProvider(
      create: (context) => UserWorkspaceBloc(
        userProfile: userProfile,
        repository: RustWorkspaceRepositoryImpl(
          userId: userProfile.id,
        ),
      )..add(UserWorkspaceEvent.initialize()),
      child: BlocBuilder<UserWorkspaceBloc, UserWorkspaceState>(
        builder: (context, state) {
          final currentWorkspaceId = state.currentWorkspace?.workspaceId ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PersonalInfoSettingGroup(
                    userProfile: userProfile,
                  ),
                  if (state.userProfile.userAuthType == AuthTypePB.Server)
                    const WorkspaceSettingGroup(),
                  const AppearanceSettingGroup(),
                  const LanguageSettingGroup(),
                  if (Env.enableCustomCloud) const CloudSettingGroup(),
                  if (isAuthEnabled)
                    AiSettingsGroup(
                      key: ValueKey(currentWorkspaceId),
                      userProfile: userProfile,
                      workspaceId: currentWorkspaceId,
                    ),
                  const SupportSettingGroup(),
                  const AboutSettingGroup(),
                  UserSessionSettingGroup(
                    userProfile: userProfile,
                    showThirdPartyLogin: false,
                  ),
                  const VSpace(20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
