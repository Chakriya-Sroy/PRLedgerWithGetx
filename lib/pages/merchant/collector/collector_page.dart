import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/merchant/collector/invite_collector.dart';
import 'package:laravelsingup/pages/settings/subscription.dart';
import 'package:laravelsingup/widgets/empty_state.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/message/confirm.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class MerchanceCollectorPage extends StatefulWidget {
  const MerchanceCollectorPage({super.key});

  @override
  State<MerchanceCollectorPage> createState() => _MerchanceCollectorPageState();
}

class _MerchanceCollectorPageState extends State<MerchanceCollectorPage> {
  final userController = Get.put(UserController());
  final customerController = Get.put(CustomerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.getUser(); // To find collector Id
    userController
        .fetchRequestInvitation(); // it usefull when user need to see the list of request they have mad
    customerController
        .fetchAssignCustomerToCollector(); // to fetch customer that user already assign
  }

  void showMultiSelectCustomer(BuildContext context) async {
    await customerController.fetchCustomer();
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          title: Text("Select Customer To assign"),
          searchable: true,
          items: customerController
              .filterUnassignCustomers()
              .map((e) => MultiSelectItem(e, e.name))
              .toList(),
          initialValue: customerController.filterUnassignCustomers(),
          listType: MultiSelectListType.CHIP,
          itemsTextStyle: TextStyle(color: Colors.green),
          onConfirm: (values) async {
            for (var i = 0; i < values.length; i++) {
              await customerController.assignCustomerToCollector(
                  userController.userCollector.value!.id, values[i].id);
              if (customerController.isSuccess.value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Obx(
                      () => Text(customerController.message.toString(),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );

                // refresh the fetching assign customer
                customerController.fetchAssignCustomerToCollector();
              }
            }
          },
          selectedColor: Colors.green,
          selectedItemsTextStyle: TextStyle(color: Colors.white),
          searchTextStyle: TextStyle(color: Colors.green),
          maxChildSize: 0.8,
          separateSelectedItems: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Collector",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
              Obx(
                () => userController.subscription.value!.type == 'free'
                    ? WhenListIsEmpty(
                        title:
                            "Wanna invite someone as your collector ?, subscribe to our premium plan",
                        inputButtonTitle: 'subscribe',
                        onPressed: () {
                          Get.to(const SubscriptionSetting());
                        })
                    : Obx(() => !userController.hasCollector.value
                        ? WhenListIsEmpty(
                            title:
                                "You don't have collector yet, Invite Collector ?",
                            onPressed: () {
                              Get.to(const FindCollectorPage());
                            },
                            inputButtonTitle: "Invite",
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 4.0,
                                      spreadRadius: 0.0,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(userController
                                        .userCollector.value!.name),
                                    SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: InputButton(
                                          label: "Assign Customer",
                                          onPress: () {
                                            showMultiSelectCustomer(context);
                                          },
                                          backgroundColor: Colors.green,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Obx(() => customerController
                                          .ListofAssignCustomerToCollector
                                          .length ==
                                      0
                                  ? const Text(
                                      "There no customer assign to collector yet")
                                  : const Text(
                                      "List of Customer that already assign to collector")),
                              Obx(() => ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: customerController
                                        .ListofAssignCustomerToCollector.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(top: 10),
                                        height: 60,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey.shade100,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: Offset(4.0, 4.0),
                                              blurRadius: 4.0,
                                              spreadRadius: 0.0,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              customerController
                                                  .ListofAssignCustomerToCollector[
                                                      index]
                                                  .name,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: InputButton(
                                                label: "Unassign",
                                                onPress: () async {
                                                  ConfirmMessageBox(
                                                    context,
                                                    message:
                                                        "Are you sure to unassign customer from collector?",
                                                    onPressed: () async {
                                                      await customerController
                                                          .unassignCustomerFromCollector(
                                                        userController
                                                            .userCollector
                                                            .value!
                                                            .id,
                                                        customerController
                                                            .ListofAssignCustomerToCollector[
                                                                index]
                                                            .id,
                                                      );
                                                      if (customerController
                                                          .isSuccess.value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Obx(
                                                              () => Text(
                                                                  customerController
                                                                      .message
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                        // refresh the fetching assign customer
                                                        customerController
                                                            .fetchAssignCustomerToCollector();
                                                      }
                                                    },
                                                  );
                                                },
                                                backgroundColor: Colors.red,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ))
                            ],
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
