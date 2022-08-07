class MeetingModel {
  MeetingModel({
    required this.name,
    required this.meetingId,
    required this.attendeePw,
    required this.moderatorPw,
    required this.maxParticipants,
    required this.duration,
    required this.record,
    required this.autoStartRecording,
    required this.lockSettingsDisablePublicChat,
    required this.muteOnStart,
    required this.allowModsToEjectCameras,
  });

  String name;
  String meetingId;
  String attendeePw;
  String moderatorPw;
  int maxParticipants;
  int duration;
  bool record;
  bool autoStartRecording;
  bool lockSettingsDisablePublicChat;
  bool muteOnStart;
  bool allowModsToEjectCameras;

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
        name: json["name"],
        meetingId: json["meetingId"],
        attendeePw: json["attendeePw"],
        moderatorPw: json["moderatorPw"],
        maxParticipants: json["maxParticipants"],
        duration: json["duration"],
        record: json["record"],
        autoStartRecording: json["autoStartRecording"],
        lockSettingsDisablePublicChat: json["lockSettingsDisablePublicChat"],
        muteOnStart: json["muteOnStart"],
        allowModsToEjectCameras: json["allowModsToEjectCameras"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "meetingId": meetingId,
        "attendeePw": attendeePw,
        "moderatorPw": moderatorPw,
        "maxParticipants": maxParticipants,
        "duration": duration,
        "record": record,
        "autoStartRecording": autoStartRecording,
        "lockSettingsDisablePublicChat": lockSettingsDisablePublicChat,
        "muteOnStart": muteOnStart,
        "allowModsToEjectCameras": allowModsToEjectCameras,
      };
}
