import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:universalworkspace/env/cloud_env.dart';
import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/startup/tasks/app_widget.dart';
import 'package:universalworkspace/startup/tasks/deeplink/deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/expire_login_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/invitation_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/login_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/open_app_deeplink_handler.dart';
import 'package:universalworkspace/startup/tasks/deeplink/payment_deeplink_handler.dart';
import 'package:universalworkspace/user/application/auth/auth_error.dart';
import 'package:universalworkspace/user/application/user_auth_listener.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/protobuf.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:flutter/material.dart';
import 'package:url_protocol/url_protocol.dart';

const universalworkspaceDeepLinkSchema = 'universalworkspace-flutter';

class UniversalWorkspaceCloudDeepLink {
  UniversalWorkspaceCloudDeepLink() {
    _deepLinkHandlerRegistry = DeepLinkHandlerRegistry.instance
      ..register(LoginDeepLinkHandler())
      ..register(PaymentDeepLinkHandler())
      ..register(InvitationDeepLinkHandler())
      ..register(ExpireLoginDeepLinkHandler())
      ..register(OpenAppDeepLinkHandler());

    _deepLinkSubscription = _AppLinkWrapper.instance.listen(
      (Uri? uri) async {
        Log.info('onDeepLink: ${uri.toString()}');
        await _handleUri(uri);
      },
      onError: (Object err, StackTrace stackTrace) {
        Log.error('on DeepLink stream error: ${err.toString()}', stackTrace);
        _deepLinkSubscription.cancel();
      },
    );
    if (Platform.isWindows) {
      // register deep link for Windows
      registerProtocolHandler(universalworkspaceDeepLinkSchema);
    }
  }

  ValueNotifier<DeepLinkResult?>? _stateNotifier = ValueNotifier(null);

  Completer<UniflowResult<UserProfilePB, UniflowError>>? _completer;

  set completer(Completer<UniflowResult<UserProfilePB, UniflowError>>? value) {
    Log.debug('UniversalWorkspaceCloudDeepLink: $hashCode completer');
    _completer = value;
  }

  late final StreamSubscription<Uri?> _deepLinkSubscription;
  late final DeepLinkHandlerRegistry _deepLinkHandlerRegistry;

  Future<void> dispose() async {
    Log.debug('UniversalWorkspaceCloudDeepLink: $hashCode dispose');
    await _deepLinkSubscription.cancel();

    _stateNotifier?.dispose();
    _stateNotifier = null;
    completer = null;
  }

  void registerCompleter(
    Completer<UniflowResult<UserProfilePB, UniflowError>> completer,
  ) {
    this.completer = completer;
  }

  VoidCallback subscribeDeepLinkLoadingState(
    ValueChanged<DeepLinkResult> listener,
  ) {
    void listenerFn() {
      if (_stateNotifier?.value != null) {
        listener(_stateNotifier!.value!);
      }
    }

    _stateNotifier?.addListener(listenerFn);
    return listenerFn;
  }

  void unsubscribeDeepLinkLoadingState(VoidCallback listener) =>
      _stateNotifier?.removeListener(listener);

  Future<void> passGotrueTokenResponse(
    GotrueTokenResponsePB gotrueTokenResponse,
  ) async {
    final uri = _buildDeepLinkUri(gotrueTokenResponse);
    await _handleUri(uri);
  }

