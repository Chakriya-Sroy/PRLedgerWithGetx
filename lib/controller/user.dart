import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/model/user.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    getUser();
    fetchUpcomingReceivables();
    super.onInit();
  }



  // Observe Variable
  late Rx<UserModel?> user = Rx<UserModel?>(null);
  late Rx<Subscription?> subscription = Rx<Subscription?>(null);
  late Rx<Receivable?> receivables = Rx<Receivable?>(null);
  late Rx<Payable?> payables = Rx<Payable?>(null);
  RxList<UpcomingReceivable> upcomingReceivable = RxList();
  RxDouble totalSuppliers = RxDouble(0);
  RxDouble totalCustomers = RxDouble(0);

  RxString userRole = 'Merchance'.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  // TextEditing Controller
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();

  Future<void> updateUser() async {}
  Future<dynamic> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        var fullUrl =
            ApiEndPoints.baseUrl + ApiEndPoints.userEndPoints.userDetail;

        var response = await http.get(
          Uri.parse(fullUrl),
          headers: _setHeaderToken(token),
        );
        isLoading.value = true;
        // Check if the request was successful
        if (response.statusCode == 200) {
          // Parse and return the response body
          Map<String, dynamic> data = json.decode(response.body);
          List<dynamic> dataList = data['data'];
          Map<String, dynamic> firstItem =
              dataList.isNotEmpty ? dataList[0] : {};
          user.value = UserModel.fromJson(firstItem["user_info"]);
          receivables.value = Receivable.fromJson(firstItem["receivables"]);
          payables.value = Payable.fromJson(firstItem["payables"]);
          subscription.value = Subscription.fromJson(firstItem["subscription"]);
          totalCustomers.value = firstItem["customers"];
          totalSuppliers.value = firstItem["suppliers"];
          fullname.text = user.value!.name;
          email.text = user.value!.email;
        } else {
          // If the request was not successful, throw an error
          errorMessage.value = "Failed to load user data 202";
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    } else {
      // If token is null, throw an error indicating token is not available
      throw Exception('Token is not available');
    }
  }

  Future<void> fetchUpcomingReceivables() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        var fullUrl = ApiEndPoints.baseUrl +
            ApiEndPoints.userEndPoints.upcomingReceivable;
        var response = await http.get(
          Uri.parse(fullUrl),
          headers: _setHeaderToken(token),
        );
        isLoading.value = true;
        // Check if the request was successful
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          List<dynamic> upcomingReceivablesData = data["upcomingReceivables"];

          for (int i = 0; i < upcomingReceivablesData.length; i++) {
            var receivableData = upcomingReceivablesData[i];
            String id = receivableData["id"].toString();
            String customer = receivableData["customer"];
            double remaining = receivableData["remaining"];
            String status = receivableData["status"];
            String upcoming = receivableData["upcoming"];

            // Uncomment the following line if you have a constructor for UpcomingReceivable
             upcomingReceivable.add(UpcomingReceivable(id: id, customer: customer, remaining: remaining, status: status, upcoming: upcoming));
          } 
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage.value);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Map<String, String> _setHeaderToken(String token) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
