import 'package:get/get.dart';
import 'schedule_item_model.dart';

class ScheduleModel {
  RxList<ScheduleItemModel> scheduleItemList =
      RxList.filled(3, ScheduleItemModel(serverResponce));

  static List<Map<String, Object>> get serverResponce => [
    {
      "meetingName": "Test Meeting 01",
      "meetingID": "Test001",
      "duration": "00:30:00",
      "createDatetime": "2022-06-21T02:30:00.000Z",
      "recording": 10,
      "startDatetime": "2022-06-21T04:30:00.000Z",
      "userId": "user001",
      "attendeePW": "efbert55df",
      "moderatorPW": "5e4wevw65v",
      "internalMeetingId": "wervbwej565lkwenrvj"
    },
    {
      "meetingName": "Test Meeting 02",
      "meetingID": "Test002",
      "duration": "01:30:00",
      "createDatetime": "2022-08-21T03:30:00.000Z",
      "recording": 127,
      "startDatetime": "2022-08-22T05:30:00.000Z",
      "userId": "user001",
      "attendeePW": "efbe4t55df",
      "moderatorPW": "5e4wekw65v",
      "internalMeetingId": "wervbwej565nkwenrvj"
    },
    {
      "meetingName": "Test Meeting03",
      "meetingID": "Test003",
      "duration": "02:00:00",
      "createDatetime": "2022-06-23T02:50:00.000Z",
      "recording": 50,
      "startDatetime": "2022-06-22T17:30:09.000Z",
      "userId": "user002",
      "attendeePW": "cewvqwv564q",
      "moderatorPW": "q45cq51qcrcw",
      "internalMeetingId": "15qwvc12qkhc"
    }
  ];
}
