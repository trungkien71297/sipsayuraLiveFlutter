import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../profile_screen/controller/profile_controller.dart';
import '../../schedule_screen/controller/schedule_controller.dart';
import '/core/app_export.dart';
import 'package:bbb_app/presentation/join_screen/models/join_meeting_model.dart';

class JoinMeetingController extends GetxController {
  Rx<JoinMeetingModel> joinMeetingModelObj = JoinMeetingModel().obs;

  // var sharingText;
  //  String meetingLink ='http://localhost:4000/join/u';
  //
  // userName() {
  //   final controller = Get.put(ProfileController());
  //   var userName= controller.profileModel.value.firstName;
  //
  //   return userName;
  // }

  getMeetingId() {
    final controller = Get.put(ScheduleController());
    var meeting_id =
        controller.futureMeetings[controller.clickedIndex]["meeting_id"];
    // if (controller.isUpcomingMeetingListClicked) {
    //   meeting_id =
    //       controller.futureMeetings[controller.clickedIndex]["meeting_id"];
    // } else {
    //   meeting_id =
    //       controller.pastMeetings[controller.clickedIndex]["meeting_id"];
    // }

    return meeting_id;
  }

  var data = [];
  var apiResponse;

  var joinMeetingResponse;
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  var isLoading2 = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getJsonData();
  }

  // sharingText =${userName()} +"is inviting you to a scheduled LetMO meeting.\nTopic: Sritharan's LetMO Meeting\nTime: Jul 22, 2022 12:00 PM Colombo\nJoin LetMO Meeting\n${meetingLink}\nMeeting ID: ${meetingID}\nPasscode: ${meetingPasscode}";

  void getJsonData() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String token = prefs.getString("Token")!;
    try {
      Uri url =
          Uri.parse("http://192.168.8.205:4000/join/info/${getMeetingId()}");
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
      switch (response.statusCode) {
        case 200:
          print(response.body);
          // var convertDataToJson = jsonDecode(response.body);
          apiResponse = jsonDecode(response.body);
          // data = convertDataToJson;
          // print(response.body);
          isLoading.value = false;
          update();
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
          Get.toNamed(AppRoutes.scheduleScreen);
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
    } on OSError catch (err) {
      print(err);
    } on TimeoutException catch (err) {
      Fluttertoast.showToast(
          msg: "Request Timeout.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading.value = false;
      print(err);
    } on SocketException catch (err) {
      print(err);
      Fluttertoast.showToast(
          msg: "Error: Socket Exception.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading.value = false;
    } on HttpException {
      print("Couldn't find the related data");
    } on FormatException {
      print("Bad response format");
    } catch (err) {
// if (err.toString().contains('SocketException')) {
//   Fluttertoast.showToast(
//       msg: "Error: Socket Exception.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// } else if (err.toString().contains('TimeoutException')) {
//   Fluttertoast.showToast(
//       msg: "Error: Connection Time out.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
      Fluttertoast.showToast(
          msg: "Error: Something went wrong.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(err.toString());
      isLoading.value = false;
      update();
    }
    print("done");
    //isLoading1.value= false;
    update();
  }

  void joinMeeting() async {
    isLoading1.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String token = prefs.getString("Token")!;
    try {
      Uri url = Uri.parse("http://192.168.8.205:4000/join/${getMeetingId()}");
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

      switch (response.statusCode) {
        case 200:
          print(response.body);
          // var convertDataToJson = jsonDecode(response.body);
          joinMeetingResponse = jsonDecode(response.body);
          // data = convertDataToJson;
          // print(response.body);
          isLoading1.value = false;
          update();
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
          isLoading1.value = false;
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
          isLoading1.value = false;

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
          isLoading1.value = false;
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
          isLoading1.value = false;
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
          isLoading1.value = false;

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
          isLoading1.value = false;
          break;
      }
    } on OSError catch (err) {
      print(err);
    } on TimeoutException catch (err) {
      Fluttertoast.showToast(
          msg: "Request Timeout.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading1.value = false;
      print(err);
    } on SocketException catch (err) {
      print(err);
      Fluttertoast.showToast(
          msg: "Error: Socket Exception.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading1.value = false;
    } on HttpException {
      print("Couldn't find the related data");
    } on FormatException {
      print("Bad response format");
    } catch (err) {
// if (err.toString().contains('SocketException')) {
//   Fluttertoast.showToast(
//       msg: "Error: Socket Exception.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// } else if (err.toString().contains('TimeoutException')) {
//   Fluttertoast.showToast(
//       msg: "Error: Connection Time out.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
      Fluttertoast.showToast(
          msg: "Error: Something went wrong.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(err.toString());
      isLoading1.value = false;
      update();
    }
    print("done");
    //isLoading1.value= false;
    update();
  }

  void deleteMeeting() async {
    isLoading2.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String token = prefs.getString("Token")!;
    try {
      Uri url = Uri.parse(
          "http://192.168.8.205:4000/meetings/deleteMeeting/${getMeetingId()}");
      final response = await http
          .delete(
            url,
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Methods": "GET, HEAD",
              "Access-Control-Allow-Credentials": "true",
              "authorization": "Bearer ${token}",
            },
          )
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
      switch (response.statusCode) {
        case 200:
          print(response.body);
          // var convertDataToJson = jsonDecode(response.body);
          joinMeetingResponse = jsonDecode(response.body);
          Fluttertoast.showToast(
              msg: "Meeting Deleted Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.lightBlueAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          // data = convertDataToJson;
          // print(response.body);
          isLoading2.value = false;
          update();
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
          isLoading2.value = false;
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
          isLoading2.value = false;

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
          isLoading2.value = false;
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
          isLoading2.value = false;
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
          isLoading2.value = false;

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
          isLoading2.value = false;
          break;
      }
    } on OSError catch (err) {
      print(err);
    } on TimeoutException catch (err) {
      Fluttertoast.showToast(
          msg: "Request Timeout.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading2.value = false;
      print(err);
    } on SocketException catch (err) {
      print(err);
      Fluttertoast.showToast(
          msg: "Error: Socket Exception.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading2.value = false;
    } on HttpException {
      print("Couldn't find the related data");
    } on FormatException {
      print("Bad response format");
    } catch (err) {
// if (err.toString().contains('SocketException')) {
//   Fluttertoast.showToast(
//       msg: "Error: Socket Exception.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// } else if (err.toString().contains('TimeoutException')) {
//   Fluttertoast.showToast(
//       msg: "Error: Connection Time out.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
      Fluttertoast.showToast(
          msg: "Error: Something went wrong.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(err.toString());
      isLoading2.value = false;
      update();
    }
    print("done");
    isLoading2.value = false;
    update();
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
