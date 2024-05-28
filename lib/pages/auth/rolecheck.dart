import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/auth.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/collector/home.dart';

class RoleCheck extends StatefulWidget {
  const RoleCheck({super.key});

  @override
  State<RoleCheck> createState() => _RoleCheckState();
}

class _RoleCheckState extends State<RoleCheck> {
  final authController =Get.put(AuthCheckController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.IdentifyUserRole();
    
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() => authController.isMerchance.value ? const HomePage() : const CollectorRoleHomePage());
  }
}