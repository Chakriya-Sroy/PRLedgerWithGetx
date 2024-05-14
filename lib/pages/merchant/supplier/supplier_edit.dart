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
    // TODO: implement initState
    supplierController.setIsloadingToTrue();
    supplierController.fetchIndividualSupplier(id);
    supplierController.AssignSupplierValueToTextEditor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text('Customer Edit', style: TextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body:  Obx(() =>  supplierController.isLoading.value ? const Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Obx(
              () => CustomTextField(
                  label: "Fullname",
                  controller: supplierController.name,
                  validation: supplierController.nameValidation.toString(),
                  gapHeight: 5),
            ),
            
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
                  supplierController.updateCustomer(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Obx(
                                () => Text(
                                    supplierController.message.toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          );
                  Get.off(const SupplierDetail(),arguments: id);
                },
                backgroundColor: Colors.green,
                color: Colors.white),
          ]),
        ),
      ),)
    );
  }
}