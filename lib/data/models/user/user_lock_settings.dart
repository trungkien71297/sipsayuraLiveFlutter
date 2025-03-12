import 'package:collection/collection.dart';

class UserLockSettings {
  final bool? disablePublicChat;
  final String? typename;

  const UserLockSettings({this.disablePublicChat, this.typename});

  @override
  String toString() {
    return 'UserLockSettings(disablePublicChat: $disablePublicChat, typename: $typename)';
  }

  factory UserLockSettings.fromJson(Map<String, dynamic> json) {
    return UserLockSettings(
      disablePublicChat: json['disablePublicChat'] as bool?,
      typename: json['__typename'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'disablePublicChat': disablePublicChat,
        '__typename': typename,
      };
}
