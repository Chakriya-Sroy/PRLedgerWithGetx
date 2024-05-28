import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/collector.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final userController = Get.put(UserController());
  final collectorController = Get.put(CollectorController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.fetchReceivedInvitation();
    userController.fetchRequestInvitation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(const HomePage());
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Obx(() => ListView.builder(
                      itemCount: userController.senders.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0,
                                )
                              ],
                            ),
                            child: Row(children: [
                              Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                        "lib/images/profileIcon.png"), // Use Image.asset for local images
                                  ),
                                  Text(
                                    userController.senders[index].name,
                                    style: TextStyle(color: Colors.green),
                                  )
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                      "Invite as a collector by" +
                                          userController.senders[index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: InputButton(
                                                label: "Declined",
                                                onPress: () async {
                                                  await collectorController
                                                      .respondInvitation(
                                                          "declined",
                                                          userController
                                                              .senders[index]
                                                              .id);
                                                },
                                                backgroundColor: Colors.green,
                                                color: Colors.white)),
                                        Expanded(
                                            child: InputButton(
                                                label: "Accepted",
                                                onPress: () async {
                                                  await collectorController
                                                      .respondInvitation(
                                                          "accepted",
                                                          userController
                                                              .senders[index]
                                                              .id);

                                                  if (collectorController
                                                      .isSuccess.value) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Obx(
                                                          () => Text(
                                                              collectorController
                                                                  .message
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Obx(
                                                          () => Text(
                                                              collectorController
                                                                  .errorMessage
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                backgroundColor: Colors.white,
                                                color: Colors.green)),
                                      ],
                                    )
                                  ]))
                            ]));
                      },
                    )),
              ],
            )));
  }
}
