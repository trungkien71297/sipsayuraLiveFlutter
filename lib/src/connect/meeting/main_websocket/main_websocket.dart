import 'dart:async';
import 'dart:convert';

import 'package:bbb_app/src/broadcast/module_bloc_provider.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/chat/chat.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/meeting/meeting.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/module.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/poll/poll.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/presentation/presentation.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/user/user_module.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/video/video.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/voice/call_module.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/voice/voice_call_states.dart';
import 'package:bbb_app/src/connect/meeting/main_websocket/voice/voice_users.dart';
import 'package:bbb_app/src/connect/meeting/meeting_info.dart';
import 'package:bbb_app/src/utils/const.dart';
import 'package:bbb_app/src/utils/graphql_ws.dart';
import 'package:bbb_app/src/utils/log.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
part 'main_websocket_graphql.dart';

/// Main websocket connection to the BBB web server.
class MainWebSocket {
  /// Info of the meeting to create main websocket connection for.
  MeetingInfo _meetingInfo;

  /// Web socket instance to use.
  late GraphQLWebSocket _webSocket;
  GraphQLWebSocket? _mediaSocket;

  /// Counter used to generate message IDs.
  int msgIdCounter = 1;

  /// Modules the web socket is delegating messages to.
  late Map<String, Module> _modules;

  /// ID of the msg validating the user. save for msg confirm purposes.
  String? _validateAuthTokenMsgId;

  /// how often validateAuthToken is sent already
  int _validateAuthTokenMsgCount = 0;

  /// If the user is validated.
  bool _userIsValidated = false;

  ModuleBlocProvider _provider;
  Set<String> needComplete = {};

  /// Create main web socket connection.
  MainWebSocket(this._meetingInfo, this._provider) {
    _setupModules();

    // final uri = Uri.parse(_meetingInfo.joinUrl!)
    //     .replace(queryParameters: null)
    //     .replace(path: "graphql");
    final url = 'wss://$baseURL/graphql';
    _webSocket = GraphQLWebSocket(url,
        cookie: _meetingInfo.cookie,
        connectionInit: {
          "headers": {
            "X-Session-Token": _meetingInfo.sessionToken,
            "X-ClientSessionUUID": Uuid().v4(),
            "X-ClientType": "Android",
            "X-ClientIsMobile": "true"
          }
        },
        protocol: 'graphql-transport-ws');
    Log.info("Connecting to main websocket at '$url'");
    _webSocket.onOpen = () {
      Log.info("Open connection");
    };
    _webSocket.onMessage = (message) {
      Log.verbose("[MainWebsocket] (Received data) | '$message'");
      _processMessage2(message);
    };

    _webSocket.onClose = (int? code, String? reason) async {
      Log.info(
          "Main websocket connection closed. Reason: '$reason', code: $code");

      for (MapEntry<String, Module> moduleEntry in _modules.entries) {
        await moduleEntry.value.onDisconnect();
      }
    };

    // _webSocket.connect();
    _webSocket.connectWebSocket();
  }

  /// Disconnect the web socket.
  Future<void> disconnect() async {
    await logout();
  }

