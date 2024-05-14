import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/pages/auth/login.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class RegisterationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxString nameValidation = RxString('');
  RxString emailValidation = RxString('');
  RxString passwordValidation = RxString('');
  RxString confirmPasswordValidation = RxString('');
  RxString errorMessage = RxString('');

  Future<void> registerWithEmailandPassword() async {
    if(validation()){
        try {
        var headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };
        var url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerEmail);
        Map body = {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        };
        http.Response response =
            await http.post(url, body: jsonEncode(body), headers: headers);
        if (response.statusCode == 200) {
          Get.off(Login);
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          print("success register");
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
        }
      } catch (e) {
         errorMessage.value=e.toString();
      }
    }
    }
  

  bool validation() {
    if (nameController.text.isEmpty) {
      nameValidation.value = "The fullname field is required";
    } else {
      nameValidation.value = "";
    }
    if (emailController.text.isEmpty) {
      emailValidation.value = "The email field is required";
    } else if (!emailController.text.isEmail) {
      emailValidation.value = "The email format is not correct";
    } else {
      emailValidation.value = "";
    }
    if (passwordController.text.length < 8) {
      passwordValidation.value =
          "The pasword length must be greather or equal to 8";
    } else {
      passwordValidation.value = "";
    }
    if (confirmPasswordController.text.length < 8) {
      confirmPasswordValidation.value =
          "The pasword length must be greather or equal to 8";
    } else {
      confirmPasswordValidation.value = "";
    }
    if (passwordController.text != confirmPasswordController.text) {
      passwordValidation.value = "The Password not match";
    } else {
      passwordValidation.value = "";
    }
    return nameValidation.value.isEmpty &&
        emailValidation.value.isEmpty &&
        passwordValidation.value.isEmpty &&
        confirmPasswordValidation.value.isEmpty;
  }
}
