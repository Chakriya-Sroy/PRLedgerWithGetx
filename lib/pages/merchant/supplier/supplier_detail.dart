import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_edit.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_log.dart';
import 'package:laravelsingup/widgets/message/confirm.dart';
import 'package:laravelsingup/widgets/profile/profile_action_button.dart';
import 'package:laravelsingup/widgets/profile/profile_card.dart';
import 'supplier.dart';

class SupplierDetail extends StatefulWidget {
  const SupplierDetail({super.key});

  @override
  State<SupplierDetail> createState() => _SupplierDetailState();
}

class _SupplierDetailState extends State<SupplierDetail> {
  final supplierController = Get.put(SupplierController());
  final String id = Get.arguments;

  @override
  void initState() {
    
    super.initState();
    supplierController.setIsloadingToTrue();
    supplierController.fetchIndividualSupplier(id);
    supplierController.initializeStatusFlags();
  }

  List<String> amount = [];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Get.off(const SupplierLogTransaction(), arguments: id);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.green,
            ),
          ),
        ),
        body: Obx(() => supplierController.supplier.value==null
            ? Center(
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
                          supplier: true,
                          address:
                              supplierController.supplier.value!.address ?? '',
                          fullname: supplierController.supplier.value!.name,
                          email: supplierController.supplier.value!.email ?? '',
                          phone: supplierController.supplier.value!.phone,
                          remark: supplierController.supplier.value!.remark ??'',
                          ),
                      ProfileActionButton(
                        onEdit: () {
                          Get.to(const SupplierEdit(), arguments: id);
                        },
                        onDelete: () {
                          ConfirmMessageBox(context,
                              message:
                                  "All the payables that record under this supplier will be deleted are you sure ?",
                              onPressed: () async {
                            await supplierController.deleteSupplier(id);
                            if (supplierController.isSuccess.value) {
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
                              Get.off(const SupplierPage());
                            }
                            if (supplierController.isFailed.value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Obx(
                                    () => Text(
                                        supplierController.errorMessage.toString(),
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              );
                              Get.off(const SupplierPage());
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )));
  }
}
