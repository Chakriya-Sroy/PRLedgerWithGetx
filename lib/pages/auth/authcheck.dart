import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/auth.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/auth/login.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key});

  @override
  Widget build(BuildContext context) {
    final AuthCheckController authCheckController=Get.put(AuthCheckController());
    return Obx(() => authCheckController.isUserLogin.value ? HomePage(): Login());
  }
   
}



