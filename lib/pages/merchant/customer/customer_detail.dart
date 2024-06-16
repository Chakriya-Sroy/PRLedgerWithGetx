import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/pages/merchant/customer/customer_edit.dart';
import 'package:laravelsingup/pages/merchant/customer/customer_log.dart';
import 'package:laravelsingup/widgets/message/confirm.dart';
import 'package:laravelsingup/widgets/profile/profile_action_button.dart';
import 'package:laravelsingup/widgets/profile/profile_card.dart';
import 'customer.dart';

class CustomerDetail extends StatefulWidget {
  const CustomerDetail({super.key});

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  final customerController = Get.put(CustomerController());
  final String id = Get.arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.initializeStatusFlags();
      customerController.fetchIndividualCustomer(id);
    });
  }

  void showSnackBar(bool isSuccess, bool isFailed,
      String message, String errorMessage) {
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      );
    }
    if (isFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content:
              Text(errorMessage, style: const TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Get.off(const CustomerLogTransaction(), arguments: id);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.green,
            ),
          ),
        ),
        body: Obx(() => customerController.customer.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileCard(
                          supplier: false,
                          fullname: customerController.customer.value!.name,
                          gender: customerController.customer.value!.gender,
                          email: customerController.customer.value!.email ?? '',
                          address:
                              customerController.customer.value!.address ?? '',
                          phone: customerController.customer.value!.phone),
                      ProfileActionButton(
                        onEdit: () {
                          Get.to(const CustomerEdit(), arguments: id);
                        },
                        onDelete: () {
                          ConfirmMessageBox(context,
                              message:
                                  "All the receivable that record under this customer will be deleted are you sure ?",
                              onPressed: () async {
                            await customerController.deleteCustomer(id);
                            showSnackBar(
                              customerController.isSuccess.value, 
                              customerController.isFailed.value,
                              customerController.message.value, 
                              customerController.errorMessage.value
                             );
                            // if (customerController.isSuccess.value) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       backgroundColor: Colors.green,
                            //       content: Obx(
                            //         () => Text(
                            //             customerController.message.toString(),
                            //             style: TextStyle(color: Colors.white)),
                            //       ),
                            //     ),
                            //   );
                            // }
                            // if (customerController.isFailed.value) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       backgroundColor: Colors.red,
                            //       content: Obx(
                            //         () => Text(
                            //             customerController.errorMessage
                            //                 .toString(),
                            //             style: TextStyle(color: Colors.white)),
                            //       ),
                            //     ),
                            //   );
                            // }
                            Get.off(const CustomerPage());
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )));
  }
}
