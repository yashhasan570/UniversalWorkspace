import 'dart:convert';

import 'package:universalworkspace_backend/log.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-user/user_profile.pb.dart';

extension UserProfilePBExtension on UserProfilePB {
  String? get authToken {
    try {
      final map = jsonDecode(token) as Map<String, dynamic>;
      return map['access_token'] as String?;
    } catch (e) {
      Log.error('Failed to decode auth token: $e');
      return null;
    }
  }
}
