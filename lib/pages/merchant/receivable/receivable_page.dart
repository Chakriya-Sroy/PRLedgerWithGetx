import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/receivable.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/merchant/customer/customer_form.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_detail.dart';
import 'package:laravelsingup/widgets/empty_state.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_tile.dart';
import 'receivable_form.dart';

class ReceivablePage extends StatefulWidget {
  const ReceivablePage({super.key});

  @override
  State<ReceivablePage> createState() => _ReceivablePageState();
}

class _ReceivablePageState extends State<ReceivablePage> {
  final receivableController = Get.put(ReceivableController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      receivableController.setIsloadingToTrue();
      receivableController.fetchReceivable();
      receivableController.fetchCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Receivable',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.to(const HomePage());
            },
          ),
          //  iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () => receivableController.lengthofReceivableList.value == 0
                      ? WhenListIsEmpty(
                          title: 'No Receivable yet, add Receivable ?',
                          onPressed: () {
                            Get.to(const ReceivableForm());
                          })
                      : Obx(() => ListView.builder(
                            shrinkWrap: true,
                            itemCount: receivableController.receivables.length,
                            itemBuilder: (context, index) {
                              return PRListTile(
                                  id: receivableController
                                      .receivables[index].id,
                                  name: receivableController
                                      .receivables[index].customerName
                                      .toString(),
                                  // title: receivableController
                                  //             .receivables[index]
                                  //             .title
                                  //             .length >
                                  //         20
                                  //     ? receivableController
                                  //             .receivables[index].title
                                  //             .substring(0, 15) +
                                  //         '...'
                                  //     : receivableController
                                  //         .receivables[index].title,
                                  amount: receivableController
                                      .receivables[index].remaining
                                      .toString(),
                                  status: receivableController
                                      .receivables[index].status,
                                  date: receivableController
                                      .receivables[index].date
                                      .toString(),
                                  onPressed: () {
                                    Get.to(const ReceivableDetail(),
                                        arguments: receivableController
                                            .receivables[index].id);
                                  });
                            },
                          )),
                ))),
        floatingActionButton:
            Obx(() => receivableController.lengthofReceivableList.value > 0
                ? FloatingActionButton(
                    onPressed: () {
                      Get.to(const ReceivableForm());
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
