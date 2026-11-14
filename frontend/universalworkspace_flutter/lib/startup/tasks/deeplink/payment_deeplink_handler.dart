import 'package:universalworkspace/startup/startup.dart';
import 'package:universalworkspace/startup/tasks/deeplink/deeplink_handler.dart';
import 'package:universalworkspace/workspace/application/subscription_success_listenable/subscription_success_listenable.dart';
import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';

class PaymentDeepLinkHandler extends DeepLinkHandler {
  @override
  bool canHandle(Uri uri) {
    return uri.host == 'payment-success';
  }

  @override
  Future<UniflowResult<dynamic, UniflowError>> handle({
    required Uri uri,
    required DeepLinkStateHandler onStateChange,
  }) async {
    Log.debug("Payment success deep link: ${uri.toString()}");
    final plan = uri.queryParameters['plan'];
    getIt<SubscriptionSuccessListenable>().onPaymentSuccess(plan);
    return UniflowResult.success(null);
  }
}
