import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/model/collector.dart';
import 'package:laravelsingup/model/user.dart';
import 'package:laravelsingup/pages/merchant/payable/payable.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  // Observe Variable
  late Rx<UserModel?> user = Rx<UserModel?>(null);
  late Rx<Subscription?> subscription = Rx<Subscription?>(null);
  late Rx<Receivable?> receivables = Rx<Receivable?>(null);
  late Rx<Payable?> payables = Rx<Payable?>(null);
  RxList<UpcomingReceivable> upcomingReceivable = RxList();
  RxList<UpcomingPayable> upcomingPayable = RxList();
  RxList<UpcomingReceivable>upcomingReceivablesAssignFromMerchance=RxList();
  RxDouble totalAssignReceivableAmount=RxDouble(0);
  RxDouble totalAssignReceivableRemaining=RxDouble(0);
  RxDouble totalSuppliers = RxDouble(0);
  RxDouble totalCustomers = RxDouble(0);
  Rx<UserCollectorInfo?> userCollector = Rx<UserCollectorInfo?>(null);
  //

  RxBool hasCollector =false.obs;
  RxString userRole = 'Merchance'.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxString message = ''.obs;
  // TextEditing Controller
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();

  // List of Sender request  User
  RxList<SenderModel> senders = RxList();
  // List of receiver response User
  RxList<ReceiverModel> receivers = RxList();

  Future<void> updateUser() async {}

  Future<void> setUserRole(String role) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("role", role);
  }

  // Function to update user role and call setUserROle()
  Future<void> updateUserRole(String newRole) async {
    userRole.value = newRole; // Assuming userRole is a ValueNotifier or similar
    await setUserRole(newRole);
  }
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
          hasCollector.value=firstItem["collector"]["has_collector"];
          userCollector.value=UserCollectorInfo.fromJson(firstItem["collector"]["collector_info"]);
          
        } else {
          // If the request was not successful, throw an error
          errorMessage.value = jsonDecode(response.body)["message"];
         

        }
      } catch (e) {
        print(e.toString);
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
          upcomingReceivable.clear();
          for (int i = 0; i < upcomingReceivablesData.length; i++) {
            Map<String, dynamic> receivableData = upcomingReceivablesData[i];
            upcomingReceivable.add(UpcomingReceivable.fromJson(receivableData));
          }
          
        }
      } catch (e) {
        //errorMessage.value = e.toString();
        print(e.toString);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> fetchUpcomingPayables() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        var fullUrl =
            ApiEndPoints.baseUrl + ApiEndPoints.userEndPoints.upcomingPayable;
        var response = await http.get(
          Uri.parse(fullUrl),
          headers: _setHeaderToken(token),
        );
        isLoading.value = true;
        // Check if the request was successful
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          List<dynamic> upcomingPayablesData = data["upcomingPayables"];
          upcomingPayable.clear();
          for (int i = 0; i < upcomingPayablesData.length; i++) {
            Map<String, dynamic> payableData = upcomingPayablesData[i];
            upcomingPayable.add(UpcomingPayable.fromJson(payableData));
          }
          
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }
  Future<void>fetchAssignCustomerRecivableDetail() async{
  
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        var fullUrl =
            ApiEndPoints.baseUrl + ApiEndPoints.userEndPoints.assignCustomerReceivableDetail;
        var response = await http.get(
          Uri.parse(fullUrl),
          headers: _setHeaderToken(token),
        );
        isLoading.value = true;
        // Check if the request was successful
        if (response.statusCode == 200) {
            Map<String,dynamic> json=jsonDecode(response.body);
            totalAssignReceivableAmount.value=json["total_amount"];
            totalAssignReceivableRemaining.value=json["total_remaining"];
        }
        }catch (e){
          print(e.toString());
        }
  }
  }
   Future<void> fetchUpcomingAssignCustomerReceivable() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        var fullUrl =
            ApiEndPoints.baseUrl + ApiEndPoints.userEndPoints.assignUpCustomerReceivable;
        var response = await http.get(
          Uri.parse(fullUrl),
          headers: _setHeaderToken(token),
        );
        isLoading.value = true;
        // Check if the request was successful
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          List<dynamic> upcominReceivableData = data["upcomingReceivables"];
          upcomingPayable.clear();
          for (int i = 0; i < upcominReceivableData .length; i++) {
            Map<String, dynamic> receivableData= upcominReceivableData [i];
            upcomingReceivablesAssignFromMerchance.add(UpcomingReceivable.fromJson(receivableData));
          }
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    
    }
  }
  // Fetch Invitation request that user recieved from other user
  Future<void> fetchReceivedInvitation() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.userEndPoints.invitationRequestReceived;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = jsonDecode(response.body);
          senders.clear();
          for (var data in jsonResponse) {
            senders.add(SenderModel.fromJson(data["sender"]));
          }
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> fetchRequestInvitation() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.userEndPoints.invitationRequest;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = jsonDecode(response.body);
          receivers.clear();
          for (var data in jsonResponse) {
            receivers.add(ReceiverModel.fromJson(data["receiver"]));
          }
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        print(e.toString());
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
