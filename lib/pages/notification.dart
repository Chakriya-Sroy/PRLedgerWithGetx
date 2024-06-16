import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/collector.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/model/user.dart';
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
    userController.fetchNotifications();
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              var categorizedNotifications = userController
                  .categorizeNotifications(userController.userNotification);

              return ListView(
                children: [
                  buildCategory('Today', categorizedNotifications['Today']!),
                  buildCategory(
                      'Yesterday', categorizedNotifications['Yesterday']!),
                  ...categorizedNotifications.keys
                      .where((key) => key != 'Today' && key != 'Yesterday')
                      .map((key) =>
                          buildCategory(key, categorizedNotifications[key]!))
                      .toList(),
                ],
              );
            }),
          ),
        );
  }

  Widget buildCategory(String category, List<UserNotification> notifications) {
    if (notifications.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            category,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        ...notifications.map((notification) => Container(
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
                  ),
                ],
              ),
              child: notification.type == 'general'
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:  Column(
                          children: [
                            Align(alignment: Alignment.bottomLeft,child: Text(notification.message)),
                            const SizedBox(height: 5,),
                            Align( alignment: Alignment.bottomRight,child: Text(DateFormat('h:mm a').format(notification.created_at.toLocal()),style: TextStyle(fontSize: 10),))
                          ]
                        ),
                      
                    )
                  : Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset("lib/images/profileIcon.png"),
                            ),
                            Text(
                              notification.message.substring(
                                  0, notification.message.indexOf('invite')),
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.message,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputButton(
                                      label: "Decline",
                                      onPress: () async {
                                        await collectorController
                                            .respondInvitation(
                                          "declined",
                                          notification.sender_id.toString(),
                                        );
                                        if (collectorController
                                            .isSuccess.value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Obx(
                                                () => Text(
                                                  collectorController.message
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (collectorController
                                                    .errorMessage.value !=
                                                '' &&
                                            !collectorController
                                                .isSuccess.value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Obx(
                                                () => Text(
                                                  collectorController
                                                      .errorMessage
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.green,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: InputButton(
                                      label: "Accept",
                                      onPress: () async {
                                        await collectorController
                                            .respondInvitation(
                                          "accepted",
                                          notification.sender_id.toString(),
                                        );

                                        if (collectorController
                                            .isSuccess.value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Obx(
                                                () => Text(
                                                  collectorController.message
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (collectorController
                                                    .errorMessage.value !=
                                                '' &&
                                            !collectorController
                                                .isSuccess.value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Obx(
                                                () => Text(
                                                  collectorController
                                                      .errorMessage
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.white,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            )),
      ],
    );
  }
}
