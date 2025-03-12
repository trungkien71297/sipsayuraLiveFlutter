import 'user.dart';
import 'voice.dart';

class UserCamera {
  String? streamId;
  User? user;
  Voice? voice;
  String? typename;

  UserCamera({this.streamId, this.user, this.voice, this.typename});

  factory UserCamera.fromJson(Map<String, dynamic> json) => UserCamera(
        streamId: json['streamId'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        voice: json['voice'] == null
            ? null
            : Voice.fromJson(json['voice'] as Map<String, dynamic>),
        typename: json['__typename'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'streamId': streamId,
        'user': user?.toJson(),
        'voice': voice?.toJson(),
        '__typename': typename,
      };
}
