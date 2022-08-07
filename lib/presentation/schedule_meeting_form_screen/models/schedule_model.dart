import 'package:get/get.dart';
import 'schedule_meeting_bind.dart';

class ScheduleModel {
  RxList<ScheduleMeetingBind> scheduleItemList =
      RxList.filled(3, ScheduleMeetingBind(serverResponce));

  static List<Map<String, Object>> get serverResponce => [
        {
          'name': 'abc',
          'meetingId': '123',
          'attendeePw': '123',
          'moderatorPw': '123',
          'maxParticipants': 50,
          'duration': 30,
          'record': true,
          'autoStartRecording': true,
          'lockSettingsDisablePublicChat': true,
          'muteOnStart': true,
          'allowModsToEjectCameras': true
        },
        {
          'name': 'abcd',
          'meetingId': '1234',
          'attendeePw': '1234',
          'moderatorPw': '1234',
          'maxParticipants': 50,
          'duration': 60,
          'record': true,
          'autoStartRecording': true,
          'lockSettingsDisablePublicChat': true,
          'muteOnStart': true,
          'allowModsToEjectCameras': true
        },
        {
          'name': 'abcde',
          'meetingId': '12345',
          'attendeePw': '12345',
          'moderatorPw': '12345',
          'maxParticipants': 45,
          'duration': 50,
          'record': true,
          'autoStartRecording': true,
          'lockSettingsDisablePublicChat': true,
          'muteOnStart': true,
          'allowModsToEjectCameras': true
        },
        {
          'name': 'abcdef',
          'meetingId': '123456',
          'attendeePw': '123456',
          'moderatorPw': '123456',
          'maxParticipants': 45,
          'duration': 50,
          'record': true,
          'autoStartRecording': true,
          'lockSettingsDisablePublicChat': true,
          'muteOnStart': true,
          'allowModsToEjectCameras': true
        }
      ];
}
