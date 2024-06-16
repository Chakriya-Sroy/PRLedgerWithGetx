import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_detail.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';

class SupplierEdit extends StatefulWidget {
  const SupplierEdit({super.key});

  @override
  State<SupplierEdit> createState() => _SupplierEditState();
}

class _SupplierEditState extends State<SupplierEdit> {
  final supplierController = Get.put(SupplierController());
  final String id = Get.arguments;
  @override
  void initState() {
    super.initState();
    supplierController.setIsloadingToTrue();
    supplierController.fetchIndividualSupplier(id);
    supplierController.AssignSupplierValueToTextEditor();
    supplierController.initializeStatusFlags();
  }

  void showSnachBar(
      bool isSuccess, bool isFailed, String message, String errorMessage) {
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      );
      Get.off(const SupplierDetail(), arguments: id);
    }
    if (isFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage, style: const TextStyle(color: Colors.white)),
        ),
      );
      Get.off(const SupplierDetail(), arguments: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Scaffold(
                appBar: AppBar(
                  title: const Text('Supplier Edit',
                      style: TextStyle(fontSize: 15)),
                  centerTitle: true,
                ),
                body: Obx(
                  () => supplierController.supplier.value == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(children: [
                              Obx(
                                () => CustomTextField(
                                    label: "Fullname",
                                    controller: supplierController.name,
                                    validation: supplierController
                                        .nameValidation
                                        .toString(),
                                    gapHeight: 5),
                              ),
                              Obx(() => CustomTextField(
                                  label: "Phone number",
                                  controller: supplierController.phone,
                                  validation: supplierController.phoneValidation
                                      .toString(),
                                  gapHeight: 5)),
                              Obx(() => CustomTextField(
                                  label: "Email",
                                  controller: supplierController.email,
                                  validation: supplierController.emailValidation
                                      .toString(),
                                  gapHeight: 5)),
                              Obx(() => CustomTextField(
                                  label: "Address",
                                  controller: supplierController.address,
                                  validation: supplierController
                                      .addressValidation
                                      .toString(),
                                  gapHeight: 5)),
                              InputTextField(
                                label: "Remark",
                                controller: supplierController.remark,
                              ),
                              const SizedBox(height: 20),
                              InputButton(
                                  label: "Save",
                                  onPress: () async {
                                    await supplierController.updateSupplier(id);
                                    showSnachBar(
                                        supplierController.isSuccess.value,
                                        supplierController.isFailed.value,
                                        supplierController.message.value,
                                        supplierController.errorMessage.value);
                                    // if (supplierController.isSuccess.value) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //       backgroundColor: Colors.green,
                                    //       content: Obx(
                                    //         () => Text(
                                    //             supplierController
                                    //                 .message.value,
                                    //             style: TextStyle(
                                    //                 color: Colors.white)),
                                    //       ),
                                    //     ),
                                    //   );
                                    //   Get.off(const SupplierDetail(),
                                    //       arguments: id);
                                    // }
                                    // if (supplierController.isFailed.value) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //       backgroundColor: Colors.red,
                                    //       content: Obx(
                                    //         () => Text(
                                    //             supplierController.errorMessage
                                    //                 .toString(),
                                    //             style: TextStyle(
                                    //                 color: Colors.white)),
                                    //       ),
                                    //     ),
                                    //   );
                                    //   Get.off(const SupplierDetail(),
                                    //       arguments: id);
                                    // }
                                  },
                                  backgroundColor: Colors.green,
                                  color: Colors.white),
                            ]),
                          ),
                        ),
                )),
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
