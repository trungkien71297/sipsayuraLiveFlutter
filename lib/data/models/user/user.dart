import 'package:collection/collection.dart';

import 'user_lock_settings.dart';

class User {
  final bool? isDialIn;
  final String? userId;
  final String? extId;
  final String? name;
  final bool? isModerator;
  final String? role;
  final String? color;
  final String? avatar;
  final bool? away;
  final bool? raiseHand;
  final dynamic reactionEmoji;
  final bool? presenter;
  final bool? pinned;
  final bool? locked;
  final bool? authed;
  final bool? mobile;
  final bool? bot;
  final bool? guest;
  final String? clientType;
  final bool? disconnected;
  final bool? loggedOut;
  final dynamic voice;
  final List<dynamic>? cameras;
  final List<dynamic>? presPagesWritable;
  final dynamic lastBreakoutRoom;
  final UserLockSettings? userLockSettings;
  final String? typename;

  const User({
    this.isDialIn,
    this.userId,
    this.extId,
    this.name,
    this.isModerator,
    this.role,
    this.color,
    this.avatar,
    this.away,
    this.raiseHand,
    this.reactionEmoji,
    this.presenter,
    this.pinned,
    this.locked,
    this.authed,
    this.mobile,
    this.bot,
    this.guest,
    this.clientType,
    this.disconnected,
    this.loggedOut,
    this.voice,
    this.cameras,
    this.presPagesWritable,
    this.lastBreakoutRoom,
    this.userLockSettings,
    this.typename,
  });

  @override
  String toString() {
    return 'User(isDialIn: $isDialIn, userId: $userId, extId: $extId, name: $name, isModerator: $isModerator, role: $role, color: $color, avatar: $avatar, away: $away, raiseHand: $raiseHand, reactionEmoji: $reactionEmoji, presenter: $presenter, pinned: $pinned, locked: $locked, authed: $authed, mobile: $mobile, bot: $bot, guest: $guest, clientType: $clientType, disconnected: $disconnected, loggedOut: $loggedOut, voice: $voice, cameras: $cameras, presPagesWritable: $presPagesWritable, lastBreakoutRoom: $lastBreakoutRoom, userLockSettings: $userLockSettings, typename: $typename)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        isDialIn: json['isDialIn'] as bool?,
        userId: json['userId'] as String?,
        extId: json['extId'] as String?,
        name: json['name'] as String?,
        isModerator: json['isModerator'] as bool?,
        role: json['role'] as String?,
        color: json['color'] as String?,
        avatar: json['avatar'] as String?,
        away: json['away'] as bool?,
        raiseHand: json['raiseHand'] as bool?,
        reactionEmoji: json['reactionEmoji'] as dynamic,
        presenter: json['presenter'] as bool?,
        pinned: json['pinned'] as bool?,
        locked: json['locked'] as bool?,
        authed: json['authed'] as bool?,
        mobile: json['mobile'] as bool?,
        bot: json['bot'] as bool?,
        guest: json['guest'] as bool?,
        clientType: json['clientType'] as String?,
        disconnected: json['disconnected'] as bool?,
        loggedOut: json['loggedOut'] as bool?,
        voice: json['voice'] as dynamic,
        cameras: json['cameras'] as List<dynamic>?,
        presPagesWritable: json['presPagesWritable'] as List<dynamic>?,
        lastBreakoutRoom: json['lastBreakoutRoom'] as dynamic,
        userLockSettings: json['userLockSettings'] == null
            ? null
            : UserLockSettings.fromJson(
                json['userLockSettings'] as Map<String, dynamic>),
        typename: json['__typename'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'isDialIn': isDialIn,
        'userId': userId,
        'extId': extId,
        'name': name,
        'isModerator': isModerator,
        'role': role,
        'color': color,
        'avatar': avatar,
        'away': away,
        'raiseHand': raiseHand,
        'reactionEmoji': reactionEmoji,
        'presenter': presenter,
        'pinned': pinned,
        'locked': locked,
        'authed': authed,
        'mobile': mobile,
        'bot': bot,
        'guest': guest,
        'clientType': clientType,
        'disconnected': disconnected,
        'loggedOut': loggedOut,
        'voice': voice,
        'cameras': cameras,
        'presPagesWritable': presPagesWritable,
        'lastBreakoutRoom': lastBreakoutRoom,
        'userLockSettings': userLockSettings?.toJson(),
        '__typename': typename,
      };
}
