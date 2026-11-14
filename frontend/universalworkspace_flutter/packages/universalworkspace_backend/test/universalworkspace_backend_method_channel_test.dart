import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universalworkspace_backend/universalworkspace_backend_method_channel.dart';

void main() {
  MethodChannelUniflowSdk platform = MethodChannelUniflowSdk();
  const MethodChannel channel = MethodChannel('universalworkspace_backend');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
