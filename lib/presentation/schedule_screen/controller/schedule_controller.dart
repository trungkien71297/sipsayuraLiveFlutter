import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../exceptions_handlers.dart';
import '../models/schedule_item_model.dart';
import '/core/app_export.dart';
import 'package:bbb_app/presentation/schedule_screen/models/schedule_model.dart';

class ScheduleController extends GetxController with StateMixin<dynamic> {
  Rx<ScheduleModel> scheduleModelObj = ScheduleModel().obs;

  ConnectivityResult result = ConnectivityResult.none;

  var isInternetOn = false.obs;
  late bool isUpcomingMeetingListClicked;

  var clickedIndex = 0;

  void isUpcomingListClicked(int? value) {
    isUpcomingMeetingListClicked = true;
    clickedIndex = value!;
    print(clickedIndex);
    update();
  }

  void isPastListClicked(int? value) {
    isUpcomingMeetingListClicked = false;
    clickedIndex = value!;
    print(clickedIndex);
    update();
  }

  var meetings = <ScheduleItemModel>[].obs;
  var data = [];
  var pastMeetings = [];
  var futureMeetings = [];
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getJsonData();
  }

  void getJsonData() async {
    result = await Connectivity().checkConnectivity();
    isLoading.value = true;
    if (result == ConnectivityResult.none) {
      isInternetOn.value = false;
    } else {
      isInternetOn.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      late String token = prefs.getString("Token")!;
      try {
        Uri url =
            Uri.parse("http://192.168.8.205:4000/meetings/getMeetingByUserID");
        final response = await http
            .post(url, headers: {
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Methods": "GET, HEAD",
              "Access-Control-Allow-Credentials": "true",
              "authorization": "Bearer ${token}",
            }, body: {})
            .timeout(
              Duration(seconds: 10),
              onTimeout: () => http.Response(
                '[{"statusCode":"408"}]',
                408,
              ),
              // throw TimeoutException('Connectiion time out.');
              // throw ExceptionHandlers().getExceptionString(e);
            )
            .catchError((onError) {
              print(onError);
            });
        var convertDataToJson = jsonDecode(response.body) as List;
        data = convertDataToJson;
        switch (response.statusCode) {
          case 200:
            futureMeetings = [];
            pastMeetings = [];
            for (var index = 0; index < data.length; index++) {
              if (new DateTime.now().isAfter(DateFormat("yyyy-MM-dd hh:mm").parse(
                  '${data[index]["scheduled_at_Date"].toString()} ${data[index]["end_Time"].toString()} '))) {
                if (!(pastMeetings.contains(data[index]["meeting_id"]))) {
                  pastMeetings.add(data[index]);
                }
              } else {
                if (!(futureMeetings.contains(data[index]["meeting_id"]))) {
                  futureMeetings.add(data[index]);
                }
              }
            }
            break;
          case 500:
            Fluttertoast.showToast(
                msg: "Internal Server Error.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isLoading.value = false;
            break;
          case 503:
            Fluttertoast.showToast(
                msg: "Service Unavailable.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isLoading.value = false;

            break;
          case 400:
            Fluttertoast.showToast(
                msg: "Email or Password is Incorrect!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isLoading.value = false;
            break;
          case 404:
            Fluttertoast.showToast(
                msg: "The server can not find the requested resource.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isLoading.value = false;
            break;
          case 408:
            Fluttertoast.showToast(
                msg: "Request Timeout.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isLoading.value = false;

            break;
          default:
            Fluttertoast.showToast(
                msg: "Something went wrong",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            isLoading.value = false;
            break;
        }

        isLoading.value = false;
        update();
      }
      // on OSError catch (err) {
      //   print(err);
      // } on TimeoutException catch (err) {
      //   Fluttertoast.showToast(
      //       msg: "Request Timeout.",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.red,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      //   isLoading.value = false;
      //   print(err);
      // }
      // on SocketException catch (err) {
      //   print(err);
      //   Fluttertoast.showToast(
      //       msg: "Error: Socket Exception.",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.red,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      //   isLoading.value = false;
      // } on HttpException {
      //   print("Couldn't find the related data");
      // } on FormatException {
      //   print("Bad response format");
      // }
      catch (err) {
        if (err.toString().contains('SocketException')) {
          Fluttertoast.showToast(
              msg: "Error: Socket Exception.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (err.toString().contains('TimeoutException')) {
          Fluttertoast.showToast(
              msg: "Error: Connection Time out.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        print(err.toString());
        isLoading.value = false;
        update();
      }
      print("done");
      pastMeetings.sort((a, b) => DateFormat("yyyy-MM-dd hh:mm")
          .parse(
              '${b["scheduled_at_Date"].toString()} ${b["end_Time"].toString()} ')
          .compareTo(DateFormat("yyyy-MM-dd hh:mm").parse(
              '${a["scheduled_at_Date"].toString()} ${a["end_Time"].toString()} ')));

      futureMeetings.sort((a, b) => DateFormat("yyyy-MM-dd hh:mm")
          .parse(
              '${a["scheduled_at_Date"].toString()} ${a["end_Time"].toString()} ')
          .compareTo(DateFormat("yyyy-MM-dd hh:mm").parse(
              '${b["scheduled_at_Date"].toString()} ${b["end_Time"].toString()} ')));
      isLoading.value = false;
      update();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
