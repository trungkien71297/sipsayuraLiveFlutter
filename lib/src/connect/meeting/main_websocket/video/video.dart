import 'dart:async';

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

/// Module dealing with video stream stuff.
class VideoModule extends Module {
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

  @override
  void onConnected() {
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
    _userChangesStreamSubscription.cancel();
  }

  List<UserCamera> listUserCamera = [];

  @override
  void processMessage(Map<String, dynamic> msg) {
    if (msg['id'] == videoStreams) {
      Log.verbose('==kien 123123');
      final list = msg['payload']['data']['user_camera'] as List;
      if (list.isNotEmpty == true) {
        list.forEach((element) {
          Log.info("[VideoModule] Adding new video stream...");
          final userCamera = UserCamera.fromJson(element);
          if (userCamera.streamId != null) {
            IncomingWebcamVideoConnection v = IncomingWebcamVideoConnection(
                _meetingInfo,
                userCamera.streamId,
                userCamera.user?.userId ?? '');
            _videoConnectionsByCameraId[userCamera.streamId!] = v;
            listUserCamera.add(userCamera);
            v.init().then((value) {
              _videoConnectionsStreamController
                  .add(_videoConnectionsByCameraId);
            });
            _cameraIdByStreamIdLookup[msg["id"]] = userCamera.streamId!;
          }
        });
      }
    }
    // final String? method = msg["msg"];

    // if (method == "added") {
    //   String? collectionName = msg["collection"];

    //   if (collectionName == "video-streams") {
    //     String? cameraID = msg["fields"]["stream"];
    //     String? userID = msg["fields"]["userId"];
    //     if (cameraID != null && userID != null) {
    //       Log.info("[VideoModule] Adding new video stream...");

    //       IncomingWebcamVideoConnection v =
    //           IncomingWebcamVideoConnection(_meetingInfo, cameraID, userID);
    //       _videoConnectionsByCameraId[cameraID] = v;

    //       v.init().then((value) => {
    //             // Publish changed video connections list
    //             _videoConnectionsStreamController
    //                 .add(_videoConnectionsByCameraId)
    //           });

    //       _cameraIdByStreamIdLookup[msg["id"]] = cameraID;
    //     }
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

    //   if (collectionName == "video-streams") {
    //     Log.info("[VideoModule] Removing video stream...");

    //     String? streamID = msg["id"];
    //     String? cameraID = _cameraIdByStreamIdLookup[streamID];

    //     IncomingWebcamVideoConnection v =
    //         _videoConnectionsByCameraId.remove(cameraID)!;

    //     // Publish changed video connections list
    //     _videoConnectionsStreamController.add(_videoConnectionsByCameraId);

    //     v.close();
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
      _webcamShare =
          OutgoingWebcamVideoConnection(_meetingInfo, messageSender, _camtype);
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
      _screenShare = OutgoingScreenshareVideoConnection(_meetingInfo);
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
}
