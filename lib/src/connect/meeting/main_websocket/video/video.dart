import 'dart:async';
import 'dart:convert';

import 'package:bbb_app/data/models/user/user_camera/user_camera.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/module.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/user/user_module.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/incoming_screenshare_video_connection.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/incoming_webcam_video_connection.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/outgoing_screenshare_video_connection.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/outgoing_webcam_video_connection.dart';
import 'package:bbb_app/src/connect/meeting/meeting_info.dart';
import 'package:bbb_app/src/utils/graphql_ws.dart';
import 'package:bbb_app/src/utils/log.dart';

import 'connection/video_connection.dart';

/// Module dealing with video stream stuff.
class VideoModule extends Module {
  final String _BBB_SFU = "bbb-webrtc-sfu";

  /// Video streams subscription topic to subscribe to.
  static const _subscriptionTopicVideo = "video-streams";
  static const _subscriptionTopicScreenshare = "screenshare";

  /// Controller over which we will publish updated video connection lists.
  StreamController<Map<String, IncomingWebcamVideoConnection>>
      _videoConnectionsStreamController =
      StreamController<Map<String, IncomingWebcamVideoConnection>>.broadcast();

  /// Controller over which we will publish updated screenshare connection lists.
  StreamController<Map<String, IncomingScreenshareVideoConnection>>
      _screenshareVideoConnectionsStreamController = StreamController<
          Map<String, IncomingScreenshareVideoConnection>>.broadcast();
  StreamController<OutgoingWebcamVideoConnection> _webcamShareController =
      StreamController.broadcast();

  /// List of video connections we currently have.
  Map<String, IncomingWebcamVideoConnection> _videoConnectionsByCameraId = {};

  /// Lookup of the camera ID by a stream ID.
  Map<String?, String> _cameraIdByStreamIdLookup = {};

  /// video connection for screenshare stream.
  Map<String, IncomingScreenshareVideoConnection> _screenshareVideoConnections =
      {};

  /// Info for the current meeting.
  final MeetingInfo _meetingInfo;

  /// Webcam the user shares.
  OutgoingWebcamVideoConnection? _webcamShare;

  /// Screen the user shares.
  OutgoingScreenshareVideoConnection? _screenShare;

  /// Type of webcam user shares.
  CAMERATYPE _camtype = CAMERATYPE.FRONT;

  UserModule _userModule;
  GraphQLWebSocket? mediaSocket;

  /// Subscription to user changes.
  late StreamSubscription _userChangesStreamSubscription;
  String videoStreams = '';
  bool initialized = false;
  VideoModule(messageSender, this._meetingInfo, this._userModule)
      : super(messageSender) {
    _userChangesStreamSubscription = _userModule.changes.listen((userEvent) {
      // if (userEvent.data.id != null &&
      //     userEvent.data.id == _meetingInfo.internalUserID &&
      //     !userEvent.data.isPresenter!) {
      //   _unshareScreen();
      // }
    });
  }

  void connect() async {
    final uri = Uri.parse(_meetingInfo.joinUrl!)
        .replace(path: _BBB_SFU)
        .replace(scheme: 'wss');

    Log.info("[VideoConnection] Connecting to ${uri.toString()}...");
    mediaSocket = GraphQLWebSocket(uri.toString(),
        cookie: _meetingInfo.cookie, needInit: false);
    mediaSocket!.onOpen = () {
      Log.info("[VideoConnection] Connected");
    };

    mediaSocket?.onMessage = (message) {
      Log.info("[VideoConnection] Received message: '$message'");

      try {
        final msgJson = json. decode(message);
        if (_videoConnectionsByCameraId.containsKey(msgJson['cameraId'])) {
          _videoConnectionsByCameraId[msgJson['cameraId']]
              ?.onMessageCallback(msgJson);
        }

        if (_webcamShare?.cameraId == msgJson['cameraId'] ||
            _webcamShare?.cameraId == msgJson['streamId']) {
          _webcamShare?.onMessageCallback(msgJson);
        }
      } on FormatException catch (e) {
        Log.warning("[VideoConnection] Received invalid JSON: '$message'");
      }
    };

    mediaSocket!.onClose = (int? code, String? reason) {
      Log.info(
          "[VideoConnection] Connection closed. Reason: '$reason', code: $code");
    };

    mediaSocket!.connectWebSocket();
  }

