import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/pages/merchant/customer/customer.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';

class SupplierForm extends StatelessWidget {
  const SupplierForm({super.key});

  @override
  Widget build(BuildContext context) {
    final SupplierController supplierController = Get.put(SupplierController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Record', style: TextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Obx(() => CustomTextField(
                label: "Fullname",
                controller: supplierController.name,
                validation: supplierController.nameValidation.toString(),
                gapHeight: 5)),
            Obx(() => CustomTextField(
                label: "Phone number",
                controller: supplierController.phone,
                validation: supplierController.phoneValidation.toString(),
                gapHeight: 5)),
            Obx(() => CustomTextField(
                label: "Email",
                controller: supplierController.email,
                validation: supplierController.emailValidation.toString(),
                gapHeight: 5)),
            Obx(() => CustomTextField(
                label: "Address",
                controller: supplierController.address,
                validation: supplierController.addressValidation.toString(),
                gapHeight: 5)),
            InputTextField(
              label: "Remark",
              controller: supplierController.remark,
            ),
            const SizedBox(height: 20),
            InputButton(
                label: "Save",
                onPress: () {
                  supplierController.addSupplier();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Obx(
                        () => Text(supplierController.message.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                  Get.off(const SupplierPage());
                },
                backgroundColor: Colors.green,
                color: Colors.white),
          ]),
        ),
      ),
    );
  }

}