import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/env/env.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/plugins/shared/share/constants.dart';
import 'package:universalworkspace/shared/error_page/error_page.dart';
import 'package:universalworkspace/workspace/application/settings/universalworkspace_cloud_setting_bloc.dart';
import 'package:universalworkspace/workspace/application/settings/universalworkspace_cloud_urls_bloc.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/_restart_app_button.dart';
import 'package:universalworkspace/workspace/presentation/settings/widgets/web_url_hint_widget.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace/workspace/presentation/widgets/toggle/toggle.dart';
import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra/size.dart';
import 'package:uniflow_infra/theme_extension.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UniversalWorkspaceCloudViewSetting extends StatelessWidget {
  const UniversalWorkspaceCloudViewSetting({
    super.key,
    this.serverURL = kUniversalWorkspaceCloudUrl,
    this.authenticatorType = AuthenticatorType.universalworkspaceCloud,
    required this.restartUniversalWorkspace,
  });

  final String serverURL;
  final AuthenticatorType authenticatorType;
  final VoidCallback restartUniversalWorkspace;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UniflowResult<CloudSettingPB, UniflowError>>(
      future: UserEventGetCloudConfig().send(),
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!.fold(
            (setting) => _renderContent(context, setting),
            (err) => UniflowErrorPage.message(err.toString(), howToFix: ""),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  BlocProvider<UniversalWorkspaceCloudSettingBloc> _renderContent(
    BuildContext context,
    CloudSettingPB setting,
  ) {
    return BlocProvider(
      create: (context) => UniversalWorkspaceCloudSettingBloc(setting)
        ..add(const UniversalWorkspaceCloudSettingEvent.initial()),
      child: BlocBuilder<UniversalWorkspaceCloudSettingBloc, UniversalWorkspaceCloudSettingState>(
        builder: (context, state) {
          return Column(
            children: [
              const VSpace(8),
              if (state.workspaceType == WorkspaceTypePB.ServerW)
                const UniversalWorkspaceCloudEnableSync(),
              const VSpace(6),
              // const UniversalWorkspaceCloudSyncLogEnabled(),
              const VSpace(12),
              RestartButton(
                onClick: () {
                  NavigatorAlertDialog(
                    title: LocaleKeys.settings_menu_restartAppTip.tr(),
                    confirm: () async {
                      await useBaseWebDomain(
                        ShareConstants.defaultBaseWebDomain,
                      );
                      await useUniversalWorkspaceBetaCloudWithURL(
                        serverURL,
                        authenticatorType,
                      );
                      restartUniversalWorkspace();
                    },
                  ).show(context);
                },
                showRestartHint: state.showRestartHint,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomUniversalWorkspaceCloudView extends StatelessWidget {
  const CustomUniversalWorkspaceCloudView({required this.restartUniversalWorkspace, super.key});

  final VoidCallback restartUniversalWorkspace;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UniflowResult<CloudSettingPB, UniflowError>>(
      future: UserEventGetCloudConfig().send(),
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!.fold(
            (setting) => _renderContent(setting),
            (err) => UniflowErrorPage.message(err.toString(), howToFix: ""),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  BlocProvider<UniversalWorkspaceCloudSettingBloc> _renderContent(
    CloudSettingPB setting,
  ) {
    final List<Widget> children = [];
    children.addAll([
      const UniversalWorkspaceCloudEnableSync(),
      // const UniversalWorkspaceCloudSyncLogEnabled(),
      const VSpace(40),
    ]);

    // If the enableCustomCloud flag is true, then the user can dynamically configure cloud settings. Otherwise, the user cannot dynamically configure cloud settings.
    if (Env.enableCustomCloud) {
      children.add(
        UniversalWorkspaceCloudURLs(restartUniversalWorkspace: () => restartUniversalWorkspace()),
      );
    } else {
      children.add(
        Row(
          children: [
            UniflowText(LocaleKeys.settings_menu_cloudServerType.tr()),
            const Spacer(),
            const UniflowText(Env.afCloudUrl),
          ],
        ),
      );
    }
    return BlocProvider(
      create: (context) => UniversalWorkspaceCloudSettingBloc(setting)
        ..add(const UniversalWorkspaceCloudSettingEvent.initial()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class UniversalWorkspaceCloudURLs extends StatelessWidget {
  const UniversalWorkspaceCloudURLs({super.key, required this.restartUniversalWorkspace});

  final VoidCallback restartUniversalWorkspace;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UniversalWorkspaceCloudURLsBloc()..add(const UniversalWorkspaceCloudURLsEvent.initial()),
      child: BlocListener<UniversalWorkspaceCloudURLsBloc, UniversalWorkspaceCloudURLsState>(
        listener: (context, state) async {
          if (state.restartApp) {
            restartUniversalWorkspace();
          }
        },
        child: BlocBuilder<UniversalWorkspaceCloudURLsBloc, UniversalWorkspaceCloudURLsState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const UniversalWorkspaceSelfHostTip(),
                const VSpace(12),
                CloudURLInput(
                  title: LocaleKeys.settings_menu_cloudURL.tr(),
                  url: state.config.base_url,
                  hint: LocaleKeys.settings_menu_cloudURLHint.tr(),
                  onChanged: (text) {
                    context.read<UniversalWorkspaceCloudURLsBloc>().add(
                          UniversalWorkspaceCloudURLsEvent.updateServerUrl(
                            text,
                          ),
                        );
                  },
                ),
                const VSpace(8),
                CloudURLInput(
                  title: LocaleKeys.settings_menu_webURL.tr(),
                  url: state.config.base_web_domain,
                  hint: LocaleKeys.settings_menu_webURLHint.tr(),
                  hintBuilder: (context) => const WebUrlHintWidget(),
                  onChanged: (text) {
                    context.read<UniversalWorkspaceCloudURLsBloc>().add(
                          UniversalWorkspaceCloudURLsEvent.updateBaseWebDomain(
                            text,
                          ),
                        );
                  },
                ),
                const VSpace(12),
                RestartButton(
                  onClick: () {
                    NavigatorAlertDialog(
                      title: LocaleKeys.settings_menu_restartAppTip.tr(),
                      confirm: () {
                        context.read<UniversalWorkspaceCloudURLsBloc>().add(
                              const UniversalWorkspaceCloudURLsEvent.confirmUpdate(),
                            );
                      },
                    ).show(context);
                  },
                  showRestartHint: state.showRestartHint,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UniversalWorkspaceSelfHostTip extends StatelessWidget {
  const UniversalWorkspaceSelfHostTip({super.key});

  final url =
      "https://docs.universalworkspace.io/docs/guides/universalworkspace/self-hosting-universalworkspace#build-universalworkspace-with-a-self-hosted-server";

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: LocaleKeys.settings_menu_selfHostStart.tr(),
              style: Theme.of(context).textTheme.bodySmall!,
            ),
            TextSpan(
              text: " ${LocaleKeys.settings_menu_selfHostContent.tr()} ",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: FontSizes.s14,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => afLaunchUrlString(url),
            ),
            TextSpan(
              text: LocaleKeys.settings_menu_selfHostEnd.tr(),
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class CloudURLInput extends StatefulWidget {
  const CloudURLInput({
    super.key,
    required this.title,
    required this.url,
    required this.hint,
    required this.onChanged,
    this.hintBuilder,
  });

  final String title;
  final String url;
  final String hint;
  final ValueChanged<String> onChanged;
  final WidgetBuilder? hintBuilder;

  @override
  CloudURLInputState createState() => CloudURLInputState();
}

class CloudURLInputState extends State<CloudURLInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.url);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHint(context),
        SizedBox(
          height: 28,
          child: TextField(
            controller: _controller,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AFThemeExtension.of(context).onBackground,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              hintText: widget.hint,
              errorText: context.read<UniversalWorkspaceCloudURLsBloc>().state.urlError,
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildHint(BuildContext context) {
    final children = <Widget>[
      UniflowText(
        widget.title,
        fontSize: 12,
      ),
    ];

    if (widget.hintBuilder != null) {
      children.add(widget.hintBuilder!(context));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class UniversalWorkspaceCloudEnableSync extends StatelessWidget {
  const UniversalWorkspaceCloudEnableSync({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniversalWorkspaceCloudSettingBloc, UniversalWorkspaceCloudSettingState>(
      builder: (context, state) {
        return Row(
          children: [
            UniflowText.medium(LocaleKeys.settings_menu_enableSync.tr()),
            const Spacer(),
            Toggle(
              value: state.setting.enableSync,
              onChanged: (value) => context
                  .read<UniversalWorkspaceCloudSettingBloc>()
                  .add(UniversalWorkspaceCloudSettingEvent.enableSync(value)),
            ),
          ],
        );
      },
    );
  }
}

class UniversalWorkspaceCloudSyncLogEnabled extends StatelessWidget {
  const UniversalWorkspaceCloudSyncLogEnabled({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniversalWorkspaceCloudSettingBloc, UniversalWorkspaceCloudSettingState>(
      builder: (context, state) {
        return Row(
          children: [
            UniflowText.medium(LocaleKeys.settings_menu_enableSyncLog.tr()),
            const Spacer(),
            Toggle(
              value: state.isSyncLogEnabled,
              onChanged: (value) {
                if (value) {
                  showCancelAndConfirmDialog(
                    context: context,
                    title: LocaleKeys.settings_menu_enableSyncLog.tr(),
                    description:
                        LocaleKeys.settings_menu_enableSyncLogWarning.tr(),
                    confirmLabel: LocaleKeys.button_confirm.tr(),
                    onConfirm: (_) {
                      context
                          .read<UniversalWorkspaceCloudSettingBloc>()
                          .add(UniversalWorkspaceCloudSettingEvent.enableSyncLog(value));
                    },
                  );
                } else {
                  context
                      .read<UniversalWorkspaceCloudSettingBloc>()
                      .add(UniversalWorkspaceCloudSettingEvent.enableSyncLog(value));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class BillingGateGuard extends StatelessWidget {
  const BillingGateGuard({required this.builder, super.key});

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isBillingEnabled(),
      builder: (context, snapshot) {
        final isBillingEnabled = snapshot.data ?? false;
        if (isBillingEnabled &&
            snapshot.connectionState == ConnectionState.done) {
          return builder(context);
        }

        // If the billing is not enabled, show nothing
        return const SizedBox.shrink();
      },
    );
  }
}

Future<bool> isBillingEnabled() async {
  final result = await UserEventGetCloudConfig().send();
  return result.fold(
    (cloudSetting) {
      final whiteList = [
        "https://beta.universalworkspace.cloud",
        "https://test.universalworkspace.cloud",
      ];
      if (kDebugMode) {
        whiteList.add("http://localhost:8000");
      }

      final isWhiteListed = whiteList.contains(cloudSetting.serverUrl);
      if (!isWhiteListed) {
        Log.warn("Billing is not enabled for server ${cloudSetting.serverUrl}");
      }
      return isWhiteListed;
    },
    (err) {
      Log.error("Failed to get cloud config: $err");
      return false;
    },
  );
}
