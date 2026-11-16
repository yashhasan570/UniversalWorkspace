import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  // ignore: unused_local_variable
  late UniversalWorkspaceChatTest chatTest;

  setUpAll(() async {
    chatTest = await UniversalWorkspaceChatTest.ensureInitialized();
  });

  test('send message', () async {
    // final context = await chatTest.createChat();
  });
}
