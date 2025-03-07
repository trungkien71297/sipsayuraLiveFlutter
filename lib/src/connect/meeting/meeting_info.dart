/// Info needed to join a meeting.
class MeetingInfo {
  /// URL of the meeting.
  String? meetingUrl;

  /// URL used to join the meeting.
  String? joinUrl;

  /// Token of the current session.
  String? sessionToken;

  /// Cookie used to authenticate with the BBB server.
  String? cookie;

  /// Name of the conference.
  String? conferenceName;

  /// The full user name.
  String? fullUserName;

  /// ID of the meeting.
  String? meetingID;

  /// Extern meeting ID.
  String? externMeetingID;

  /// Extern user ID.
  String? externUserID;

  /// Internal user ID.
  String? internalUserID;

  /// Authentication token.
  String? authToken;

  /// Role of the user.
  String? role;

  /// ID of the conference.
  String? conference;

  /// ID of the room.
  String? room;

  /// Voice bridge to use.
  String? voiceBridge;

  /// Number used to dial into the conference.
  String? dialNumber;

  /// Web voice conference.
  String? webVoiceConf;

  /// URL to logout the user.
  String? logoutUrl;

  /// Whether the room is a breakout room.
  bool? isBreakout;

  /// Whether to mute the user on start.
  bool? muteOnStart;

  /// STUN / TURN servers.
  Map<String, dynamic>? iceServers;

  MeetingInfo({
    this.meetingUrl = '',
    this.joinUrl = '',
    this.sessionToken = '',
    this.cookie = '',
    this.conferenceName = '',
    this.fullUserName = '',
    this.meetingID = '',
    this.externMeetingID = '',
    this.externUserID = '',
    this.internalUserID = '',
    this.authToken = '',
    this.role = '',
    this.conference = '',
    this.room = '',
    this.voiceBridge = '',
    this.dialNumber = '',
    this.webVoiceConf = '',
    this.logoutUrl = '',
    this.isBreakout = false,
    this.muteOnStart = true,
    this.iceServers,
  });
}
