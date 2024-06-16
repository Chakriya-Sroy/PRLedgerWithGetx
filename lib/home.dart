import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:laravelsingup/controller/auth.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/pages/collector/home.dart';
import 'package:laravelsingup/pages/merchant/collector/collector_page.dart';
import 'package:laravelsingup/pages/merchant/customer/customer.dart';
import 'package:laravelsingup/pages/merchant/payable/payable.dart';
import 'package:laravelsingup/pages/merchant/payable/payable_archive.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_archieve.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_page.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier.dart';
import 'package:laravelsingup/pages/notification.dart';
import 'package:laravelsingup/settings.dart';
import 'package:laravelsingup/widgets/drawer/drawer_body.dart';
import 'package:laravelsingup/widgets/menu/menu_item.dart';
import 'package:laravelsingup/widgets/message/confirm.dart';
import 'package:laravelsingup/widgets/receivable_payables/reminder.dart';
import 'package:laravelsingup/widgets/receivable_payables/visualize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController userController = Get.put(UserController());
  final AuthCheckController authCheckController =
      Get.put(AuthCheckController());

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUpcomingReceivables();
      userController.fetchUpcomingPayables();
      userController.getUser();
    });
  }

  Widget build(BuildContext context) {
    return Obx(() => userController.user.value == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
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
                // leading: ,
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(const NotificationPage());
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  )
                ]),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Receivable and Payable Card
                    const Text(
                      "Summary",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => PRVisualizeCardProgress(
                        title: "Receivables",
                        totalOustanding:
                            userController.receivables.value!.outstanding,
                        totalRemainingBalance:
                            userController.receivables.value!.remaining,
                        onPressed: () {
                          Get.to(const ReceivablePage());
                        },
                      ),
                    ),
                    Obx(
                      () => PRVisualizeCardProgress(
                        title: "Payables",
                        totalOustanding:
                            userController.payables.value!.outstanding,
                        totalRemainingBalance:
                            userController.payables.value!.remaining,
                        onPressed: () {
                          Get.to(const PayablePage());
                        },
                      ),
                    ),
                    //List of Menu
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Menu",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Menu([
                          MenuItem(
                            title: "Receivable",
                            imageIconPath: "https://testfyp1.sgp1.cdn.digitaloceanspaces.com/menu_icon/receivable.png",
                            onTap: () {
                              Get.to(const ReceivablePage());
                            },
                          ),
                          MenuItem(
                            title: "Customers",
                            imageIconPath: "https://testfyp1.sgp1.cdn.digitaloceanspaces.com/menu_icon/customer.png",
                            onTap: () {
                              Get.to(const CustomerPage());
                            },
                          ),
                          MenuItem(
                              title: "Payable",
                              imageIconPath: "https://testfyp1.sgp1.cdn.digitaloceanspaces.com/menu_icon/payable.png",
                              onTap: () {
                                Get.to(const PayablePage());
                              }),
                          MenuItem(
                            title: "Suppliers",
                            imageIconPath: "https://testfyp1.sgp1.cdn.digitaloceanspaces.com/menu_icon/supplier.png",
                            onTap: () {
                              Get.to(const SupplierPage());
                            },
                          ),
                          MenuItem(
                            title: "Collector",
                            imageIconPath: "https://testfyp1.sgp1.cdn.digitaloceanspaces.com/menu_icon/collector.png",
                            onTap: () {
                              Get.to(const MerchanceCollectorPage());
                            },
                          ),
                        ], 20)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Obx(() => userController.upcomingReceivable.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Upcoming Receivable",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              getUpcomingReceivable(userController)
                            ],
                          )),

                    Obx(() => userController.upcomingPayable.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Upcoming Payables",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              getUpcomingPayables(userController)
                            ],
                          ))
                  ],
                ),
              )),
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
                            child: ImageNetwork(image: "https://testfyp1.sgp1.cdn.digitaloceanspaces.com/menu_icon/profileIcon.png",width: 70,height: 70,),
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
                        ExpansionTile(
                          tilePadding: const EdgeInsets.only(left:0,right: 20),
                          initiallyExpanded: false,
                          expandedAlignment: Alignment.centerLeft,
                          shape: Border.all(color: Colors.transparent),
                          title: Text('Account Receivable',style: TextStyle(color: Colors.white),),
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Get.to(const ReceivablePage());
                              },
                              child: Align(alignment: Alignment.centerLeft,child: Text("Receviables ",style: TextStyle(color: Colors.white),)),),
                             const SizedBox(height:10),
                            GestureDetector(
                              onTap: (){
                                Get.to(const ArchieveReceivables());
                              },
                              child: Align(alignment: Alignment.centerLeft,child: Text("Archieve Receviable ",style: TextStyle(color: Colors.white),)),)
                          ],

                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpansionTile(
                          tilePadding: const EdgeInsets.only(left:0,right: 20),
                          initiallyExpanded: false,
                          expandedAlignment: Alignment.centerLeft,
                          shape: Border.all(color: Colors.transparent),
                          title: Text('Account Payable',style: TextStyle(color: Colors.white),),
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Get.to(const PayablePage());
                              },
                              child: Align(alignment: Alignment.centerLeft,child: Text("Payables ",style: TextStyle(color: Colors.white),)),),
                            const SizedBox(height:10),
                            GestureDetector(
                              onTap: (){
                                Get.to(const ArchivePayablePagee());
                              },
                              child: Align(alignment: Alignment.centerLeft,child: Text("Archieve Payable ",style: TextStyle(color: Colors.white),)),)
                          ],

                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DrawerBodyItem(
                          title: "Customers",
                          onTap: () {
                            Get.to(const CustomerPage());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DrawerBodyItem(
                          title: "Suppliers",
                          onTap: () {
                            Get.to(const SupplierPage());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DrawerBodyItem(
                          title: "Collector",
                          onTap: () {
                            Get.to(const MerchanceCollectorPage());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DrawerBodyItem(
                            title: "Settings",
                            onTap: () {
                              Get.to(SettingPage());
                            })
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

  Future<void> SwitchRole(BuildContext context) {
    final UserController userController = Get.put(UserController());
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
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
                  const Text(
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
                            });
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
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
                                onPressed: () async {
                              await userController.updateUserRole("Collector");
                              Navigator.of(context).pop();
                              Get.to((const CollectorRoleHomePage()));
                            });
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Collector",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ));
        });
  }

  Container Menu(List<Widget> items, double itemSpaces) {
    List<Widget> children = [];

    for (var i = 0; i < items.length; i++) {
      children.add(items[i]);
      if (i != items.length - 1) {
        children.add(SizedBox(width: itemSpaces));
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        children: children,
      ),
    );
  }

  Padding DrawerBody(List<Widget> items, double itemSpaces) {
    List<Widget> children = [];
    for (var i = 0; i < items.length; i++) {
      children.add(items[i]);
      if (i != items.length - 1) {
        children.add(SizedBox(width: itemSpaces));
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

Container getUpcomingReceivable(UserController userController) {
  return Container(
    //width: double.infinity,
    height: 80,
    child: ListView.builder(
        itemCount: userController.upcomingReceivable.length,
        itemExtent: null,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return PRUpcomingCard(
              id: userController.upcomingReceivable[index].id,
              date: userController.upcomingReceivable[index].receivableCreated,
              name:
                  userController.upcomingReceivable[index].customer.toString(),
              remainingBalance:
                  userController.upcomingReceivable[index].remaining.toString(),
              status: userController.upcomingReceivable[index].status,
              dueStatus: userController.upcomingReceivable[index].upcoming);
        }),
  );
}

Container getUpcomingPayables(UserController userController) {
  return Container(
    //width: double.infinity,
    height: 80,
    child: ListView.builder(
        itemCount: userController.upcomingPayable.length,
        itemExtent: null,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return PRUpcomingCard(
              id: userController.upcomingPayable[index].id,
              date: userController.upcomingPayable[index].payableCreated,
              name: userController.upcomingPayable[index].supplier.toString(),
              remainingBalance:
                  userController.upcomingPayable[index].remaining.toString(),
              status: userController.upcomingPayable[index].status,
              dueStatus: userController.upcomingPayable[index].upcoming);
        }),
  );
}
