import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/outgoing_webcam_video_connection.dart';
import 'package:bbb_app/src/connect/meeting/meeting_info.dart';
import 'package:bbb_app/src/utils/graphql_ws.dart';
import 'package:bbb_app/src/utils/log.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Class encapsulating a WebRTC video stream connection.
abstract class VideoConnection {
  /// Info of the current meeting.
  late MeetingInfo meetingInfo;
  late MessageSender sender;
  late OnMessageCallback onMessageCallback;
  VideoConnection(var meetingInfo, MessageSender sender) {
    this.meetingInfo = meetingInfo;
    this.sender = sender;
    this.onMessageCallback = onMessage;
  }
  late RTCPeerConnection pc;
  bool closed = false;
  String? sdp;
  RTCSessionDescription? s;
  final Map<String, dynamic> _peerConnectionConstraints = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> _constraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  Future<void> init() async {
    createConnection();
  }

  void close() async {
    pc.close();
  }

  void onMessage(message) async {
    log('==kien 50 video_connection.dart ${message} == ${DateTime.now().toString()}');
    switch (message['id']) {
      case VideoConnectId.STARTRESPONSE:
        {
          sdp = message['sdpAnswer'];
          onStartResponse(message);
        }
        break;

      case 'iceCandidate':
        {
          RTCIceCandidate candidate = new RTCIceCandidate(
              message['candidate']['candidate'],
              message['candidate']['sdpMid'],
              message['candidate']['sdpMLineIndex']);
          await pc.addCandidate(candidate);
        }
        break;

      case VideoConnectId.PLAYSTART:
        {
          onPlayStart(message);
        }
        break;
      case VideoConnectId.PONG:
        break;
      default:
        break;
    }
  }

  Future<void> createConnection() async {
    try {
      Map<String, dynamic> config = {"sdpSemantics": "unified-plan"};
      config.addAll(meetingInfo.iceServers!);

      pc = await createPeerConnection(config, _peerConnectionConstraints);

      await afterCreatePeerConnection();

      // pc.onIceCandidate = (candidate) {
      //   onIceCandidate(candidate);
      // };

      // RTCSessionDescription s = await pc.createOffer(_constraints);
      // await pc.setLocalDescription(s);
      sendOffer(null);
    } catch (e) {
      Log.error(
          "[VideoConnection] Encountered an error while trying to create an offer",
          e);
    }
  }

  onStartResponse(message) {}

  onPlayStart(message) {}

  afterCreatePeerConnection() {}

  onIceCandidate(RTCIceCandidate candidate) {}

  sendOffer(RTCSessionDescription? s) {}
}

class VideoConnectId {
  static const String PING = 'ping';
  static const String PONG = 'pong';
  static const String STARTRESPONSE = 'startResponse';
  static const String START = 'start';
  static const String STOP = 'stop';
  static const String SUBSCRIBERANSWER = 'subscriberAnswer';
  static const String PLAYSTART = 'playStart';
}
