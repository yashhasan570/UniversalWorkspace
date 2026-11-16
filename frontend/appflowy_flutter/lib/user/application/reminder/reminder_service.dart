import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/reminder.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

/// Interface for a Reminder Service that handles
/// communication to the backend
///
abstract class IReminderService {
  Future<UniflowResult<List<ReminderPB>, UniflowError>> fetchReminders();

  Future<UniflowResult<void, UniflowError>> removeReminder({
    required String reminderId,
  });

  Future<UniflowResult<void, UniflowError>> addReminder({
    required ReminderPB reminder,
  });

  Future<UniflowResult<void, UniflowError>> updateReminder({
    required ReminderPB reminder,
  });
}

class ReminderService implements IReminderService {
  const ReminderService();

  @override
  Future<UniflowResult<void, UniflowError>> addReminder({
    required ReminderPB reminder,
  }) async {
    final unitOrFailure = await UserEventCreateReminder(reminder).send();

    return unitOrFailure;
  }

  @override
  Future<UniflowResult<void, UniflowError>> updateReminder({
    required ReminderPB reminder,
  }) async {
    final unitOrFailure = await UserEventUpdateReminder(reminder).send();

    return unitOrFailure;
  }

  @override
  Future<UniflowResult<List<ReminderPB>, UniflowError>> fetchReminders() async {
    final resultOrFailure = await UserEventGetAllReminders().send();

    return resultOrFailure.fold(
      (s) => UniflowResult.success(s.items),
      (e) => UniflowResult.failure(e),
    );
  }

  @override
  Future<UniflowResult<void, UniflowError>> removeReminder({
    required String reminderId,
  }) async {
    final request = ReminderIdentifierPB(id: reminderId);
    final unitOrFailure = await UserEventRemoveReminder(request).send();

    return unitOrFailure;
  }
}
