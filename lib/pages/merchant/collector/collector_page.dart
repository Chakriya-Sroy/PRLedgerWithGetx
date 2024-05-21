import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/merchant/collector/invite_collector.dart';
import 'package:laravelsingup/widgets/empty_state.dart';

class MerchanceCollectorPage extends StatefulWidget {
  const MerchanceCollectorPage({super.key});

  @override
  State<MerchanceCollectorPage> createState() => _MerchanceCollectorPageState();
}

class _MerchanceCollectorPageState extends State<MerchanceCollectorPage> {
  final userController = Get.put(UserController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collector",style: TextStyle(color: Colors.white),),
        centerTitle:true,
        backgroundColor: Colors.green,
        leading: GestureDetector(
          onTap: () {
            Get.to(const HomePage());
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Obx(() => userController.userCollector.value!.hasCollector ==
                      false
                  ? WhenListIsEmpty(
                      title: "You don't have collector yet, Invite Collector ?",
                      onPressed: (){
                        Get.to(const FindCollectorPage());
                      })
                  : SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
