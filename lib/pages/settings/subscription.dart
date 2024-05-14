import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/subscription.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/widgets/message/confirm.dart';

class SubscriptionSetting extends StatefulWidget {
  const SubscriptionSetting({super.key});

  @override
  State<SubscriptionSetting> createState() => _SubscriptionSettingState();
}

class _SubscriptionSettingState extends State<SubscriptionSetting> {
  @override
  Widget build(BuildContext context) {
    final SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    final UserController userController = Get.put(UserController());

    userController.subscription.value!.type=='free'? subscriptionController.type.value="yearly" :subscriptionController.type.value= userController.subscription.value!.type ;
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.green),
          backgroundColor: Colors.grey.shade100,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(
              () => subscriptionController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Obx(() => subscriptionController
                                .successfulMessage.value.isNotEmpty
                            ? Text(
                                subscriptionController.successfulMessage.value)
                            : const SizedBox()),
                        Text(
                          "Premium Version",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("What's Included"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            subscriptionDetail(title: "up to 5 supplieres"),
                            subscriptionDetail(title: "up to 15 customers"),
                            subscriptionDetail(title: "1 collector"),
                            subscriptionDetail(title: "Add attachment"),
                          ]),
                        ),
                        Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 10, top: 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 220,
                                child: Obx(
                                  () => RadioListTile(
                                    value: "yearly",
                                    title: Row(
                                      children: [
                                        Text("Yearly"),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 15),
                                          width: 70,
                                          height: 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "-15%",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          "\$35.99",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text("\$29.99")
                                      ],
                                    ),
                                    groupValue:
                                        subscriptionController.type.value,
                                    onChanged: (value) {
                                      subscriptionController.type.value =
                                          value.toString();
                                    },
                                  ),
                                ),
                              ),
                              Text("\$2.5/month")
                            ],
                          ),
                        ),
                        Container(
                          height: 70,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 200,
                                  child: Obx(
                                    () => RadioListTile(
                                      value: "monthly",
                                      title: Text("Monthly"),
                                      groupValue:
                                          subscriptionController.type.value,
                                      onChanged: (value) {
                                        subscriptionController.type.value =
                                            value.toString();
                                      },
                                    ),
                                  )),
                              Text("\$2.99/month")
                            ],
                          ),
                        ),
                        Obx(() =>
                          userController.subscription.value!.type=='free' ? AddSubscriptionPlan(userController, context, subscriptionController):SizedBox()
                         ),
                        Obx(() =>
                          userController.subscription.value!.type=='monthly' ? Column(children: [UpdateSubscriptionPlanFromMontlyToYearly(userController, context, subscriptionController),CancelSubscriptionPlan(userController, context, subscriptionController)],):SizedBox(),
                         ),
                        Obx(() =>
                          userController.subscription.value!.type=='yearly' ? CancelSubscriptionPlan(userController, context, subscriptionController):SizedBox()
                         ),
                      ],
                    ),
            ),
          ),
        ));
  }

  GestureDetector AddSubscriptionPlan(UserController userController,
      BuildContext context, SubscriptionController subscriptionController) {
    return GestureDetector(
      onTap: () {
        ConfirmMessageBox(
          context,
          message:
              "Confirm upgrade to ${subscriptionController.type.value} subscription?",
          onPressed: () {
            subscriptionController.addSubscription();
            Navigator.pop(context);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 10),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Upgrade",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  GestureDetector UpdateSubscriptionPlanFromMontlyToYearly(
      UserController userController,
      BuildContext context,
      SubscriptionController subscriptionController) {
    return GestureDetector(
      onTap: () {
        ConfirmMessageBox(
          context,
          message: "Confirm upgrade to yearly subscription?",
          onPressed: () {
            subscriptionController.updateSubscription();
            userController.getUser();
            Navigator.pop(context);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Upgrade To yearly",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  GestureDetector CancelSubscriptionPlan(UserController userController,
      BuildContext context, SubscriptionController subscriptionController) {
    return GestureDetector(
      onTap: () {
        ConfirmMessageBox(
          context,
          message:
              "Confirm cancel ${userController.subscription.value!.type} subscription?",
          onPressed: () {
            // subscriptionController.addSubscription();
            // Navigator.pop(context);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top:30),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
           color: Colors.red,
           borderRadius: BorderRadius.circular(10)
          ),
        child: Text(
          "Cancel Current Subscription Plan",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  Row subscriptionDetail({required String title}) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.green,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
