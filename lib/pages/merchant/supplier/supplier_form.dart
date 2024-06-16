import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';

class SupplierForm extends StatefulWidget {
  const SupplierForm({super.key});

  @override
  State<SupplierForm> createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm> {
  final SupplierController supplierController = Get.put(SupplierController());
  @override
  void initState() {
    super.initState();
    supplierController.isLoading.value=false;
    supplierController.clearTextEditor();
    supplierController.initializeStatusFlags();
  }
  void showSnachBar(bool isSuccess, bool isFailed, String message, String errorMessage){
     if (isSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content:Text(
                                      message,
                                      style: const TextStyle(color: Colors.white))
                              ),
                            );
                            Get.to(const SupplierPage());
                          }
                          if (isFailed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content:  Text(
                                      errorMessage,
                                      style: const TextStyle(color: Colors.white)),
                              ),
                            );
                           Get.to(const SupplierPage());
                          }
                          
  }
  @override
  Widget build(BuildContext context) {
   
    return Obx(() => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('Supplier Record',
                    style: TextStyle(fontSize: 15)),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Obx(() => CustomTextField(
                        label: "Fullname",
                        controller: supplierController.name,
                        validation:
                            supplierController.nameValidation.toString(),
                        gapHeight: 5)),
                    Obx(() => CustomTextField(
                        label: "Phone number",
                        controller: supplierController.phone,
                        validation:
                            supplierController.phoneValidation.toString(),
                        gapHeight: 5)),
                    Obx(() => CustomTextField(
                        label: "Email",
                        controller: supplierController.email,
                        validation:
                            supplierController.emailValidation.toString(),
                        gapHeight: 5)),
                    Obx(() => CustomTextField(
                        label: "Address",
                        controller: supplierController.address,
                        validation:
                            supplierController.addressValidation.toString(),
                        gapHeight: 5)),
                    InputTextField(
                      label: "Remark",
                      controller: supplierController.remark,
                    ),
                    const SizedBox(height: 20),
                    InputButton(
                        label: "Save",
                        onPress: () async {
                          await supplierController.addSupplier();
                          showSnachBar(
                            supplierController.isSuccess.value,
                            supplierController.isFailed.value, 
                            supplierController.message.value, 
                            supplierController.errorMessage.value
                          );
                          // if (supplierController.isSuccess.value) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       backgroundColor: Colors.green,
                          //       content: Obx(
                          //         () => Text(
                          //             supplierController.message.toString(),
                          //             style: TextStyle(color: Colors.white)),
                          //       ),
                          //     ),
                          //   );
                          //   Get.to(const SupplierPage());
                          // }
                          // if (supplierController.isFailed.value) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       backgroundColor: Colors.red,
                          //       content: Obx(
                          //         () => Text(
                          //             supplierController.errorMessage.toString(),
                          //             style: TextStyle(color: Colors.white)),
                          //       ),
                          //     ),
                          //   );
                          //  Get.to(const SupplierPage());
                          // }
                          
                        },
                        backgroundColor: Colors.green,
                        color: Colors.white),
                  ]),
                ),
              ),
            ),
            if (supplierController.isLoading.value)
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
}
