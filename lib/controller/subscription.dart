import 'dart:convert';
import 'package:get/get.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController {
  RxString type = 'yearly'.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString successfulMessage = ''.obs;
  RxBool isSuccess=false.obs;
  Future<void> addSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    isSuccess.value=false;
    if (token != null) {
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.subscriptionEndPoints.subscription;
        Map body = {
          'type': type.value,
        };
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          successfulMessage.value = json["message"];
          isSuccess.value=true;
          print(json);
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
          print(errorMessage);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        isLoading.value = false;
      }
    }
  }
  Future<void> updateSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    isSuccess.value=false;
    if (token != null) {
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.subscriptionEndPoints.updateSubscription;
        final response = await http.patch(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          successfulMessage.value = json["message"];
          isSuccess.value=true;
          print(json);
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
          print(errorMessage);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
