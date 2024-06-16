import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/pages/merchant/customer/customer.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final CustomerController customerController = Get.put(CustomerController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.clearTextEditor();
      customerController.isLoading.value = false;
      customerController.initializeStatusFlags();
    });
  }

  void showSnackBar(
      bool isSuccess, bool isFailed, String message, String errorMessage) {
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(customerController.message.toString(),
              style: const TextStyle(color: Colors.white))
      ));

      Get.to(const CustomerPage());
    }
    if (isFailed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content:Text(customerController.errorMessage.toString(),
              style: const TextStyle(color: Colors.white))
      ));

      Get.to(const CustomerPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('Customer Record',
                    style: TextStyle(fontSize: 15)),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Obx(() => CustomTextField(
                        label: "Fullname",
                        controller: customerController.name,
                        validation:
                            customerController.nameValidation.toString(),
                        gapHeight: 5)),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        genderRadio(value: "Male"),
                        const SizedBox(
                          width: 20,
                        ),
                        genderRadio(value: "Female")
                      ],
                    ),
                    Obx(() => CustomTextField(
                        label: "Phone number",
                        controller: customerController.phone,
                        validation:
                            customerController.phoneValidation.toString(),
                        gapHeight: 5)),
                    Obx(() => CustomTextField(
                        label: "Email",
                        controller: customerController.email,
                        validation:
                            customerController.emailValidation.toString(),
                        gapHeight: 5)),
                    Obx(() => CustomTextField(
                        label: "Address",
                        controller: customerController.address,
                        validation:
                            customerController.addressValidation.toString(),
                        gapHeight: 5)),
                    InputTextField(
                      label: "Remark",
                      controller: customerController.remark,
                    ),
                    const SizedBox(height: 20),
                    InputButton(
                        label: "Save",
                        onPress: () async {
                          await customerController.addCustomer();
                          showSnackBar(
                            customerController.isSuccess.value, 
                            customerController.isFailed.value, 
                            customerController.message.value, 
                            customerController.errorMessage.value
                          );
                          // if (customerController.isSuccess.value) {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     backgroundColor: Colors.green,
                          //     content: Obx(
                          //       () => Text(
                          //           customerController.message.toString(),
                          //           style:
                          //               const TextStyle(color: Colors.white)),
                          //     ),
                          //   ));
                          //   await Future.delayed(const Duration(seconds: 1));
                          //   Get.back();
                          // }
                          // if (customerController.isFailed.value) {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     backgroundColor: Colors.red,
                          //     content: Obx(
                          //       () => Text(
                          //           customerController.errorMessage.toString(),
                          //           style:
                          //               const TextStyle(color: Colors.white)),
                          //     ),
                          //   ));
                          //   await Future.delayed(const Duration(seconds: 1));
                          //   Get.back();
                          // }
                        },
                        backgroundColor: Colors.green,
                        color: Colors.white),
                  ]),
                ),
              ),
            ),
            if (customerController.isLoading.value)
              // Show circular progress indicator in the middle of the screen
              Container(
                color: Colors.black.withOpacity(
                    0.2), // Semi-transparent black color for the backdrop
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ));
  }

  Widget genderRadio({required String value}) {
    final CustomerController customerController = Get.put(CustomerController());
    return Obx(() => Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: customerController.gender.value,
              onChanged: (selectedValue) {
                customerController.gender.value = selectedValue!;
              },
            ),
            const SizedBox(
              width: 20,
            ),
            Text(value),
          ],
        ));
  }
}
