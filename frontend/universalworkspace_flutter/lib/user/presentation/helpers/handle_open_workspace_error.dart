import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/user/application/auth/auth_service.dart';
import 'package:universalworkspace/user/presentation/router.dart';
import 'package:universalworkspace/workspace/presentation/widgets/dialogs.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/protobuf.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-folder/workspace.pb.dart';
import 'package:flutter/material.dart';

void handleOpenWorkspaceError(BuildContext context, UniflowError error) {
  Log.error(error);
  switch (error.code) {
    case ErrorCode.WorkspaceDataNotSync:
      final userFolder = UserFolderPB.fromBuffer(error.payload);
      getIt<AuthRouter>().pushWorkspaceErrorScreen(context, userFolder, error);
      break;
    case ErrorCode.InvalidEncryptSecret:
    case ErrorCode.NetworkError:
      showToastNotification(
        message: error.msg,
        type: ToastificationType.error,
      );
      break;
    default:
      showToastNotification(
        message: error.msg,
        type: ToastificationType.error,
        callbacks: ToastificationCallbacks(
          onDismissed: (_) {
            getIt<AuthService>().signOut();
            runUniversalWorkspace();
          },
        ),
      );
  }
}