  /// Logout the user from the meeting.
  Future<void> logout() async {
    // _webSocket.sendMessage({
    //   "data": {"userLeaveMeeting": true}
    // });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "UserLeaveMeeting",
      "query": "mutation UserLeaveMeeting {\n  userLeaveMeeting\n}"
    });

    await _webSocket.disconnect();
    await _mediaSocket?.disconnect();
    for (MapEntry<String, Module> moduleEntry in _modules.entries) {
      moduleEntry.value.onDisconnectBeforeWebsocketClose();
    }

    // Call logout URL
    // await http.get(Uri.parse(_meetingInfo.logoutUrl!), headers: {
    //   "cookie": _meetingInfo.cookie!,
    // });
  }

  /// Set up the web socket modules.
  void _setupModules() {
    final MessageSender messageSender = (msg) => _webSocket.sendMessage(msg);

    final UserModule userModule = UserModule(messageSender);

    _modules = {
      "meeting": MeetingModule(messageSender),
      // "ping": PingModule(messageSender),
      "video": VideoModule(messageSender, _meetingInfo, userModule),
      "user": userModule,
      "chat": ChatModule(messageSender, _meetingInfo, userModule, _provider),
      "presentation": PresentationModule(messageSender, _meetingInfo),
      "poll": PollModule(messageSender),
      "call": CallModule(messageSender, _meetingInfo, _provider),
      "voiceUsers":
          VoiceUsersModule(messageSender, _meetingInfo, userModule, _provider),
      "voiceCallState": VoiceCallStatesModule(messageSender, _provider),
    };
  }

  /// Process incoming [message].
  // void _processMessage(String? message) async {
  //   Map<String, dynamic> jsonMsg = json.decode(message ?? '');
  //   if (message == "o") {
  //     _sendConnectMsg();
  //   } else {
  //     try {
  //       if (message!.startsWith("a")) {
  //         message = message.substring(1, message.length);
  //       }

  //       List<dynamic> jsonMsgs = json.decode(message);

  //       jsonMsgs.forEach((jsonMsg) {
  //         jsonMsg = json.decode(jsonMsg);

  //         final String? method = jsonMsg["msg"];
  //         if (method != null) {
  //           if (method == "connected") {
  //             _validateAuthTokenMsgCount++;
  //             _sendValidateAuthTokenMsg();
  //           } else if (method == "result" &&
  //               jsonMsg["id"] != null &&
  //               jsonMsg["id"] == _validateAuthTokenMsgId) {
  //             if (_validateAuthTokenMsgCount == 1) {
  //               _sendMessageWithoutID({
  //                 "msg": "sub",
  //                 "id": MainWebSocketUtil.getRandomAlphanumericWithCaps(17),
  //                 "name": "current-user",
  //                 "params": [],
  //               });
  //               _validateAuthTokenMsgCount++;
  //               _sendValidateAuthTokenMsg();
  //             } else {
  //               _userIsValidated = true;
  //               //now user is validated --> now we can send the subs.
  //               for (MapEntry<String, Module> moduleEntry in _modules.entries) {
  //                 moduleEntry.value.onConnected();
  //               }
  //             }
  //           } else {
  //             // Delegate incoming message to the modules.
  //             for (MapEntry<String, Module> moduleEntry in _modules.entries) {
  //               moduleEntry.value.processMessage(jsonMsg);
  //             }
  //           }
  //         }
  //       });
  //     } on FormatException catch (e) {
  //       Log.info("invalid JSON received on mainWebsocket: $message");
  //     }
  //   }
  // }

  int pingCount = 0;
  void _processMessage2(String? message) async {
    try {
      Map<String, dynamic> jsonMsgs = json.decode(message ?? '');
      switch (jsonMsgs['type']) {
        case GraphQLWSMessageType.CONNECTION_ACK:
          break;
        case GraphQLWSMessageType.PING:
          ++pingCount;
          if (pingCount == 2) {
            getUserCurrent();
            getUserInfo();
          }

          if (_userIsValidated) {
            doCheckRTT();
          }

          break;
        case GraphQLWSMessageType.NEXT:
          if (needComplete.contains(jsonMsgs['id'])) {
            _webSocket.unsubscribe((jsonMsgs['id']));
          } else if (jsonMsgs['id'] == idGetUserCurrent) {
            final userCurrent =
                (jsonMsgs['payload']['data']['user_current'] as List).first;
            _meetingInfo.userId = userCurrent['userId'];
            if (userCurrent['joined'] == false) {
              joinMeeting();
            } else {
              if (!_userIsValidated) {
                _userIsValidated = true;
                _modules.forEach((key, value) => value.onConnected());
                someThings();
                somethings2();
              }
            }
          } else if (_userIsValidated) {
            for (MapEntry<String, Module> moduleEntry in _modules.entries) {
              moduleEntry.value.processMessage(jsonMsgs);
            }
          }
          break;
        case GraphQLWSMessageType.COMPLETE:
          Log.debug('== ${jsonMsgs['id']}');
          break;
        default:
      }
    } on FormatException catch (e) {
      Log.info("invalid JSON received on mainWebsocket: $message");
    }
  }

  String? idGetUserCurrent;
  void getUserCurrent() {
    idGetUserCurrent = _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getUserCurrent",
      "query":
          "subscription getUserCurrent {\n  user_current {\n    userId\n    authToken\n    joinErrorCode\n    joinErrorMessage\n    joined\n    ejectReasonCode\n    loggedOut\n    guestStatus\n    meeting {\n      ended\n      endedReasonCode\n      endedByUserName\n      logoutUrl\n      __typename\n    }\n    guestStatusDetails {\n      guestLobbyMessage\n      positionInWaitingQueue\n      isAllowed\n      __typename\n    }\n    __typename\n  }\n}"
    });
  }

  String? idGetUserInfo;
  void getUserInfo() {
    idGetUserInfo = _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getUserInfo",
      "query":
          "query getUserInfo {\n  meeting {\n    meetingId\n    name\n    logoutUrl\n    bannerColor\n    bannerText\n    customLogoUrl\n    customDarkLogoUrl\n    __typename\n  }\n  user_current {\n    extId\n    name\n    userId\n    __typename\n  }\n}"
    });
  }

  void someThings() {
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "isSharedNotesPinned",
      "query":
          "subscription isSharedNotesPinned {\n  sharedNotes(where: {pinned: {_eq: true}}) {\n    pinned\n    sharedNotesExtId\n    model\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "Patched_MeetingSubscription",
      "query":
          "subscription Patched_MeetingSubscription {\n  meeting {\n    disabledFeatures\n    durationInSeconds\n    extId\n    endWhenNoModerator\n    endWhenNoModeratorDelayInMinutes\n    createdTime\n    loginUrl\n    lockSettings {\n      disableCam\n      disableMic\n      disableNotes\n      disablePrivateChat\n      disablePublicChat\n      hasActiveLockSetting\n      hideUserList\n      hideViewersCursor\n      hideViewersAnnotation\n      webcamsOnlyForModerator\n      lockOnJoin\n      lockOnJoinConfigurable\n      __typename\n    }\n    metadata {\n      name\n      value\n      __typename\n    }\n    maxPinnedCameras\n    meetingCameraCap\n    cameraBridge\n    screenShareBridge\n    audioBridge\n    meetingId\n    name\n    notifyRecordingIsOn\n    presentationUploadExternalDescription\n    presentationUploadExternalUrl\n    recordingPolicies {\n      allowStartStopRecording\n      autoStartRecording\n      record\n      keepEvents\n      __typename\n    }\n    groups {\n      groupId\n      name\n      __typename\n    }\n    learningDashboard {\n      learningDashboardAccessToken\n      __typename\n    }\n    screenshare {\n      contentType\n      hasAudio\n      screenshareConf\n      screenshareId\n      startedAt\n      stoppedAt\n      stream\n      vidHeight\n      vidWidth\n      voiceConf\n      __typename\n    }\n    usersPolicies {\n      allowModsToEjectCameras\n      allowModsToUnmuteUsers\n      authenticatedGuest\n      guestPolicy\n      maxUserConcurrentAccesses\n      maxUsers\n      meetingLayout\n      moderatorsCanMuteAudio\n      moderatorsCanUnmuteAudio\n      userCameraCap\n      webcamsOnlyForModerator\n      guestLobbyMessage\n      __typename\n    }\n    layout {\n      cameraDockAspectRatio\n      cameraDockIsResizing\n      cameraDockPlacement\n      cameraWithFocus\n      currentLayoutType\n      presentationMinimized\n      propagateLayout\n      updatedAt\n      __typename\n    }\n    isBreakout\n    breakoutPolicies {\n      breakoutRooms\n      captureNotes\n      captureNotesFilename\n      captureSlides\n      captureSlidesFilename\n      freeJoin\n      parentId\n      privateChatEnabled\n      record\n      sequence\n      __typename\n    }\n    voiceSettings {\n      dialNumber\n      muteOnStart\n      voiceConf\n      telVoice\n      __typename\n    }\n    externalVideo {\n      externalVideoId\n      playerCurrentTime\n      playerPlaybackRate\n      playerPlaying\n      externalVideoUrl\n      startedSharingAt\n      stoppedSharingAt\n      updatedAt\n      __typename\n    }\n    componentsFlags {\n      hasCaption\n      hasBreakoutRoom\n      hasExternalVideo\n      hasPoll\n      hasScreenshare\n      hasTimer\n      showRemainingTime\n      hasCameraAsContent\n      hasScreenshareAsContent\n      __typename\n    }\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "Patched_userCurrentSubscription",
      "query":
          "subscription Patched_userCurrentSubscription {\n  user_current {\n    authToken\n    avatar\n    webcamBackground\n    away\n    clientType\n    color\n    ejectReason\n    ejectReasonCode\n    ejected\n    reactionEmoji\n    extId\n    guest\n    guestStatus\n    hasDrawPermissionOnCurrentPage\n    inactivityWarningDisplay\n    inactivityWarningTimeoutSecs\n    isDialIn\n    isModerator\n    currentlyInMeeting\n    joinErrorCode\n    joinErrorMessage\n    joined\n    locked\n    loggedOut\n    mobile\n    name\n    nameSortable\n    pinned\n    presenter\n    raiseHand\n    registeredAt\n    role\n    speechLocale\n    captionLocale\n    userId\n    breakoutRooms {\n      hasJoined\n      assignedAt\n      breakoutRoomId\n      isLastAssignedRoom\n      durationInSeconds\n      endedAt\n      freeJoin\n      inviteDismissedAt\n      isDefaultName\n      joinURL\n      name\n      sendInvitationToModerators\n      sequence\n      shortName\n      showInvitation\n      startedAt\n      isUserCurrentlyInRoom\n      __typename\n    }\n    lastBreakoutRoom {\n      currentlyInRoom\n      sequence\n      shortName\n      __typename\n    }\n    cameras {\n      streamId\n      __typename\n    }\n    voice {\n      joined\n      spoke\n      listenOnly\n      __typename\n    }\n    userLockSettings {\n      disablePublicChat\n      __typename\n    }\n    sessionCurrent {\n      enforceLayout\n      __typename\n    }\n    livekit {\n      livekitToken\n      __typename\n    }\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "PluginConfigurationQuery",
      "query":
          "query PluginConfigurationQuery {\n  plugin {\n    name\n    javascriptEntrypointUrl\n    javascriptEntrypointIntegrity\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {"partialUtterances": true, "minUtteranceLength": 1},
      "extensions": {},
      "operationName": "UserSetSpeechOptions",
      "query":
          "mutation UserSetSpeechOptions(\$partialUtterances: Boolean!, \$minUtteranceLength: Float!) {\n  userSetSpeechOptions(\n    partialUtterances: \$partialUtterances\n    minUtteranceLength: \$minUtteranceLength\n  )\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {
        "settings": {
          "application": {
            "wakeLock": true,
            "darkTheme": false,
            "animations": true,
            "pushLayout": false,
            "chatPushAlerts": false,
            "fallbackLocale": "en",
            "overrideLocale": null,
            "selectedLayout": "custom",
            "chatAudioAlerts": false,
            "directLeaveButton": true,
            "paginationEnabled": true,
            "pushToTalkEnabled": false,
            "userJoinPushAlerts": false,
            "raiseHandPushAlerts": true,
            "userJoinAudioAlerts": false,
            "userLeavePushAlerts": false,
            "raiseHandAudioAlerts": true,
            "userLeaveAudioAlerts": false,
            "autoCloseReactionsBar": true,
            "guestWaitingPushAlerts": true,
            "guestWaitingAudioAlerts": true,
            "whiteboardToolbarAutoHide": false,
            "webcamBorderHighlightColor": [],
            "locale": "en",
            "isRTL": false
          },
          "audio": {
            "inputDeviceId": "undefined",
            "outputDeviceId": "undefined"
          },
          "dataSaving": {
            "viewScreenshare": true,
            "viewParticipantsWebcams": true
          },
          "transcription": {"partialUtterances": true, "minUtteranceLength": 1}
        }
      },
      "extensions": {},
      "operationName": "UserChangedLocalSettings",
      "query":
          "mutation UserChangedLocalSettings(\$settings: json!) {\n  userSetClientSettings(userClientSettingsJson: \$settings)\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "unreadChatsSubscription",
      "query":
          "subscription unreadChatsSubscription {\n  chat(where: {totalUnread: {_gt: 0}, visible: {_eq: true}}) {\n    chatId\n    totalUnread\n    participant {\n      name\n      __typename\n    }\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {
        "initialCursor": "2024-04-18",
        "excludedMessageIds": [
          "app.notification.userJoinPushAlert",
          "app.notification.userLeavePushAlert"
        ]
      },
      "extensions": {},
      "operationName": "getNotificationStream",
      "query":
          "subscription getNotificationStream(\$initialCursor: timestamptz!, \$excludedMessageIds: [String!]!) {\n  notification_stream(\n    batch_size: 10\n    cursor: {initial_value: {createdAt: \$initialCursor}}\n    where: {messageId: {_nin: \$excludedMessageIds}}\n  ) {\n    notificationType\n    icon\n    messageId\n    messageValues\n    isSingleUserNotification\n    createdAt\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {"externalId": "notes"},
      "extensions": {},
      "operationName": "GetPadLastRev",
      "query":
          "subscription GetPadLastRev(\$externalId: String!) {\n  sharedNotes(where: {sharedNotesExtId: {_eq: \$externalId}}) {\n    lastRev\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "userIsInvited",
      "query":
          "subscription userIsInvited {\n  breakoutRoom(where: {joinURL: {_is_null: false}}) {\n    sequence\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "UsersWithAudioCount",
      "query":
          "subscription UsersWithAudioCount {\n  user_aggregate(where: {voice: {joined: {_eq: true}}}) {\n    aggregate {\n      count\n      __typename\n    }\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "CurrentPresentationPagesSubscription",
      "query":
          "subscription CurrentPresentationPagesSubscription {\n  pres_page_curr {\n    height\n    isCurrentPage\n    num\n    pageId\n    scaledHeight\n    scaledViewBoxHeight\n    scaledViewBoxWidth\n    scaledWidth\n    svgUrl: urlsJson(path: \"\$.svg\")\n    width\n    xOffset\n    yOffset\n    presentationId\n    content\n    downloadFileUri\n    totalPages\n    downloadable\n    presentationName\n    isDefaultPresentation\n    infiniteWhiteboard\n    nextPagesSvg\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {"lastUpdatedAt": "1970-01-01T00:00:00.000Z"},
      "extensions": {},
      "operationName": "annotationsStream",
      "query":
          "subscription annotationsStream(\$lastUpdatedAt: timestamptz) {\n  pres_annotation_curr_stream(\n    batch_size: 1000\n    cursor: {initial_value: {lastUpdatedAt: \$lastUpdatedAt}}\n  ) {\n    annotationId\n    annotationInfo\n    lastUpdatedAt\n    pageId\n    presentationId\n    userId\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "PollPublished",
      "query":
          "subscription PollPublished {\n  poll {\n    published\n    __typename\n  }\n}"
    });
    needComplete.add(_webSocket.subscribe(payload: {
      "variables": {"locale": "en-US"},
      "extensions": {},
      "operationName": "getCaptions",
      "query":
          "subscription getCaptions(\$locale: String!) {\n  caption(where: {locale: {_eq: \$locale}}) {\n    user {\n      avatar\n      color\n      isModerator\n      name\n      __typename\n    }\n    captionText\n    captionId\n    captionType\n    createdAt\n    __typename\n  }\n}"
    }));

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "PresentationsSubscription",
      "query":
          "subscription PresentationsSubscription {\n  pres_presentation {\n    uploadInProgress\n    current\n    downloadFileUri\n    downloadable\n    uploadErrorDetailsJson\n    uploadErrorMsgKey\n    filenameConverted\n    isDefault\n    name\n    totalPages\n    totalPagesUploaded\n    presentationId\n    removable\n    uploadCompletionNotified\n    uploadCompleted\n    exportToChatInProgress\n    exportToChatStatus\n    exportToChatCurrentPage\n    exportToChatHasError\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "PresentationsSubscription",
      "query":
          "subscription PresentationsSubscription {\n  pres_presentation {\n    uploadInProgress\n    current\n    downloadFileUri\n    downloadable\n    uploadErrorDetailsJson\n    uploadErrorMsgKey\n    filenameConverted\n    isDefault\n    name\n    totalPages\n    totalPagesUploaded\n    presentationId\n    removable\n    uploadCompletionNotified\n    uploadCompleted\n    exportToChatInProgress\n    exportToChatStatus\n    exportToChatCurrentPage\n    exportToChatHasError\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "PresentationsSubscription",
      "query":
          "subscription PresentationsSubscription {\n  pres_presentation {\n    uploadTemporaryId\n    uploadInProgress\n    current\n    downloadFileUri\n    downloadable\n    uploadErrorDetailsJson\n    uploadErrorMsgKey\n    filenameConverted\n    isDefault\n    name\n    totalPages\n    totalPagesUploaded\n    presentationId\n    removable\n    uploadCompleted\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getBreakoutData",
      "query":
          "subscription getBreakoutData {\n  breakoutRoom {\n    freeJoin\n    shortName\n    sendInvitationToModerators\n    sequence\n    showInvitation\n    isLastAssignedRoom\n    isUserCurrentlyInRoom\n    isDefaultName\n    joinURL\n    breakoutRoomId\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getBreakoutCount",
      "query":
          "subscription getBreakoutCount {\n  breakoutRoom_aggregate(where: {showInvitation: {_eq: true}}) {\n    aggregate {\n      count\n      __typename\n    }\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {"createdAt": "2025-03-07T08:30:28.702Z"},
      "extensions": {},
      "operationName": "chatMessages",
      "query":
          "subscription chatMessages(\$createdAt: timestamptz!) {\n  chat_message_public_stream(\n    cursor: {initial_value: {createdAt: \$createdAt}, ordering: ASC}\n    batch_size: 10\n  ) {\n    chatId\n    createdAt\n    message\n    messageId\n    messageMetadata\n    messageType\n    senderName\n    senderRole\n    senderId\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {"createdAt": "2025-03-07T08:30:28.702Z"},
      "extensions": {},
      "operationName": "chatMessages",
      "query":
          "subscription chatMessages(\$createdAt: timestamptz!) {\n  chat_message_private_stream(\n    cursor: {initial_value: {createdAt: \$createdAt}, ordering: ASC}\n    batch_size: 10\n  ) {\n    chatId\n    createdAt\n    message\n    messageId\n    messageMetadata\n    messageType\n    senderName\n    senderRole\n    senderId\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "RaisedHandUsers",
      "query":
          "subscription RaisedHandUsers {\n  user(\n    where: {raiseHand: {_eq: true}}\n    order_by: [{raiseHandTime: asc_nulls_last}]\n  ) {\n    userId\n    name\n    color\n    presenter\n    isModerator\n    raiseHand\n    raiseHandTime\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "ViewerVideoStreams",
      "query":
          "subscription ViewerVideoStreams {\n  user_camera_aggregate(\n    where: {user: {role: {_eq: \"VIEWER\"}, presenter: {_eq: false}}}\n  ) {\n    aggregate {\n      count\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {"initialCursor": "Fri, 07 Mar 2025 08:30:28 GMT"},
      "extensions": {},
      "operationName": "getEmojisToRain",
      "query":
          "subscription getEmojisToRain(\$initialCursor: timestamptz) {\n  user_reaction_stream(\n    batch_size: 10\n    cursor: {initial_value: {createdAt: \$initialCursor}}\n  ) {\n    createdAt\n    reactionEmoji\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getServerTime",
      "query":
          "query getServerTime {\n  current_time {\n    currentTimestamp\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {
        "settings": {
          "application": {
            "wakeLock": true,
            "darkTheme": false,
            "animations": true,
            "pushLayout": false,
            "chatPushAlerts": false,
            "fallbackLocale": "en",
            "overrideLocale": null,
            "chatAudioAlerts": false,
            "directLeaveButton": true,
            "paginationEnabled": true,
            "pushToTalkEnabled": false,
            "userJoinPushAlerts": false,
            "raiseHandPushAlerts": true,
            "userJoinAudioAlerts": false,
            "userLeavePushAlerts": false,
            "raiseHandAudioAlerts": true,
            "userLeaveAudioAlerts": false,
            "autoCloseReactionsBar": true,
            "guestWaitingPushAlerts": true,
            "guestWaitingAudioAlerts": true,
            "whiteboardToolbarAutoHide": false,
            "webcamBorderHighlightColor": [],
            "locale": "en",
            "isRTL": false
          },
          "audio": {
            "inputDeviceId": "undefined",
            "outputDeviceId": "undefined"
          },
          "dataSaving": {
            "viewScreenshare": true,
            "viewParticipantsWebcams": true
          },
          "transcription": {"partialUtterances": true, "minUtteranceLength": 1}
        }
      },
      "extensions": {},
      "operationName": "UserChangedLocalSettings",
      "query":
          "mutation UserChangedLocalSettings(\$settings: json!) {\n  userSetClientSettings(userClientSettingsJson: \$settings)\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "ChatSubscription",
      "query":
          "subscription ChatSubscription {\n  chat(\n    order_by: [{public: desc}, {totalUnread: desc}, {participant: {name: asc, userId: asc}}]\n  ) {\n    chatId\n    participant {\n      userId\n      name\n      role\n      color\n      loggedOut\n      avatar\n      currentlyInMeeting\n      isModerator\n      __typename\n    }\n    totalMessages\n    totalUnread\n    public\n    lastSeenAt\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "Patched_Screenshare",
      "query":
          "subscription Patched_Screenshare {\n  screenshare {\n    contentType\n    hasAudio\n    screenshareConf\n    screenshareId\n    startedAt\n    stoppedAt\n    stream\n    vidHeight\n    vidWidth\n    voiceConf\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "BreakoutCount",
      "query":
          "subscription BreakoutCount {\n  breakoutRoom_aggregate {\n    aggregate {\n      count\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "UserVoiceActivity",
      "query":
          "subscription UserVoiceActivity {\n  user_voice_activity_stream(\n    cursor: {initial_value: {voiceActivityAt: \"2020-01-01\"}}\n    batch_size: 10\n  ) {\n    muted\n    startTime\n    endTime\n    talking\n    userId\n    user {\n      color\n      name\n      speechLocale\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {"userId": "w_q6zukikquvf4"},
      "extensions": {},
      "operationName": "hasPendingPoll",
      "query":
          "subscription hasPendingPoll(\$userId: String!) {\n  meeting {\n    polls(\n      where: {ended: {_eq: false}, users: {responded: {_eq: false}, userId: {_eq: \$userId}}, userCurrent: {responded: {_eq: false}}}\n    ) {\n      users {\n        responded\n        userId\n        __typename\n      }\n      options {\n        optionDesc\n        optionId\n        pollId\n        __typename\n      }\n      multipleResponses\n      pollId\n      questionText\n      secret\n      type\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {
        "settings": {
          "application": {
            "wakeLock": true,
            "darkTheme": false,
            "animations": true,
            "pushLayout": false,
            "chatPushAlerts": false,
            "fallbackLocale": "en",
            "overrideLocale": null,
            "selectedLayout": "custom",
            "chatAudioAlerts": false,
            "directLeaveButton": true,
            "paginationEnabled": true,
            "pushToTalkEnabled": false,
            "userJoinPushAlerts": false,
            "raiseHandPushAlerts": true,
            "userJoinAudioAlerts": false,
            "userLeavePushAlerts": false,
            "raiseHandAudioAlerts": true,
            "userLeaveAudioAlerts": false,
            "autoCloseReactionsBar": true,
            "guestWaitingPushAlerts": true,
            "guestWaitingAudioAlerts": true,
            "whiteboardToolbarAutoHide": false,
            "webcamBorderHighlightColor": [],
            "locale": "en",
            "isRTL": false
          },
          "audio": {
            "inputDeviceId": "undefined",
            "outputDeviceId": "undefined"
          },
          "dataSaving": {
            "viewScreenshare": true,
            "viewParticipantsWebcams": true
          },
          "transcription": {"partialUtterances": true, "minUtteranceLength": 1}
        }
      },
      "extensions": {},
      "operationName": "UserChangedLocalSettings",
      "query":
          "mutation UserChangedLocalSettings(\$settings: json!) {\n  userSetClientSettings(userClientSettingsJson: \$settings)\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getIsUserCurrentlyInBreakoutRoom",
      "query":
          "subscription getIsUserCurrentlyInBreakoutRoom {\n  breakoutRoom_aggregate(where: {isUserCurrentlyInRoom: {_eq: true}}) {\n    aggregate {\n      count\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {
        "settings": {
          "application": {
            "wakeLock": true,
            "darkTheme": false,
            "animations": true,
            "pushLayout": false,
            "chatPushAlerts": false,
            "fallbackLocale": "en",
            "overrideLocale": null,
            "selectedLayout": "custom",
            "chatAudioAlerts": false,
            "directLeaveButton": true,
            "paginationEnabled": true,
            "pushToTalkEnabled": false,
            "userJoinPushAlerts": false,
            "raiseHandPushAlerts": true,
            "userJoinAudioAlerts": false,
            "userLeavePushAlerts": false,
            "raiseHandAudioAlerts": true,
            "userLeaveAudioAlerts": false,
            "autoCloseReactionsBar": true,
            "guestWaitingPushAlerts": true,
            "guestWaitingAudioAlerts": true,
            "whiteboardToolbarAutoHide": false,
            "webcamBorderHighlightColor": [],
            "locale": "en",
            "isRTL": false
          },
          "audio": {
            "inputDeviceId": "undefined",
            "outputDeviceId": "undefined"
          },
          "dataSaving": {
            "viewScreenshare": true,
            "viewParticipantsWebcams": true
          },
          "transcription": {"partialUtterances": true, "minUtteranceLength": 1}
        }
      },
      "extensions": {},
      "operationName": "UserChangedLocalSettings",
      "query":
          "mutation UserChangedLocalSettings(\$settings: json!) {\n  userSetClientSettings(userClientSettingsJson: \$settings)\n}"
    });
  }

  void somethings2() {
    needComplete.add(_webSocket.subscribe(payload: {
      "variables": {"chatId": "MAIN-PUBLIC-GROUP-CHAT"},
      "extensions": {},
      "operationName": "IsTyping",
      "query":
          "subscription IsTyping(\$chatId: String!) {\n  user_typing_public(\n    order_by: {startedTypingAt: asc}\n    limit: 4\n    where: {isCurrentlyTyping: {_eq: true}, chatId: {_eq: \$chatId}}\n  ) {\n    chatId\n    userId\n    isCurrentlyTyping\n    user {\n      name\n      __typename\n    }\n    __typename\n  }\n}"
    }));

    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getMeetingRecordingPolicies",
      "query":
          "subscription getMeetingRecordingPolicies {\n  meeting_recordingPolicies {\n    allowStartStopRecording\n    autoStartRecording\n    record\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getMeetingRecordingData",
      "query":
          "subscription getMeetingRecordingData {\n  meeting_recording {\n    isRecording\n    startedAt\n    startedBy\n    previousRecordedTimeInSeconds\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getIsBreakout",
      "query":
          "subscription getIsBreakout {\n  meeting {\n    meetingId\n    isBreakout\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "CursorSubscription",
      "query":
          "subscription CursorSubscription {\n  pres_page_cursor(where: {isCurrentPage: {_eq: true}}, order_by: {userId: asc}) {\n    userId\n    user {\n      name\n      presenter\n      role\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "getCursorCoordinatesStream",
      "query":
          "subscription getCursorCoordinatesStream {\n  pres_page_cursor_stream(\n    cursor: {initial_value: {lastUpdatedAt: \"2020-01-01\"}}\n    where: {isCurrentPage: {_eq: true}}\n    batch_size: 100\n  ) {\n    xPercent\n    yPercent\n    lastUpdatedAt\n    userId\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "ProcessedPresentationsSubscription",
      "query":
          "subscription ProcessedPresentationsSubscription {\n  pres_presentation(where: {uploadCompleted: {_eq: true}}) {\n    current\n    name\n    presentationId\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "activeCaptions",
      "query":
          "subscription activeCaptions {\n  caption_activeLocales {\n    locale\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {"chatId": "MAIN-PUBLIC-GROUP-CHAT"},
      "extensions": {},
      "operationName": "GetChatData",
      "query":
          "query GetChatData(\$chatId: String!) {\n  chat(where: {chatId: {_eq: \$chatId}}) {\n    chatId\n    public\n    participant {\n      name\n      __typename\n    }\n    __typename\n  }\n}"
    });
    _webSocket.subscribe(payload: {
      "variables": {},
      "extensions": {},
      "operationName": "Patched_Timer",
      "query":
          "subscription Patched_Timer {\n  timer {\n    accumulated\n    active\n    songTrack\n    time\n    stopwatch\n    running\n    startedOn\n    startedAt\n    elapsed\n    __typename\n  }\n}"
    });

    _webSocket.subscribe(payload: {
      "variables": {"createdAt": "2025-03-07T09:17:51.052Z"},
      "extensions": {},
      "operationName": "chatMessages",
      "query":
          "subscription chatMessages(\$createdAt: timestamptz!) {\n  chat_message_public_stream(\n    cursor: {initial_value: {createdAt: \$createdAt}, ordering: ASC}\n    batch_size: 10\n  ) {\n    chatId\n    createdAt\n    message\n    messageId\n    messageMetadata\n    messageType\n    senderName\n    senderRole\n    senderId\n    __typename\n  }\n}"
    });

    // setupVideoConnect();
  }

  String? joinId;
  void joinMeeting() {
    joinId = _webSocket.subscribe(id: joinId, payload: {
      "variables": {
        "authToken": _meetingInfo.authToken,
        "clientType": "Android",
        "clientIsMobile": true
      },
      "extensions": {},
      "operationName": "UserJoin",
      "query":
          "mutation UserJoin(\$authToken: String!, \$clientType: String!, \$clientIsMobile: Boolean!) {\n  userJoinMeeting(\n    authToken: \$authToken\n    clientType: \$clientType\n    clientIsMobile: \$clientIsMobile\n  )\n}"
    });
  }

  void setupVideoConnect() {
    final uri = Uri.parse(
        'wss://$baseURL/bbb-webrtc-sfu?sessionToken=${_meetingInfo.sessionToken}');
    _mediaSocket = GraphQLWebSocket(
      uri.toString(),
      cookie: _meetingInfo.cookie,
      needInit: false,
    );
    Log.info("Connecting to main webrtc at '${uri.toString()}'");
    _mediaSocket!.onOpen = () {
      Log.info("Open connection ==webrtc");
      _mediaSocket?.sendMessage({'id': 'ping'});
    };
    _mediaSocket!.onMessage = (message) {
      Log.verbose("[MainWebsocket ==webrtc] (Received data) | '$message'");
    };

    _mediaSocket!.onClose = (int? code, String? reason) async {
      Log.info(
          "==webrtc Main websocket connection closed. Reason: '$reason', code: $code");
    };

    // _webSocket.connect();
    _mediaSocket!.connectWebSocket();
    videoModule?.mediaSocket = _mediaSocket;
  }

  Future<void> doCheckRTT() async {
    try {
      final uri = Uri.parse('https://$baseURL/bigbluebutton/rtt-check');

      final stopwatch = Stopwatch()..start(); // Start measuring time
      final response = await get(uri,
          headers: {'Cookie': _meetingInfo.cookie ?? ''}); // Create GET request
      stopwatch.stop(); // Stop measuring time

      if (response.statusCode == 200) {
        print('RTT: ${stopwatch.elapsedMilliseconds} ms');
        _webSocket.subscribe(payload: {
          "variables": {"networkRttInMs": stopwatch.elapsedMilliseconds},
          "extensions": {},
          "operationName": "UpdateConnectionAliveAt",
          "query":
              "mutation UpdateConnectionAliveAt(\$networkRttInMs: Float!) {\n  userSetConnectionAlive(networkRttInMs: \$networkRttInMs)\n}"
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Get the chat module of the websocket.
  ChatModule? get chatModule => _modules["chat"] as ChatModule?;

  /// Get the video module of the websocket.
  VideoModule? get videoModule => _modules["video"] as VideoModule?;

  /// Get the user module of the websocket.
  UserModule? get userModule => _modules["user"] as UserModule?;

  /// Get the presentation module of the websocket.
  PresentationModule? get presentationModule =>
      _modules["presentation"] as PresentationModule?;

  /// Get the poll module of the websocket.
  PollModule? get pollModule => _modules["poll"] as PollModule?;

  /// Get the meeting module of the websocket.
  MeetingModule? get meetingModule => _modules["meeting"] as MeetingModule?;

  CallModule? get callModule => _modules["call"] as CallModule?;
}
