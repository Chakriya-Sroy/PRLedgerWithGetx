import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //late SharedPreferences pref;
  RxString errorMessage = RxString("");
  RxString emailValidation = RxString("");
  RxString passwordValidation = RxString("");
  RxBool isLoading = false.obs;
  RxBool isSuccess = false.obs;
  RxString message = RxString('');

  Future<void> forgotPasswordResetLink() async {
    try {
      isLoading.value = true;
       isSuccess.value=false;
      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      //var url=Uri.parse(ApiEndPoints.baseUrl+ApiEndPoints.authEndPoints.login);
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.forgotPassword;
      Map body = {'email': emailController.text};
      // http.Response response= await http.post(url,body:jsonEncode(body),headers: headers);
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      );
      if (response.statusCode == 200) {
         emailController.clear();
         isSuccess.value=true;
         message.value=jsonDecode(response.body)["message"];
       
      } else {
         isSuccess.value=false;
         errorMessage.value=jsonDecode(response.body)["message"];
      }
    } catch (e) {
      print(e.toString());
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> loginWithEmailandPassword() async {
    if (validation()) {
      try {
        isLoading.value = true;
        var headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };
        //var url=Uri.parse(ApiEndPoints.baseUrl+ApiEndPoints.authEndPoints.login);
        var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.login;
        Map body = {
          'email': emailController.text,
          'password': passwordController.text,
        };
        // http.Response response= await http.post(url,body:jsonEncode(body),headers: headers);
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final token = json["token"];
          // final SharedPreferences pref= await _prefs;
          final pref = await SharedPreferences.getInstance();
          await pref.setString("token", token);
          await pref.setString("role", "Merchance");
          message.value = json["message"];
          emailController.clear();
          passwordController.clear();
          isSuccess.value = true;
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
        }
      } catch (e) {
        print(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> googleRedirectURL() async {
    try {
      isLoading.value = true;
     
      var headers = ApiEndPoints().setHeader();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.redirectURLGoogle;

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var redirectURL = jsonDecode(response.body)['redirect_url'];
        Uri uri = Uri.parse(redirectURL);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $redirectURL');
        }
      } else {
        final responseData = jsonDecode(response.body);
        errorMessage.value = responseData['message'];
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool validation() {
    if (emailController.text.isEmpty) {
      emailValidation.value = "The email field is required";
    } else if (!emailController.text.isEmail) {
      emailValidation.value = "The email is incorrect format";
    } else {
      emailValidation.value = "";
    }
    if (passwordController.text.isEmpty) {
      passwordValidation.value = "The password field is required";
    } else if (passwordController.text.length < 8) {
      passwordValidation.value =
          "The pasword length must be greather or equal to 8";
    } else {
      passwordValidation.value = "";
    }
    return emailValidation.isEmpty && passwordValidation.isEmpty;
  }
}
