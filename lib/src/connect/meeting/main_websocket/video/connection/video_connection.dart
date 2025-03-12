import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bbb_app/src/connect/meeting/meeting_info.dart';
import 'package:bbb_app/src/utils/graphql_ws.dart';
import 'package:bbb_app/src/utils/log.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Class encapsulating a WebRTC video stream connection.
abstract class VideoConnection {
  final String _BBB_SFU = "bbb-webrtc-sfu";

  /// Info of the current meeting.
  late MeetingInfo meetingInfo;

  VideoConnection(var meetingInfo) {
    this.meetingInfo = meetingInfo;
  }
  GraphQLWebSocket? graphQLWebSocket;
  late RTCPeerConnection pc;
  bool closed = false;
  bool initialized = false;
  Timer? timer;
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
    connect();
  }

  void close() async {
    await graphQLWebSocket?.disconnect();
    pc.close();
    timer?.cancel();
  }

  void connect() async {
    final uri = Uri.parse(meetingInfo.joinUrl!)
        .replace(path: _BBB_SFU)
        .replace(scheme: 'wss');

    Log.info("[VideoConnection] Connecting to ${uri.toString()}...");
    graphQLWebSocket = GraphQLWebSocket(uri.toString(),
        cookie: meetingInfo.cookie, needInit: false);
    graphQLWebSocket!.onOpen = () {
      Log.info("[VideoConnection] Connected");
      openConnection();
    };

    graphQLWebSocket!.onMessage = (message) {
      Log.info("[VideoConnection] Received message: '$message'");

      try {
        onMessage(json.decode(message));
      } on FormatException catch (e) {
        Log.warning("[VideoConnection] Received invalid JSON: '$message'");
      }
    };

    graphQLWebSocket!.onClose = (int? code, String? reason) {
      Log.info(
          "[VideoConnection] Connection closed. Reason: '$reason', code: $code");
    };

    graphQLWebSocket!.connectWebSocket();
  }

  void ping() {
    if (!initialized) {
      initialized = true;
      checkPing();
    }
    graphQLWebSocket?.sendMessage({
      'id': VideoConnectId.PING,
    });
  }

  void onMessage(message) async {
    switch (message['id']) {
      case VideoConnectId.STARTRESPONSE:
        {
          await pc.setRemoteDescription(
              new RTCSessionDescription(message['sdpAnswer'], 'answer'));
          final answer = await pc.createAnswer();
          onStartResponse(answer);
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

  Future<void> createOffer() async {
    try {
      Map<String, dynamic> config = {"sdpSemantics": "unified-plan"};
      config.addAll(meetingInfo.iceServers!);

      pc = await createPeerConnection(config, _peerConnectionConstraints);

      await afterCreatePeerConnection();

      pc.onIceCandidate = (candidate) {
        onIceCandidate(candidate);
      };

      RTCSessionDescription s = await pc.createOffer(_constraints);
      await pc.setLocalDescription(s);

      sendOffer(s);
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

  sendOffer(RTCSessionDescription s) {}

  void checkPing() {
    if (timer == null || !timer!.isActive) {
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 15), (t) {
        Log.verbose('[Video connection] ${DateTime.now()} Check ping');
        ping();
      });
    }
  }

  void openConnection() async {
    ping();
    await createOffer();
  }
}

class VideoConnectId {
  static const String PING = 'ping';
  static const String PONG = 'pong';
  static const String STARTRESPONSE = 'startResponse';
  static const String START = 'start';
  static const String SUBCRIBERANSWER = 'subscriberAnswer';
  static const String PLAYSTART = 'playStart';
}
