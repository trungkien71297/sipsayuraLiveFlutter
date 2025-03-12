import 'dart:async';

import 'package:bbb_app/data/models/user/user.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/module.dart';

/// Module dealing with meeting participants/user information.
class UserModule extends Module {
  /// Stream controller to publish participant changes with.
  StreamController<List<User?>> _userStreamController =
      StreamController.broadcast();

  List<User?> _usersByID = [];

  String? subId;
  UserModule(messageSender) : super(messageSender);
  @override
  void onConnected() {
    subId = subscribe(payload: {
      "variables": {"offset": 0, "limit": 50},
      "extensions": {},
      "operationName": "Patched_UserListSubscription",
      "query":
          "subscription Patched_UserListSubscription(\$offset: Int!, \$limit: Int!) {\n  user(\n    limit: \$limit\n    offset: \$offset\n    order_by: [{nameSortable: asc}]\n  ) {\n    isDialIn\n    userId\n    extId\n    name\n    isModerator\n    role\n    color\n    avatar\n    away\n    raiseHand\n    reactionEmoji\n    avatar\n    presenter\n    pinned\n    locked\n    authed\n    mobile\n    bot\n    guest\n    clientType\n    disconnected\n    loggedOut\n    voice {\n      joined\n      listenOnly\n      voiceUserId\n      __typename\n    }\n    cameras {\n      streamId\n      __typename\n    }\n    presPagesWritable {\n      isCurrentPage\n      pageId\n      userId\n      __typename\n    }\n    lastBreakoutRoom {\n      isDefaultName\n      sequence\n      shortName\n      currentlyInRoom\n      __typename\n    }\n    userLockSettings {\n      disablePublicChat\n      __typename\n    }\n    __typename\n  }\n}"
    });
    subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "UsersCount",
      "query":
          "subscription UsersCount {\n  user_aggregate {\n    aggregate {\n      count\n      __typename\n    }\n    __typename\n  }\n}"
    });
  }

  @override
  Future<void> onDisconnect() async {
    _userStreamController.close();
  }

  @override
  void processMessage(Map<String, dynamic> msg) {
    if (msg['id'] == subId) {
      final data = msg['payload']['data'];
      if (data['patch'] != null) {
        final patches = (data['patch'] as List);
        _patchProcess(patches);
      } else {
        final usersList = data['user'] as List?;
        if (usersList?.isNotEmpty == true) {
          usersList?.forEach((element) {
            final u = User.fromJson(element);
            _usersByID.add(u);
          });
        }
      }
      _userStreamController.sink.add(users);
    }
  }

  void _patchProcess(List patches) {
    for (var p in patches) {
      switch (p['op']) {
        case 'add':
          final u = p['value'];
          _usersByID.add(User.fromJson(u));
          _usersByID.sort(((a, b) => (a?.name?.toLowerCase() ?? '')
              .compareTo(b?.name?.toLowerCase() ?? '')));
          break;
        case 'remove':
          final pos = (p['path'] as String).replaceAll('/', '');
          final posInt = int.tryParse(pos);
          if (posInt != null) {
            _usersByID.removeAt(posInt);
          }
          break;
        default:
      }
    }
  }

  Stream<List<User?>> get changes => _userStreamController.stream;

  List<User?> get users => List.of(_usersByID);

  User? getUserByID(String? id) =>
      _usersByID.firstWhere((element) => element?.userId == id);
}
