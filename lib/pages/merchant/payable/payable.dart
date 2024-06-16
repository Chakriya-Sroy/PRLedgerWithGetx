import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/payable.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/merchant/payable/payable_detail.dart';
import 'package:laravelsingup/pages/merchant/payable/payable_form.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_form.dart';
import 'package:laravelsingup/widgets/empty_state.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_tile.dart';

class PayablePage extends StatefulWidget {
  const PayablePage({super.key});

  @override
  State<PayablePage> createState() => _PayablePageState();
}

class _PayablePageState extends State<PayablePage> {
  final payableController = Get.put(PayableController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      payableController.setIsloadingToTrue();
      payableController.fetchPayables();
      payableController.fetchSupplier();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Payable",
            style: TextStyle(color: Colors.white),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.to(const HomePage());
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child:
                  Obx(
                      () => payableController.lengthofPayableList.value == 0
                          ? WhenListIsEmpty(
                              title: "No Payables Yet, add a Payable ",
                              onPressed: () {
                                Get.to(const PayableForm());
                              })
                          : Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount: payableController.payables.length,
                                itemBuilder: (context, index) {
                                  return PRListTile(
                                      id: payableController.payables[index].id,
                                      name: payableController
                                          .payables[index].supplierrName
                                          .toString(),
                                      amount: payableController
                                          .payables[index].remaining
                                          .toString(),
                                      status: payableController
                                          .payables[index].status,
                                      date: payableController
                                          .payables[index].date
                                          .toString(),
                                      onPressed: () {
                                        Get.to(const PayableDetail(),
                                            arguments: payableController
                                                .payables[index].id);
                                      });
                                },
                              )),
                    ))
        ),
        floatingActionButton:
            Obx(() => payableController.lengthofPayableList.value > 0
                ? FloatingActionButton(
                    onPressed: () {
                      Get.to(const PayableForm());
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox()));
  }
}
