import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'incoming_video_connection.dart';

class IncomingWebcamVideoConnection extends IncomingVideoConnection {
  /// Camera ID to display stream for.
  String? _cameraId;

  /// ID of the user that this stream belongs to.
  String? internalUserId;

  ValueNotifier<bool> readyToPlay = ValueNotifier(false);

  IncomingWebcamVideoConnection(meetingInfo, cameraId, userId)
      : super(meetingInfo) {
    this._cameraId = cameraId;
    this.internalUserId = userId;
  }

  @override
  onPlayStart(message) {
    remoteRenderer.srcObject = pc.getRemoteStreams()[0];
    readyToPlay.value = true;
  }

  @override
  onIceCandidate(RTCIceCandidate candidate) {
    graphQLWebSocket?.sendMessage({
      'cameraId': _cameraId,
      'candidate': {
        'candidate': candidate.candidate,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
      },
      'id': 'onIceCandidate',
      'role': 'viewer',
      'type': 'video'
    });
  }

  @override
  sendOffer(RTCSessionDescription s) {
    graphQLWebSocket?.sendMessage({
      'bitrate': 100,
      'cameraId': _cameraId,
      'id': 'start',
      'meetingId': meetingInfo.meetingID,
      'record': true,
      'role': 'viewer',
      'sdpOffer': s.sdp,
      'type': 'video',
      'userId': meetingInfo.internalUserID,
      'userName': meetingInfo.fullUserName,
      'voiceBridge': meetingInfo.voiceBridge,
    });
  }

  @override
  onStartResponse(message) {
    log('==kien 61 incoming_webcam_video_connection.dart ${message} == ${DateTime.now().toString()}');
    graphQLWebSocket?.sendMessage({
      "id": "subscriberAnswer",
      "type": "video",
      "role": "viewer",
      "cameraId": _cameraId,
      "answer": message
    });
  }
}
