import 'package:awesome_dialog/awesome_dialog.dart';

import '../../join_screen/controller/join_meeting_controller.dart';
import '../controller/schedule_controller.dart';
import '../models/schedule_item_model.dart';
import 'package:flutter/material.dart';
import 'package:bbb_app/core/app_export.dart';

// ignore: must_be_immutable
class SchedulePastItemWidget extends StatelessWidget {
  ConnectivityResult result = ConnectivityResult.none;
  final String meetingName;
  final String meetingID;
  final String duration;
  final String time;
  final String date;

  // ScheduleItemWidget(this.scheduleItemModelObj);
  //
  // ScheduleItemModel scheduleItemModelObj;

  var controller = Get.find<ScheduleController>();

  SchedulePastItemWidget(
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
              onPressed: () => {onTapBtnDelete(context)},
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red, shape: StadiumBorder()),
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  onTapBtnDelete(context) async {
    result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        showCloseIcon: false,
        title: "Oops!",
        desc: 'No Internet Connection found Check your connection',
        btnOkOnPress: () {
          // Navigator.pop(context);
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        },
      ).show();
    } else {
      final controller = Get.put(JoinMeetingController());
      AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Delete Meeting?',
              desc: 'Are you really wanted to delete the meeting?',
              dismissOnBackKeyPress: false,
              useRootNavigator: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                // controller.deleteMeeting();
              },
              btnOkColor: Colors.lightBlueAccent,
              btnOkText: "Yes",
              btnCancelText: "No")
          .show();
    }
  }
}