  Future<void> _handleUri(
    Uri? uri,
  ) async {
    _stateNotifier?.value = DeepLinkResult(state: DeepLinkState.none);

    if (uri == null) {
      Log.error('onDeepLinkError: Unexpected empty deep link callback');
      _completer?.complete(UniflowResult.failure(AuthError.emptyDeepLink));
      completer = null;
      return;
    }

    await _deepLinkHandlerRegistry.processDeepLink(
      uri: uri,
      onStateChange: (handler, state) {
        // only handle the login deep link
        if (handler is LoginDeepLinkHandler) {
          _stateNotifier?.value = DeepLinkResult(state: state);
        }
      },
      onResult: (handler, result) async {
        if (handler is LoginDeepLinkHandler &&
            result is UniflowResult<UserProfilePB, UniflowError>) {
          // If there is no completer, runUniversalWorkspace() will be called.
          if (_completer == null) {
            await result.fold(
              (_) async {
                await runUniversalWorkspace();
              },
              (err) {
                Log.error(err);
                final context = AppGlobals.rootNavKey.currentState?.context;
                if (context != null) {
                  showToastNotification(
                    message: err.msg,
                  );
                }
              },
            );
          } else {
            _completer?.complete(result);
            completer = null;
          }
        } else if (handler is ExpireLoginDeepLinkHandler) {
          result.onFailure(
            (error) {
              final context = AppGlobals.rootNavKey.currentState?.context;
              if (context != null) {
                showToastNotification(
                  message: error.msg,
                  type: ToastificationType.error,
                );
              }
            },
          );
        }
      },
      onError: (error) {
        Log.error('onDeepLinkError: Unexpected deep link: $error');
        if (_completer == null) {
          final context = AppGlobals.rootNavKey.currentState?.context;
          if (context != null) {
            showToastNotification(
              message: error.msg,
              type: ToastificationType.error,
            );
          }
        } else {
          _completer?.complete(UniflowResult.failure(error));
          completer = null;
        }
      },
    );
  }

  Uri? _buildDeepLinkUri(GotrueTokenResponsePB gotrueTokenResponse) {
    final params = <String, String>{};

    if (gotrueTokenResponse.hasAccessToken() &&
        gotrueTokenResponse.accessToken.isNotEmpty) {
      params['access_token'] = gotrueTokenResponse.accessToken;
    }

    if (gotrueTokenResponse.hasExpiresAt()) {
      params['expires_at'] = gotrueTokenResponse.expiresAt.toString();
    }

    if (gotrueTokenResponse.hasExpiresIn()) {
      params['expires_in'] = gotrueTokenResponse.expiresIn.toString();
    }

    if (gotrueTokenResponse.hasProviderRefreshToken() &&
        gotrueTokenResponse.providerRefreshToken.isNotEmpty) {
      params['provider_refresh_token'] =
          gotrueTokenResponse.providerRefreshToken;
    }

    if (gotrueTokenResponse.hasProviderAccessToken() &&
        gotrueTokenResponse.providerAccessToken.isNotEmpty) {
      params['provider_token'] = gotrueTokenResponse.providerAccessToken;
    }

    if (gotrueTokenResponse.hasRefreshToken() &&
        gotrueTokenResponse.refreshToken.isNotEmpty) {
      params['refresh_token'] = gotrueTokenResponse.refreshToken;
    }

    if (gotrueTokenResponse.hasTokenType() &&
        gotrueTokenResponse.tokenType.isNotEmpty) {
      params['token_type'] = gotrueTokenResponse.tokenType;
    }

    if (params.isEmpty) {
      return null;
    }

    final fragment = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return Uri.parse('universalworkspace-flutter://login-callback#$fragment');
  }
}

class InitUniversalWorkspaceCloudTask extends LaunchTask {
  UserAuthStateListener? _authStateListener;
  bool isLoggingOut = false;

  @override
  Future<void> initialize(LaunchContext context) async {
    await super.initialize(context);

    if (!isUniversalWorkspaceCloudEnabled) {
      return;
    }
    _authStateListener = UserAuthStateListener();

    _authStateListener?.start(
      didSignIn: () {
        isLoggingOut = false;
      },
      onInvalidAuth: (message) async {
        Log.error(message);
        if (!isLoggingOut) {
          await runUniversalWorkspace();
        }
      },
    );
  }

  @override
  Future<void> dispose() async {
    await super.dispose();

    await _authStateListener?.stop();
    _authStateListener = null;
  }
}

// wrapper for AppLinks to support multiple listeners
class _AppLinkWrapper {
  _AppLinkWrapper._() {
    _appLinkSubscription = _appLinks.uriLinkStream.listen((event) {
      _streamSubscription.sink.add(event);
    });
  }

  static final _AppLinkWrapper instance = _AppLinkWrapper._();

  final AppLinks _appLinks = AppLinks();
  final _streamSubscription = StreamController<Uri?>.broadcast();
  late final StreamSubscription<Uri?> _appLinkSubscription;

  StreamSubscription<Uri?> listen(
    void Function(Uri?) listener, {
    Function? onError,
    bool? cancelOnError,
  }) {
    return _streamSubscription.stream.listen(
      listener,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  void dispose() {
    _streamSubscription.close();
    _appLinkSubscription.cancel();
  }
}
