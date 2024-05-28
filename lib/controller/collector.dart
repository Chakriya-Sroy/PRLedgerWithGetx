import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/model/collector.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CollectorController extends GetxController {
  TextEditingController search = TextEditingController();
  RxString searchTerm = RxString('');
  RxList<CollectorModel> userList = RxList();
  RxString message = RxString('');
  RxString errorMessage = RxString('');
  RxBool isLoading = false.obs;
  //RxString receiver_id = RxString('');
  RxString respondStatus = RxString('');
  RxString requestStatus = RxString('');
  RxBool isSuccess =false.obs;

 
  Map<String,dynamic> requestSenderBody(String receiverId) {
    return {'receiver_id': receiverId};
  }

  Map<String, String> requestRespondBody(String status,String senderId) {
    return {
      'status': status,
      'sender_id':senderId
    };
  }

  Future<void> fetchUser() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl + ApiEndPoints.userEndPoints.userList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = jsonDecode(response.body);
          userList.clear();
          List<CollectorModel> userListData = jsonResponse
              .map((user) => CollectorModel.fromJson(user))
              .toList();
          userList.addAll(userListData);
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> sentInvitation(String receiverId) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      isSuccess.value=false;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.invitationEndPoints.sentInvitation;
        Map body = requestSenderBody(receiverId);
        final response = await http.post(Uri.parse(url),
            body: jsonEncode(body), headers: headers);
        if (response.statusCode == 200) {
           isSuccess.value=true;
           message.value = jsonDecode(response.body)["message"];
        } else {
          isSuccess.value=false;
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
  Future<void>respondInvitation(String status,String senderId) async{
     final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      isSuccess.value=false;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.invitationEndPoints.respondInvitaton;
        Map body = requestRespondBody(status,senderId);
        final response = await http.post(Uri.parse(url),
            body: jsonEncode(body), headers: headers);
        if (response.statusCode == 200) {
           isSuccess.value=false;
           message.value = jsonDecode(response.body)["message"];
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
   Future<void> cancelInvitation (String receiverId) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      isSuccess.value=false;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.invitationEndPoints.cancelInvitation;
        Map body = requestSenderBody(receiverId);
        final response = await http.post(Uri.parse(url),
            body: jsonEncode(body), headers: headers);
        if (response.statusCode == 200) {
           message.value = jsonDecode(response.body)["message"];
           isSuccess.value=true;
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }


  // Method to filter Customer base  on Obsearvable search term
  List<CollectorModel> filterUsers() {
    searchTerm.value = search.text
        .toLowerCase(); // Convert search term to lowercase for case-insensitive comparison
    if (searchTerm.isEmpty) {
      return userList.take(3).toList(); // Return an empty list if search text is empty
    } else {
      return userList
          .where((user) =>
              user.name.toLowerCase().contains(
                  searchTerm) || // Check if name contains the search term
              user.email.toLowerCase().contains(
                  searchTerm)) // Check if email contains the search term
          .take(3) // Take only the first 5 matching users
          .toList(); // Convert the result to a list
    }
  }
}
