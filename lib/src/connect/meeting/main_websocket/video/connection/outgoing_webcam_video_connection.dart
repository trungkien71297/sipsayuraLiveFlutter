import 'dart:developer';

import 'package:bbb_app/src/connect/meeting/main_websocket/util/util.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/video_connection.dart';
import 'package:bbb_app/src/utils/convert.dart';
import 'package:bbb_app/src/utils/log.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:uuid/uuid.dart';

enum CAMERATYPE { FRONT, BACK }

/// Sender function for messages.
typedef MessageSender = void Function(Map<String, dynamic> msg);

class OutgoingWebcamVideoConnection extends VideoConnection {
  /// Sender to send message over the websocket with.
  late MessageSender _messageSender;

  /// Camera ID of the webcam stream.
  String? _cameraId;

  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  ValueNotifier<bool> readyToPlay = ValueNotifier(false);

  /// The webcam stream.
  MediaStream? _localStream;

  CAMERATYPE? _camtype;

  OutgoingWebcamVideoConnection(var meetingInfo, MessageSender messageSender,
      CAMERATYPE camtype, MessageSender sender)
      : super(meetingInfo, sender) {
    _messageSender = messageSender;
    _camtype = camtype;
  }

  @override
  Future<void> init() async {
    _localStream = await _createWebcamStream();
    if (_localStream == null) {
      throw Exception("local stream was null");
    }
    return super.init();
  }

  @override
  void close() {
    sender({
      'id': VideoConnectId.STOP,
      'type': 'video',
      'cameraId': _cameraId,
      'role': 'share',
    });

    super.close();
    _localStream!.dispose();
  }

  @override
  onPlayStart(message) {
    log('==kien 57 outgoing_webcam_video_connection.dart playstrea, asmcjkolamsfop, == ${DateTime.now().toString()}');
    // remoteRenderer.srcObject = _localStream;
    // _messageSender({
    //   "msg": "method",
    //   "method": "userShareWebcam",
    //   "params": [
    //     _cameraId,
    //   ],
    // });
  }

  @override
  afterCreatePeerConnection() async {
    final encode = Conver.convertToSHA256Base64(_localStream?.id ?? '');
    _cameraId = (meetingInfo.userId ?? '') +
        '_' +
        (meetingInfo.clienSessionID) +
        '_' +
        encode;

    for (MediaStreamTrack track in _localStream!.getTracks()) {
      await pc.addTrack(track, _localStream!);
    }
    _messageSender({
      "id": Uuid().v4(),
      "type": "subscribe",
      "payload": {
        "variables": {"cameraId": _cameraId, "contentType": "camera"},
        "extensions": {},
        "operationName": "CameraBroadcastStart",
        "query":
            "mutation CameraBroadcastStart(\$cameraId: String!, \$contentType: String!) {\n  cameraBroadcastStart(stream: \$cameraId, contentType: \$contentType)\n}"
      }
    });
  }

  @override
  onIceCandidate(candidate) {
    sender({
      'cameraId': _cameraId,
      'candidate': {
        'candidate': candidate.candidate,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
      },
      'id': 'onIceCandidate',
      'role': 'share',
      'type': 'video'
    });
  }

  @override
  sendOffer(RTCSessionDescription? s) async {
    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    String sdp = offer.sdp ?? '';
    sdp.replaceAll(r'\n', '\n');
    log('==kien 119 outgoing_webcam_video_connection.dart ${sdp} == ${DateTime.now().toString()}');
    sender({
      'id': 'start',
      'type': 'video',
      'cameraId': _cameraId,
      'role': 'share',
      'sdpOffer': sdp,
      'bitrate': 50,
      'record': true,
    });
  }

  @override
  onStartResponse(message) async {
    await pc.setRemoteDescription(new RTCSessionDescription(sdp, 'answer'));
  }

  Future<MediaStream> _createWebcamStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': true,
    };

    MediaStream stream = await navigator.mediaDevices
        .getUserMedia(mediaConstraints)
        .catchError((e) {
      Log.error("An error occurred while trying to open a webcam stream: '$e'");
    });

    return stream;
  }

  String get cameraId => _cameraId ?? '';
}
