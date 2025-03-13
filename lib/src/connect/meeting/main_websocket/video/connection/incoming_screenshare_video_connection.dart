import 'package:bbb_app/src/connect/meeting/main_websocket/module.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'incoming_video_connection.dart';

class IncomingScreenshareVideoConnection extends IncomingVideoConnection {
  IncomingScreenshareVideoConnection(meetingInfo, MessageSender sender)
      : super(meetingInfo, sender);

  @override
  onStartResponse(message) {
    remoteRenderer.srcObject = pc.getRemoteStreams()[0];
  }

  @override
  onIceCandidate(candidate) {
    sender({
      'callerName': meetingInfo.internalUserID,
      'candidate': {
        'candidate': candidate.candidate,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
      },
      'id': 'iceCandidate',
      'role': 'recv',
      'type': 'screenshare',
      'voiceBridge': meetingInfo.voiceBridge
    });
  }

  @override
  sendOffer(RTCSessionDescription? s) {
    sender({
      'callerName': meetingInfo.internalUserID,
      'id': 'start',
      'internalMeetingId': meetingInfo.meetingID,
      'role': 'recv',
      'sdpOffer': s?.sdp,
      'type': 'screenshare',
      'userName': meetingInfo.fullUserName,
      'voiceBridge': meetingInfo.voiceBridge,
    });
  }
}
