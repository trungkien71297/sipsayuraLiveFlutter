import '../controller/schedule_controller.dart';
import '../models/schedule_item_model.dart';
import 'package:flutter/material.dart';
import 'package:bbb_app/core/app_export.dart';

// ignore: must_be_immutable
class ScheduleItemWidget extends StatelessWidget {
  final String meetingName;
  final String meetingID;
  final String duration;
  final String time;
  final String date;

  // ScheduleItemWidget(this.scheduleItemModelObj);
  //
  // ScheduleItemModel scheduleItemModelObj;

  var controller = Get.find<ScheduleController>();

  ScheduleItemWidget(
      {Key? key,
      required this.meetingName,
      required this.meetingID,
      required this.duration,
      required this.time,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 5 / 6,
        margin: EdgeInsets.only(
          top: getVerticalSize(
            10.00,
          ),
          right: getHorizontalSize(
            2.00,
          ),
          bottom: getVerticalSize(
            10.00,
          ),
        ),
        decoration: BoxDecoration(
          color: ColorConstant.whiteA700,
          borderRadius: BorderRadius.circular(
            getHorizontalSize(
              6.00,
            ),
          ),
        ),
        child: Card(
          child: ListTile(
            // contentPadding: EdgeInsets.symmetric(horizontal: 50.0),
            leading: Text(time + '\n' + date),
            title: Text(meetingName),
            subtitle: Text('Meeting ID: ' + meetingID),
            trailing: ElevatedButton(
              onPressed: () => {onTapBtnjoin()},
              child: const Text(
                'Start',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent, shape: StadiumBorder()),
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  onTapBtnjoin() {
    Get.toNamed(AppRoutes.joinMeetingScreen);
  }
}
