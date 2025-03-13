import 'dart:developer';

import 'package:bbb_app/src/connect/meeting/main_websocket/module.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/connection/video_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'incoming_video_connection.dart';

class IncomingWebcamVideoConnection extends IncomingVideoConnection {
  /// Camera ID to display stream for.
  String? _cameraId;

  /// ID of the user that this stream belongs to.
  String? internalUserId;

  ValueNotifier<bool> readyToPlay = ValueNotifier(false);

  IncomingWebcamVideoConnection(
      meetingInfo, cameraId, userId, MessageSender sender)
      : super(meetingInfo, sender) {
    this._cameraId = cameraId;
    this.internalUserId = userId;
  }

  @override
  onPlayStart(message) {
    log('==kien 28 incoming_webcam_video_connection.dart ${message} == ${DateTime.now().toString()}');
    remoteRenderer.srcObject = pc.getRemoteStreams()[0];
    readyToPlay.value = true;
  }

  @override
  onIceCandidate(RTCIceCandidate candidate) {
    sender({
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
  sendOffer(RTCSessionDescription? s) {
    sender({
      'bitrate': 100,
      'cameraId': _cameraId,
      'id': 'start',
      'meetingId': meetingInfo.meetingID,
      'record': true,
      'role': 'viewer',
      'sdpOffer': null,
      'type': 'video',
      'userId': meetingInfo.internalUserID,
      'userName': meetingInfo.fullUserName,
      'voiceBridge': meetingInfo.voiceBridge,
    });
  }

  @override
  onStartResponse(message) async {
    await pc.setRemoteDescription(new RTCSessionDescription(sdp, 'offer'));
    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    sender({
      "id": "subscriberAnswer",
      "type": "video",
      "role": "viewer",
      "cameraId": _cameraId,
      "answer": answer.sdp
    });
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
  }
}