  @override
  void onConnected() {
    connect();
    videoStreams = subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "Patched_VideoStreams",
      "query":
          "subscription Patched_VideoStreams {\n  user_camera {\n    streamId\n    user {\n      name\n      userId\n      nameSortable\n      pinned\n      away\n      disconnected\n      role\n      avatar\n      color\n      presenter\n      clientType\n      raiseHand\n      isModerator\n      reactionEmoji\n      __typename\n    }\n    voice {\n      floor\n      lastFloorTime\n      joined\n      listenOnly\n      userId\n      __typename\n    }\n    __typename\n  }\n}"
    });
  }

  @override
  void onDisconnectBeforeWebsocketClose() {
    _unshareWebcam();
  }

  @override
  Future<void> onDisconnect() async {
    _videoConnectionsStreamController.close();
    _screenshareVideoConnectionsStreamController.close();
    _videoConnectionsByCameraId.forEach((key, videoConnection) {
      videoConnection.close();
    });
    _screenshareVideoConnections.forEach((key, videoConnection) {
      videoConnection.close();
    });
    _unshareWebcam();
    _unshareScreen();
    _webcamShareController.close();
    _userChangesStreamSubscription.cancel();
    await mediaSocket?.disconnect();
  }

  List<UserCamera> listUserCamera = [];
  void _patchProcess(String id, List patches) {
    patches.forEach((element) {
      if (element['op'] == 'add') {
        final userCamera = UserCamera.fromJson(element['value']);
        IncomingWebcamVideoConnection v = IncomingWebcamVideoConnection(
            _meetingInfo,
            userCamera.streamId,
            userCamera.user?.userId ?? '',
            mediaSocket!.sendMessage);
        _videoConnectionsByCameraId[userCamera.streamId!] = v;
        listUserCamera.add(userCamera);
        v.init().then((value) {
          _videoConnectionsStreamController.add(_videoConnectionsByCameraId);
        });
        _cameraIdByStreamIdLookup[id] = userCamera.streamId!;
      } else {
        // IncomingWebcamVideoConnection v =
        //     _videoConnectionsByCameraId.remove(element)!;

        // _videoConnectionsStreamController.add(_videoConnectionsByCameraId);

        // v.close();
      }
    });
  }

  @override
  void processMessage(Map<String, dynamic> msg) {
    if (msg['id'] == videoStreams) {
      if (msg['payload']['data']['patch'] != null) {
        final patches = msg['payload']['data']['patch'] as List;
        _patchProcess(msg['id'], patches);
        return;
      }
      final list = msg['payload']['data']['user_camera'] as List;
      final currentCameraList = <UserCamera>[];
      if (list.isNotEmpty == true) {
        list.forEach((element) {
          final userCamera = UserCamera.fromJson(element);
          currentCameraList.add(userCamera);
        });
      }

      final added = currentCameraList
          .map((e) => e.streamId)
          .toSet()
          .difference(_videoConnectionsByCameraId.keys.toSet());
      final removed = _videoConnectionsByCameraId.keys
          .toSet()
          .difference(currentCameraList.map((e) => e.streamId).toSet());
      added.forEach((element) {
        final userCamera =
            currentCameraList.firstWhere((e) => e.streamId == element);
        if (userCamera.streamId != null) {
          IncomingWebcamVideoConnection v = IncomingWebcamVideoConnection(
              _meetingInfo,
              userCamera.streamId,
              userCamera.user?.userId ?? '',
              mediaSocket!.sendMessage);
          _videoConnectionsByCameraId[userCamera.streamId!] = v;
          listUserCamera.add(userCamera);
          v.init().then((value) {
            _videoConnectionsStreamController.add(_videoConnectionsByCameraId);
          });
          _cameraIdByStreamIdLookup[msg["id"]] = userCamera.streamId!;
        }
      });
      removed.forEach((element) {
        IncomingWebcamVideoConnection v =
            _videoConnectionsByCameraId.remove(element)!;

        _videoConnectionsStreamController.add(_videoConnectionsByCameraId);

        v.close();
      });
    }

    // final String? method = msg["msg"];

    // if (method == "added") {
    //   String? collectionName = msg["collection"];

    //   } else if (collectionName == "screenshare") {
    //     String? id = msg["id"];
    //     if (id != null) {
    //       Log.info("[VideoModule] Adding new screenshare stream...");

    //       IncomingScreenshareVideoConnection v =
    //           IncomingScreenshareVideoConnection(_meetingInfo);
    //       _screenshareVideoConnections[id] = v;

    //       v.init().then((_) => {
    //             //Publish changed screenshare connections list
    //             _screenshareVideoConnectionsStreamController
    //                 .add(_screenshareVideoConnections)
    //           });
    //     }
    //   }
    // } else if (method == "removed") {
    //   String? collectionName = msg["collection"];

    //   } else if (collectionName == "screenshare") {
    //     Log.info("[VideoModule] Removing screenshare stream...");

    //     String? id = msg["id"];

    //     IncomingScreenshareVideoConnection v =
    //         _screenshareVideoConnections.remove(id)!;

    //     // Publish changed video connections list
    //     _screenshareVideoConnectionsStreamController
    //         .add(_screenshareVideoConnections);

    //     v.close();
    //   }
    // }
  }

  Future<void> _shareWebcam() async {
    if (_webcamShare == null) {
      _webcamShare = OutgoingWebcamVideoConnection(
          _meetingInfo, messageSender, _camtype, mediaSocket!.sendMessage);

      await _webcamShare!.init().catchError((e) {
        _webcamShare = null;
      });
    }
  }

  void _unshareWebcam() {
    if (_webcamShare != null) {
      _webcamShare!.close();
      _webcamShare = null;
    }
  }

  Future<void> toggleWebcamOnOff() async {
    if (_webcamShare == null) {
      await _shareWebcam();
    } else if (_webcamShare != null) {
      _unshareWebcam();
    }
  }

  Future<void> toggleWebcamFrontBack() async {
    _unshareWebcam();

    if (_camtype == CAMERATYPE.BACK) {
      _camtype = CAMERATYPE.FRONT;
    } else if (_camtype == CAMERATYPE.FRONT) {
      _camtype = CAMERATYPE.BACK;
    }

    await _shareWebcam();
  }

  bool isWebcamActive() {
    return _webcamShare != null;
  }

  void _shareScreen() {
    if (_screenShare == null) {
      _screenShare = OutgoingScreenshareVideoConnection(
          _meetingInfo, mediaSocket!.sendMessage);
      _screenShare!.init().catchError((e) {
        _screenShare = null;
      });
    }
  }

  void _unshareScreen() {
    if (_screenShare != null) {
      _screenShare!.close();
      _screenShare = null;
    }
  }

  void toggleScreenshareOnOff() {
    if (_screenShare == null) {
      _shareScreen();
    } else if (_screenShare != null) {
      _unshareScreen();
    }
  }

  bool isScreenshareActive() {
    return _screenShare != null;
  }

  void ping() {
    if (!initialized) {
      initialized = true;
      checkPing();
    }
    mediaSocket?.sendMessage({
      'id': VideoConnectId.PING,
    });
  }

  Timer? timer;
  void checkPing() {
    if (timer == null || !timer!.isActive) {
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 15), (t) {
        Log.verbose('[Video connection] ${DateTime.now()} Check ping');
        ping();
      });
    }
  }

  /// Get a stream of video connections lists that are updated when new camera IDs pop up
  /// or are removed.
  Stream<Map<String, IncomingWebcamVideoConnection>>
      get videoConnectionsStream => _videoConnectionsStreamController.stream;

  /// Get a stream of screenshare connections lists that are updated when new screenshares pop up
  /// or are removed.
  Stream<Map<String, IncomingScreenshareVideoConnection>>
      get screenshareVideoConnectionsStream =>
          _screenshareVideoConnectionsStreamController.stream;

  /// Get the currently listed video connections.
  Map<String, IncomingWebcamVideoConnection> get videoConnections =>
      _videoConnectionsByCameraId;

  /// Get the currently listed screenshare connections.
  Map<String, IncomingScreenshareVideoConnection>
      get screenshareVideoConnections => _screenshareVideoConnections;

  Stream<OutgoingWebcamVideoConnection> get myCam =>
      _webcamShareController.stream;
}
