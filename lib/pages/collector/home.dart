import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/auth.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/collector/customer/customer.dart';
import 'package:laravelsingup/widgets/drawer/drawer_body.dart';
import 'package:laravelsingup/widgets/message/confirm.dart';
import 'package:laravelsingup/widgets/receivable_payables/reminder.dart';
import 'package:laravelsingup/widgets/receivable_payables/visualize.dart';

class CollectorRoleHomePage extends StatefulWidget {
  const CollectorRoleHomePage({super.key});

  @override
  State<CollectorRoleHomePage> createState() => _CollectorRoleHomePageState();
}

class _CollectorRoleHomePageState extends State<CollectorRoleHomePage> {
  final authCheckController = Get.put(AuthCheckController());
  final userController = Get.put(UserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.getUser();
    userController.fetchAssignCustomerRecivableDetail();
    userController.fetchUpcomingAssignCustomerReceivable();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => userController.user.value == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Obx(
                () => Text(
                  userController.user.value!.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.green,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => PRVisualizeCardProgress(
                        title: "Receivables",
                        totalOustanding:
                            userController.totalAssignReceivableAmount.value,
                        totalRemainingBalance: userController
                            .totalAssignReceivableRemaining.value)),
                    const Text(
                      "Upcoming Receivable",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => userController
                                .upcomingReceivablesAssignFromMerchance
                                .length ==
                            0
                        ? const Text("There no upcoming receivable")
                        : getUpcomingReceivable(userController)),
                  ],
                ),
              ),
            ),
            drawer: Drawer(
                backgroundColor: Colors.green,
                elevation: 0,
                child: ListView(children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: SizedBox(
                            child: Image.asset("lib/images/profileIcon.png"),
                          ),
                        ),
                        Obx(() => userController.user.value!.hasCollectorRole
                            ? GestureDetector(
                                onTap: () {
                                  SwitchRole(context);
                                },
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userController.user.value!.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.white,
                                      )
                                    ]),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  userController.user.value!.name.toString(),
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DrawerBodyItem(
                          title: "Account Receivable",
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DrawerBodyItem(
                          title: "Customers",
                          onTap: () {
                            Get.to(const CollectorCustomerPage());
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                          onTap: () {
                            authCheckController.Logout();
                          },
                          child: Text("Sign out",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))),
                    ),
                  )
                ]))));
  }

  Container getUpcomingReceivable(UserController userController) {
    return Container(
      //width: double.infinity,
      height: 80,
      child: ListView.builder(
          itemCount:
              userController.upcomingReceivablesAssignFromMerchance.length,
          itemExtent: null,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return PRUpcomingCard(
                name: userController
                    .upcomingReceivablesAssignFromMerchance[index].customer
                    .toString(),
                remainingBalance: userController
                    .upcomingReceivablesAssignFromMerchance[index].remaining
                    .toString(),
                status: userController
                    .upcomingReceivablesAssignFromMerchance[index].status,
                dueStatus: userController
                    .upcomingReceivablesAssignFromMerchance[index].upcoming);
          }),
    );
  }

  Future<void> SwitchRole(BuildContext context) {
    final UserController userController = Get.put(UserController());
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    width: 100,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                  Text(
                    "Switch Rold",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Radio(
                          value: "Merchance",
                          groupValue: userController.userRole.value,
                          onChanged: (value) {
                            ConfirmMessageBox(context,
                                message:
                                    "Confirm changing your role to Merchance ?",
                                onPressed: () async {
                      
                             await userController.updateUserRole("Merchance");
                              Navigator.of(context).pop();
                              Get.to(const HomePage());
                            });
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Merchance",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: "Collector",
                          groupValue: userController.userRole.value,
                          onChanged: (value) {
                            ConfirmMessageBox(context,
                                message:
                                    "Confirm changing your role to Collector ?",
                                onPressed: () async{
                              await userController.updateUserRole("Collector");
                              Navigator.of(context).pop();
                            });
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Collector",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ));
        });
  }
}
